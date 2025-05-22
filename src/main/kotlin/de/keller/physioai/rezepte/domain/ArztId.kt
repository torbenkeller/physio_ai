package de.keller.physioai.rezepte.domain

import java.util.UUID

@ConsistentCopyVisibility
data class ArztId private constructor(
    val id: UUID,
) {
    companion object {
        fun fromUUID(id: UUID): ArztId = ArztId(id)

        fun generate(): ArztId = ArztId(UUID.randomUUID())
    }
}
