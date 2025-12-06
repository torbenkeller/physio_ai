package de.keller.physioai.patienten.adapters.api

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
    val behandlungenProRezept: Int?,
) {
    companion object {
        fun fromPatient(p: Patient): PatientDto =
            PatientDto(
                id = p.id.id,
                titel = p.titel,
                vorname = p.vorname,
                nachname = p.nachname,
                strasse = p.strasse,
                hausnummer = p.hausnummer,
                plz = p.plz,
                stadt = p.stadt,
                telMobil = p.telMobil,
                telFestnetz = p.telFestnetz,
                email = p.email,
                geburtstag = p.geburtstag,
                behandlungenProRezept = p.behandlungenProRezept,
            )
    }
}
