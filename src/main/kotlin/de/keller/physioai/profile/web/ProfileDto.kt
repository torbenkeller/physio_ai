package de.keller.physioai.profile.web

import de.keller.physioai.profile.Profile
import java.util.UUID

data class ProfileDto(
    val id: UUID,
    val praxisName: String,
    val inhaberName: String,
    val profilePictureUrl: String?,
) {
    companion object {
        fun fromProfile(profile: Profile): ProfileDto =
            ProfileDto(
                id = profile.id.id,
                praxisName = profile.praxisName,
                inhaberName = profile.inhaberName,
                profilePictureUrl = profile.profilePictureUrl,
            )
    }
}

data class ProfileForm(
    val praxisName: String?,
    val inhaberName: String?,
    val profilePictureUrl: String?,
)
