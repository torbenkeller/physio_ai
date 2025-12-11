package de.keller.physioai.profile.application

import de.keller.physioai.profile.ports.ExternalCalendarService
import de.keller.physioai.profile.ports.ExternalCalendarService.ExternalCalendarEvent
import de.keller.physioai.profile.ports.ProfileRepository
import de.keller.physioai.shared.AggregateNotFoundException
import de.keller.physioai.shared.ProfileId
import net.fortuna.ical4j.data.CalendarBuilder
import net.fortuna.ical4j.model.component.VEvent
import org.jmolecules.architecture.hexagonal.Application
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import java.net.URI
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.temporal.Temporal

@Application
@Service
class ExternalCalendarServiceImpl(
    private val profileRepository: ProfileRepository,
) : ExternalCalendarService {
    private val logger = LoggerFactory.getLogger(ExternalCalendarServiceImpl::class.java)
    private val berlinZone = ZoneId.of("Europe/Berlin")

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

    private fun fetchAndParseCalendar(
        url: String,
        startDate: LocalDate,
        endDate: LocalDate,
    ): List<ExternalCalendarEvent> {
        val inputStream = URI(url).toURL().openStream()
        val builder = CalendarBuilder()
        val calendar = builder.build(inputStream)

        val startDateTime = startDate.atStartOfDay()
        val endDateTime = endDate.plusDays(1).atStartOfDay()

        return calendar
            .getComponents<VEvent>()
            .mapNotNull { event -> parseEvent(event, startDateTime, endDateTime) }
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
            is java.time.Instant -> temporal.atZone(berlinZone).toLocalDateTime()
            else -> throw IllegalArgumentException("Unsupported temporal type: ${temporal::class}")
        }
}
