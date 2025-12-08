package de.keller.physioai.behandlungen.adapters.api

import de.keller.physioai.behandlungen.domain.BehandlungAggregate
import java.time.LocalDateTime
import java.util.UUID

data class BehandlungDto(
    val id: UUID,
    val patientId: UUID,
    val startZeit: LocalDateTime,
    val endZeit: LocalDateTime,
    val rezeptId: UUID?,
    val behandlungsartId: UUID?,
    val bemerkung: String?,
) {
    companion object {
        fun fromDomain(aggregate: BehandlungAggregate): BehandlungDto =
            BehandlungDto(
                id = aggregate.id.id,
                patientId = aggregate.patientId.id,
                startZeit = aggregate.startZeit,
                endZeit = aggregate.endZeit,
                rezeptId = aggregate.rezeptId?.id,
                behandlungsartId = aggregate.behandlungsartId?.id,
                bemerkung = aggregate.bemerkung,
            )
    }
}
