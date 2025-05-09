package de.keller.physioai.patienten.web

import de.keller.physioai.patienten.Patient
import java.time.LocalDate
import java.util.UUID

data class PatientDto(
    val id: UUID,
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
) {
    companion object {
        fun fromPatient(patient: Patient): PatientDto =
            PatientDto(
                id = patient.id.id,
                titel = patient.titel,
                vorname = patient.vorname,
                nachname = patient.nachname,
                strasse = patient.strasse,
                hausnummer = patient.hausnummer,
                plz = patient.plz,
                stadt = patient.stadt,
                telMobil = patient.telMobil,
                telFestnetz = patient.telFestnetz,
                email = patient.email,
                geburtstag = patient.geburtstag,
            )
    }
}
