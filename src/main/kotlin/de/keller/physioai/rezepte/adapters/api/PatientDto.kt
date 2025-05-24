package de.keller.physioai.rezepte.adapters.api

import de.keller.physioai.patienten.Patient
import java.util.UUID

data class PatientDto(
    val id: UUID,
    val vorname: String,
    val nachname: String,
) {
    companion object {
        fun fromDomain(patient: Patient): PatientDto =
            PatientDto(
                id = patient.id.id,
                vorname = patient.vorname,
                nachname = patient.nachname,
            )
    }
}
