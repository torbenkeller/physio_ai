package de.keller.physioai.profile

import de.keller.physioai.profile.web.ProfileForm
import de.keller.physioai.shared.web.AggregateNotFoundException
import org.apache.logging.log4j.util.Strings
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class ProfileService
    @Autowired
    constructor(
        private val repository: ProfileRepository,
    ) {
        @Transactional(readOnly = true)
        fun getProfile(): Profile? = repository.findAll().firstOrNull()

        @Transactional
        fun createProfile(profileForm: ProfileForm): Profile {
            val profile =
                Profile(
                    id = ProfileId.generate(),
                    praxisName = profileForm.praxisName ?: "",
                    inhaberName = profileForm.inhaberName ?: "",
                    profilePictureUrl = Strings.trimToNull(profileForm.profilePictureUrl),
                )

            return repository.save(profile) ?: profile
        }

        @Transactional
        @Throws(AggregateNotFoundException::class)
        fun updateProfile(
            id: ProfileId,
            profileForm: ProfileForm,
        ): Profile {
            val existingProfile = repository.findById(id) ?: throw AggregateNotFoundException()

            val updatedProfile =
                existingProfile.copy(
                    praxisName = profileForm.praxisName ?: existingProfile.praxisName,
                    inhaberName = profileForm.inhaberName ?: existingProfile.inhaberName,
                    profilePictureUrl = if (profileForm.profilePictureUrl !=
                        null
                    ) {
                        Strings.trimToNull(profileForm.profilePictureUrl)
                    } else {
                        existingProfile.profilePictureUrl
                    },
                )

            return repository.save(updatedProfile) ?: updatedProfile
        }
    }
