package de.keller.physioai.profile.ports

import de.keller.physioai.shared.ProfileId
import org.jmolecules.architecture.hexagonal.PrimaryPort
import java.util.UUID

@PrimaryPort
interface KalenderService {
    fun calculateKalender(
        profileId: ProfileId,
        accessToken: UUID,
    ): String
}
