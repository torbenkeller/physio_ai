package de.keller.physioai.profile.application

import de.keller.physioai.profile.ports.ProfileRepository
import de.keller.physioai.shared.AggregateNotFoundException
import de.keller.physioai.shared.ExternalCalendarService
import de.keller.physioai.shared.ExternalCalendarService.ExternalCalendarEvent
import de.keller.physioai.shared.ProfileId
import net.fortuna.ical4j.data.CalendarBuilder
import net.fortuna.ical4j.model.Calendar
import net.fortuna.ical4j.model.Period
import net.fortuna.ical4j.model.component.VEvent
import org.jmolecules.architecture.hexagonal.Application
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import java.net.URI
import java.time.Instant
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.temporal.Temporal
import java.util.concurrent.ConcurrentHashMap

@Application
@Service
class ExternalCalendarServiceImpl(
    private val profileRepository: ProfileRepository,
) : ExternalCalendarService {
    private val logger = LoggerFactory.getLogger(ExternalCalendarServiceImpl::class.java)
    private val berlinZone = ZoneId.of("Europe/Berlin")

    // Cache for parsed calendars: URL -> (Calendar, FetchTime)
    private data class CachedCalendar(
        val calendar: Calendar,
        val fetchedAt: Instant,
    )

    private val calendarCache = ConcurrentHashMap<String, CachedCalendar>()
    private val cacheTtlMinutes = 5L

    override fun getExternalEvents(
        profileId: ProfileId,
        startDate: LocalDate,
        endDate: LocalDate,
    ): List<ExternalCalendarEvent> {
        val profile = profileRepository.findById(profileId)
            ?: throw AggregateNotFoundException()

        val calendarUrl = profile.externalCalendarUrl
        if (calendarUrl.isNullOrBlank()) {
            return emptyList()
        }

        return try {
            fetchAndParseCalendar(calendarUrl, startDate, endDate)
        } catch (e: Exception) {
            logger.warn("Failed to fetch external calendar for profile ${profileId.id}: ${e.message}")
            emptyList()
        }
    }

    private fun getOrFetchCalendar(url: String): Calendar {
        val now = Instant.now()
        val cached = calendarCache[url]

        // Return cached calendar if still valid
        if (cached != null) {
            val age = java.time.Duration.between(cached.fetchedAt, now)
            if (age.toMinutes() < cacheTtlMinutes) {
                logger.debug("Using cached calendar for URL: $url (age: ${age.toSeconds()}s)")
                return cached.calendar
            }
        }

        // Fetch and parse calendar
        logger.debug("Fetching calendar from URL: $url")
        val inputStream = URI(url).toURL().openStream()
        // Relaxed parsing is configured via ical4j.properties
        val builder = CalendarBuilder()
        val calendar = builder.build(inputStream)

        // Cache the result
        calendarCache[url] = CachedCalendar(calendar, now)
        return calendar
    }

    private fun fetchAndParseCalendar(
        url: String,
        startDate: LocalDate,
        endDate: LocalDate,
    ): List<ExternalCalendarEvent> {
        val calendar = getOrFetchCalendar(url)

        val startDateTime = startDate.atStartOfDay()
        val endDateTime = endDate.plusDays(1).atStartOfDay()

        // Create a period for the date range to expand recurring events
        // Use Temporal to handle both LocalDateTime and ZonedDateTime results from iCal4j
        val periodStart: Temporal = startDate.atStartOfDay()
        val periodEnd: Temporal = endDate.plusDays(1).atStartOfDay()
        val period = Period<Temporal>(periodStart, periodEnd)

        val events = mutableListOf<ExternalCalendarEvent>()

        for (event in calendar.getComponents<VEvent>(VEvent.VEVENT)) {
            // Check if this is a recurring event
            val rruleProperty = event.getProperty<net.fortuna.ical4j.model.property.RRule<*>>("RRULE").orElse(null)

            if (rruleProperty != null) {
                // Expand recurring event into individual occurrences
                val occurrences = expandRecurringEvent(event, period)
                events.addAll(occurrences)
            } else {
                // Non-recurring event - use original logic
                val parsed = parseEvent(event, startDateTime, endDateTime)
                if (parsed != null) {
                    events.add(parsed)
                }
            }
        }

        return events
    }

    private fun expandRecurringEvent(
        event: VEvent,
        period: Period<Temporal>,
    ): List<ExternalCalendarEvent> {
        val uidProperty = event.getProperty<net.fortuna.ical4j.model.property.Uid>("UID").orElse(null)
            ?: return emptyList()
        val uid = uidProperty.value

        val summaryProperty = event.getProperty<net.fortuna.ical4j.model.property.Summary>("SUMMARY").orElse(null)
        val summary = summaryProperty?.value ?: "Privater Termin"

        val dtStartProperty =
            event.getProperty<net.fortuna.ical4j.model.property.DtStart<*>>("DTSTART").orElse(null)
                ?: return emptyList()

        @Suppress("UNCHECKED_CAST")
        val startTemporal: Temporal = dtStartProperty.date as Temporal
        val isAllDay = startTemporal is LocalDate

        // Calculate event duration
        val dtEndProperty = event.getProperty<net.fortuna.ical4j.model.property.DtEnd<*>>("DTEND").orElse(null)
        val eventStart = temporalToLocalDateTime(startTemporal)

        @Suppress("UNCHECKED_CAST")
        val eventEnd = if (dtEndProperty != null) {
            temporalToLocalDateTime(dtEndProperty.date as Temporal)
        } else {
            if (isAllDay) eventStart.plusDays(1) else eventStart.plusHours(1)
        }
        val durationMinutes = java.time.Duration
            .between(eventStart, eventEnd)
            .toMinutes()

        // Get EXDATE (excluded dates) for this event
        val exdates = mutableSetOf<LocalDate>()
        event.getProperties<net.fortuna.ical4j.model.property.ExDate<*>>("EXDATE").forEach { exdate ->
            @Suppress("UNCHECKED_CAST")
            val dates = exdate.dates as? List<Temporal> ?: return@forEach
            dates.forEach { date ->
                val localDateTime = temporalToLocalDateTime(date)
                exdates.add(localDateTime.toLocalDate())
            }
        }

        // Calculate occurrences within the period
        return try {
            val recurrenceSet = event.calculateRecurrenceSet<Temporal>(period)
            recurrenceSet
                .mapNotNull { occurrence ->
                    @Suppress("UNCHECKED_CAST")
                    val startTemporal = occurrence.start as? Temporal ?: return@mapNotNull null
                    val occurrenceStart = temporalToLocalDateTime(startTemporal)

                    // Filter out excluded dates
                    if (exdates.contains(occurrenceStart.toLocalDate())) {
                        return@mapNotNull null
                    }

                    val occurrenceEnd = occurrenceStart.plusMinutes(durationMinutes)

                    ExternalCalendarEvent(
                        uid = "$uid-$occurrenceStart",
                        title = summary,
                        startZeit = occurrenceStart,
                        endZeit = occurrenceEnd,
                        isAllDay = isAllDay,
                    )
                }
        } catch (e: Exception) {
            logger.warn("Failed to expand recurring event $uid: ${e.message}")
            emptyList()
        }
    }

    private fun parseEvent(
        event: VEvent,
        rangeStart: LocalDateTime,
        rangeEnd: LocalDateTime,
    ): ExternalCalendarEvent? {
        val uidProperty = event.getProperty<net.fortuna.ical4j.model.property.Uid>("UID").orElse(null)
            ?: return null
        val uid = uidProperty.value

        val summaryProperty = event.getProperty<net.fortuna.ical4j.model.property.Summary>("SUMMARY").orElse(null)
        val summary = summaryProperty?.value ?: "Privater Termin"

        val dtStartProperty =
            event.getProperty<net.fortuna.ical4j.model.property.DtStart<*>>("DTSTART").orElse(null)
                ?: return null

        @Suppress("UNCHECKED_CAST")
        val startTemporal: Temporal = dtStartProperty.date as Temporal

        val isAllDay = startTemporal is LocalDate

        val eventStart = temporalToLocalDateTime(startTemporal)

        val dtEndProperty = event.getProperty<net.fortuna.ical4j.model.property.DtEnd<*>>("DTEND").orElse(null)

        @Suppress("UNCHECKED_CAST")
        val eventEnd = if (dtEndProperty != null) {
            temporalToLocalDateTime(dtEndProperty.date as Temporal)
        } else {
            if (isAllDay) {
                eventStart.plusDays(1)
            } else {
                eventStart.plusHours(1)
            }
        }

        if (eventEnd.isBefore(rangeStart) || eventStart.isAfter(rangeEnd)) {
            return null
        }

        return ExternalCalendarEvent(
            uid = uid,
            title = summary,
            startZeit = eventStart,
            endZeit = eventEnd,
            isAllDay = isAllDay,
        )
    }

    private fun temporalToLocalDateTime(temporal: Temporal): LocalDateTime =
        when (temporal) {
            is LocalDate -> temporal.atStartOfDay()
            is LocalDateTime -> temporal
            is java.time.ZonedDateTime -> temporal.withZoneSameInstant(berlinZone).toLocalDateTime()
            is java.time.OffsetDateTime -> temporal.atZoneSameInstant(berlinZone).toLocalDateTime()
            is java.time.Instant -> temporal.atZone(berlinZone).toLocalDateTime()
            else -> throw IllegalArgumentException("Unsupported temporal type: ${temporal::class}")
        }
}
