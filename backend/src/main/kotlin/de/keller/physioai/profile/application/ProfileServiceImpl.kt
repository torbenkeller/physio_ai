package de.keller.physioai.profile.application

import de.keller.physioai.profile.domain.Profile
import de.keller.physioai.profile.ports.ProfileRepository
import de.keller.physioai.profile.ports.ProfileService
import de.keller.physioai.shared.AggregateNotFoundException
import de.keller.physioai.shared.ProfileId
import org.apache.logging.log4j.util.Strings
import org.jmolecules.architecture.hexagonal.Application
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

@Application
@Service
class ProfileServiceImpl(
    private val repository: ProfileRepository,
) : ProfileService {
    @Transactional
    override fun createProfile(
        praxisName: String,
        inhaberName: String,
        profilePictureUrl: String?,
        defaultBehandlungenProRezept: Int,
    ): Profile {
        val profile =
            Profile(
                id = ProfileId(UUID.randomUUID()),
                praxisName = praxisName,
                inhaberName = inhaberName,
                profilePictureUrl = Strings.trimToNull(profilePictureUrl),
                defaultBehandlungenProRezept = defaultBehandlungenProRezept,
            )

        return repository.save(profile)
    }

    @Transactional
    @Throws(AggregateNotFoundException::class)
    override fun updateProfile(
        id: ProfileId,
        praxisName: String,
        inhaberName: String,
        profilePictureUrl: String?,
        defaultBehandlungenProRezept: Int,
    ): Profile {
        val existingProfile = repository.findById(id) ?: throw AggregateNotFoundException()

        val updatedProfile =
            existingProfile.copy(
                praxisName = praxisName,
                inhaberName = inhaberName,
                profilePictureUrl = if (existingProfile.profilePictureUrl != Strings.trimToNull(profilePictureUrl)) {
                    Strings.trimToNull(profilePictureUrl)
                } else {
                    existingProfile.profilePictureUrl
                },
                defaultBehandlungenProRezept = defaultBehandlungenProRezept,
            )

        return repository.save(updatedProfile)
    }
}
