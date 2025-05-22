package de.keller.physioai.rezepte.domain

import java.util.UUID

@ConsistentCopyVisibility
data class BehandlungsartId private constructor(
    val id: UUID,
) {
    companion object {
        fun fromUUID(id: UUID): BehandlungsartId = BehandlungsartId(id)

        fun generate(): BehandlungsartId = BehandlungsartId(UUID.randomUUID())
    }
}
