package de.keller.physioai.profile.ports

import de.keller.physioai.profile.domain.Profile
import de.keller.physioai.shared.ProfileId
import org.jmolecules.architecture.hexagonal.PrimaryPort

@PrimaryPort
interface ProfileService {
    fun createProfile(
        praxisName: String,
        inhaberName: String,
        profilePictureUrl: String?,
        defaultBehandlungenProRezept: Int = 8,
    ): Profile

    fun updateProfile(
        id: ProfileId,
        praxisName: String,
        inhaberName: String,
        profilePictureUrl: String?,
        defaultBehandlungenProRezept: Int,
        externalCalendarUrl: String?,
    ): Profile
}
