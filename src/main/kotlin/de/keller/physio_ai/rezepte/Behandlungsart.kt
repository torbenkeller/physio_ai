package de.keller.physio_ai.rezepte

import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table
import java.util.*


public data class BehandlungsartId(val id: UUID) {
    companion object {
        fun fromUUID(id: UUID): BehandlungsartId = BehandlungsartId(id)

        fun generate(): BehandlungsartId = BehandlungsartId(UUID.randomUUID())
    }
}


@Table("behandlungsarten")
data class Behandlungsart(
    @Id
    var id: BehandlungsartId,
    var name: String,
    var preis: Double,
) {
}
