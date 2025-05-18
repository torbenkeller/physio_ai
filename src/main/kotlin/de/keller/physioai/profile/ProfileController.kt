package de.keller.physioai.profile

import de.keller.physioai.profile.web.ProfileDto
import de.keller.physioai.profile.web.ProfileForm
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@RestController
@RequestMapping("/profiles")
class ProfileController
    @Autowired
    constructor(
        private val profileService: ProfileService,
    ) {
        @GetMapping
        fun getProfile(): ProfileDto? = profileService.getProfile()?.let { ProfileDto.fromProfile(it) }

        @PostMapping
        fun createProfile(
            @RequestBody profileForm: ProfileForm,
        ): ProfileDto {
            val profile = profileService.createProfile(profileForm)
            return ProfileDto.fromProfile(profile)
        }

        @PatchMapping("/{id}")
        fun updateProfile(
            @PathVariable id: UUID,
            @RequestBody profileForm: ProfileForm,
        ): ProfileDto? =
            profileService
                .updateProfile(
                    id = ProfileId.fromUUID(id),
                    profileForm = profileForm,
                )?.let { ProfileDto.fromProfile(it) }
    }
