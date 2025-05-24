package de.keller.physioai.shared

import java.util.UUID

@ConsistentCopyVisibility
data class RezeptId private constructor(
    val id: UUID,
) {
    companion object {
        fun fromUUID(id: UUID): RezeptId = RezeptId(id)

        fun generate(): RezeptId = RezeptId(UUID.randomUUID())
    }
}
