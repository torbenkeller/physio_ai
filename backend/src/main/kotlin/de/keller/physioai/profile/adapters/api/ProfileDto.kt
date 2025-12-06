package de.keller.physioai.profile.adapters.api

import de.keller.physioai.profile.domain.Profile
import java.util.UUID

data class ProfileDto(
    val id: UUID,
    val praxisName: String,
    val inhaberName: String,
    val profilePictureUrl: String?,
    val defaultBehandlungenProRezept: Int,
    val calenderUrl: String,
) {
    companion object {
        fun fromProfile(
            profile: Profile,
            host: String,
        ): ProfileDto =
            ProfileDto(
                id = profile.id.id,
                praxisName = profile.praxisName,
                inhaberName = profile.inhaberName,
                profilePictureUrl = profile.profilePictureUrl,
                defaultBehandlungenProRezept = profile.defaultBehandlungenProRezept,
                calenderUrl = profile.getCalenderUrl(host),
            )
    }
}
