package de.keller.physioai.profile

import de.keller.physioai.shared.web.AggregateNotFoundException
import net.fortuna.ical4j.model.Calendar
import net.fortuna.ical4j.model.TimeZoneRegistryFactory
import net.fortuna.ical4j.model.property.XProperty
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.access.AccessDeniedException
import org.springframework.stereotype.Service
import java.util.UUID

@Service
class KalenderService
    @Autowired
    constructor(
        val profileRepository: ProfileRepository,
    ) {
        fun calculateKalender(
            profileId: ProfileId,
            accessToken: UUID,
        ): String {
            val profile = profileRepository.findById(profileId)
                ?: throw AggregateNotFoundException()

            // Verify that the provided access token matches the profile's access token
            if (profile.accessToken != accessToken) {
                throw AccessDeniedException("Access Denied")
            }

            // Create a new calendar
            val calendar = Calendar()
                .withProdId("-//Physio AI//Kalender//DE")
                .withDefaults()
                .withProperty(XProperty("X-WR-CALNAME", "Physio AI Kalender"))
                .withProperty(XProperty("X-WR-TIMEZONE", "Europe/Berlin"))
                .fluentTarget

            // Add the Berlin timezone
            val registry = TimeZoneRegistryFactory.getInstance().createRegistry()
            val timezone = registry.getTimeZone("Europe/Berlin")
            val vTimezone = timezone.vTimeZone

            calendar.componentList.add(vTimezone)

            // At this point, no events are added as requested (hardcoded empty calendar)
            return calendar.toString()
        }
    }
