package de.keller.physioai.profile.adapters.api

import de.keller.physioai.profile.ports.ExternalCalendarService
import de.keller.physioai.profile.ports.KalenderService
import de.keller.physioai.profile.ports.ProfileRepository
import de.keller.physioai.profile.ports.ProfileService
import de.keller.physioai.shared.AggregateNotFoundException
import de.keller.physioai.shared.ProfileId
import jakarta.validation.Valid
import org.jmolecules.architecture.hexagonal.PrimaryAdapter
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.validation.annotation.Validated
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.time.LocalDate
import java.util.UUID

@PrimaryAdapter
@Validated
@RestController
@RequestMapping("/profile")
class ProfileController
    @Autowired
    constructor(
        private val profileService: ProfileService,
        private val profileRepository: ProfileRepository,
        private val kalenderService: KalenderService,
        private val externalCalendarService: ExternalCalendarService,
        @Value("\${server.host:http://localhost:8080}")
        private val host: String,
    ) {
        @GetMapping
        fun getProfile(): ProfileDto? {
            val id = UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a")

            val profile = profileRepository.findById(ProfileId(id))
                ?: throw AggregateNotFoundException()

            return ProfileDto.Companion.fromProfile(profile, host)
        }

        @PostMapping
        fun createProfile(
            @RequestBody @Valid profileFormDto: ProfileFormDto,
        ): ProfileDto {
            val profile = profileService.createProfile(
                praxisName = profileFormDto.praxisName,
                inhaberName = profileFormDto.inhaberName,
                profilePictureUrl = profileFormDto.profilePictureUrl,
                defaultBehandlungenProRezept = profileFormDto.defaultBehandlungenProRezept,
            )
            return ProfileDto.Companion.fromProfile(profile, host)
        }

        @PatchMapping
        fun updateProfile(
            @RequestBody @Valid profileFormDto: ProfileFormDto,
        ): ProfileDto? {
            val id = UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a")

            return profileService
                .updateProfile(
                    id = ProfileId(id),
                    praxisName = profileFormDto.praxisName,
                    inhaberName = profileFormDto.inhaberName,
                    profilePictureUrl = profileFormDto.profilePictureUrl,
                    defaultBehandlungenProRezept = profileFormDto.defaultBehandlungenProRezept,
                    externalCalendarUrl = profileFormDto.externalCalendarUrl,
                ).let { ProfileDto.Companion.fromProfile(it, host) }
        }

        @GetMapping("/external-calendar/events")
        fun getExternalCalendarEvents(
            @RequestParam startDate: String,
            @RequestParam endDate: String,
        ): List<ExternalCalendarEventDto> {
            val id = UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a")

            val events = externalCalendarService.getExternalEvents(
                profileId = ProfileId(id),
                startDate = LocalDate.parse(startDate),
                endDate = LocalDate.parse(endDate),
            )

            return events.map { event ->
                ExternalCalendarEventDto(
                    id = event.uid,
                    title = event.title,
                    startZeit = event.startZeit,
                    endZeit = event.endZeit,
                    isAllDay = event.isAllDay,
                )
            }
        }

        @GetMapping("/{id}/kalender", produces = ["text/calendar"])
        fun getKalender(
            @PathVariable id: UUID,
            @RequestParam accessToken: UUID,
        ): String = kalenderService.calculateKalender(ProfileId(id), accessToken)
    }
