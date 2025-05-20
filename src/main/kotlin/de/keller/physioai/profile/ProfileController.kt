package de.keller.physioai.profile

import de.keller.physioai.profile.web.ProfileDto
import de.keller.physioai.profile.web.ProfileForm
import de.keller.physioai.shared.web.AggregateNotFoundException
import org.springframework.beans.factory.annotation.Autowired
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
        private val kalenderService: KalenderService,
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
        ): String = kalenderService.calculateKalender(ProfileId.fromUUID(id), accessToken)
    }
