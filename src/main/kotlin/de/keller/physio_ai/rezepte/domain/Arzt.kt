package de.keller.physio_ai.rezepte.domain

import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table
import java.util.*

public data class ArztId(val id: UUID) {
    companion object {
        fun fromUUID(id: UUID): ArztId = ArztId(id)

        fun generate(): ArztId = ArztId(UUID.randomUUID())
    }
}

@Table("aerzte")
data class Arzt(
    @Id
    val id: ArztId,
    val name: String
) {
}
