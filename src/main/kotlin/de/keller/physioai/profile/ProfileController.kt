package de.keller.physioai.profile

import de.keller.physioai.profile.web.ProfileDto
import de.keller.physioai.profile.web.ProfileForm
import de.keller.physioai.shared.web.AggregateNotFoundException
import net.fortuna.ical4j.model.Calendar
import net.fortuna.ical4j.model.TimeZoneRegistryFactory
import net.fortuna.ical4j.model.property.XProperty
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@RestController
@RequestMapping("/profile")
class ProfileController
    @Autowired
    constructor(
        private val profileService: ProfileService,
        private val profileRepository: ProfileRepository,
    ) {
        @GetMapping
        fun getProfile(): ProfileDto? {
            val id = UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a")

            val profile = profileRepository.findById(ProfileId.fromUUID(id))
                ?: throw AggregateNotFoundException()

            return ProfileDto.fromProfile(profile)
        }

        @PostMapping
        fun createProfile(
            @RequestBody profileForm: ProfileForm,
        ): ProfileDto {
            val profile = profileService.createProfile(profileForm)
            return ProfileDto.fromProfile(profile)
        }

        @PatchMapping
        fun updateProfile(
            @RequestBody profileForm: ProfileForm,
        ): ProfileDto? {
            val id = UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a")

            return profileService
                .updateProfile(
                    id = ProfileId.fromUUID(id),
                    profileForm = profileForm,
                ).let { ProfileDto.fromProfile(it) }
        }

        @GetMapping("/{id}/kalender", produces = ["text/calendar"])
        fun getKalender(
            @PathVariable id: UUID,
            @RequestParam accessToken: UUID,
        ): ResponseEntity<String> {
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

            return ResponseEntity
            .ok()
            .body(calendar.toString())
    }
    }
