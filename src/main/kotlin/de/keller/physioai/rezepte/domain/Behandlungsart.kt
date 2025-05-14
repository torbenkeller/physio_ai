package de.keller.physioai.rezepte.domain

import org.springframework.data.annotation.Id
import org.springframework.data.annotation.Version
import org.springframework.data.relational.core.mapping.Table
import java.util.UUID

public data class BehandlungsartId(
    val id: UUID,
) {
    companion object {
        fun fromUUID(id: UUID): BehandlungsartId = BehandlungsartId(id)

        fun generate(): BehandlungsartId = BehandlungsartId(UUID.randomUUID())
    }
}

@Table("behandlungsarten")
data class Behandlungsart(
    @Id
    val id: BehandlungsartId,
    val name: String,
    val preis: Double,
    @Version
    val version: Int = 0,
)
