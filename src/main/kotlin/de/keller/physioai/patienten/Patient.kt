package de.keller.physioai.patienten

import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table
import java.time.LocalDate
import java.util.UUID

public data class PatientId(
    val id: UUID,
) {
    companion object {
        fun fromUUID(id: UUID): PatientId = PatientId(id)

        fun generate(): PatientId = PatientId(UUID.randomUUID())
    }
}

@Table("patienten")
data class Patient(
    @Id
    val id: PatientId,
    val titel: String?,
    val vorname: String,
    val nachname: String,
    val strasse: String?,
    val hausnummer: String?,
    val plz: String?,
    val stadt: String?,
    val telMobil: String?,
    val telFestnetz: String?,
    val email: String?,
    val geburtstag: LocalDate?,
)
