package de.keller.physioai.patienten

import java.time.LocalDate

interface Patient {
    val id: PatientId
    val titel: String?
    val vorname: String
    val nachname: String
    val strasse: String?
    val hausnummer: String?
    val plz: String?
    val stadt: String?
    val telMobil: String?
    val telFestnetz: String?
    val email: String?
    val geburtstag: LocalDate?
}
