package de.keller.physioai.patienten

import java.util.UUID

@ConsistentCopyVisibility
public data class PatientId private constructor(
    val id: UUID,
) {
    companion object {
        fun fromUUID(id: UUID): PatientId = PatientId(id)

        fun generate(): PatientId = PatientId(UUID.randomUUID())
    }
}
