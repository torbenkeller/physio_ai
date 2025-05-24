package de.keller.physioai.shared

import java.util.UUID

@ConsistentCopyVisibility
data class ProfileId private constructor(
    val id: UUID,
) {
    companion object {
        fun fromUUID(id: UUID): ProfileId = ProfileId(id)

        fun generate(): ProfileId = ProfileId(UUID.randomUUID())
    }
}
