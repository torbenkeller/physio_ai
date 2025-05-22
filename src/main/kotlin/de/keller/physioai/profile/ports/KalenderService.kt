package de.keller.physioai.profile.ports

import de.keller.physioai.profile.ProfileId
import java.util.UUID

interface KalenderService {
    fun calculateKalender(
        profileId: ProfileId,
        accessToken: UUID,
    ): String
}
