package de.keller.physioai.rezepte.web

import de.keller.physioai.rezepte.domain.Behandlung
import java.time.LocalDateTime
import java.util.UUID

data class BehandlungDto(
    val id: UUID,
    val startZeit: LocalDateTime,
    val endZeit: LocalDateTime,
) {
    companion object {
        fun fromBehandlung(behandlung: Behandlung): BehandlungDto =
            BehandlungDto(
                id = behandlung.id,
                startZeit = behandlung.startZeit,
                endZeit = behandlung.endZeit,
            )
    }
}

data class BehandlungCreateDto(
    val startZeit: LocalDateTime,
    val endZeit: LocalDateTime,
)
