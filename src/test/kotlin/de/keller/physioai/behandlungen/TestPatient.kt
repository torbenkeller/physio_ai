package de.keller.physioai.behandlungen

import de.keller.physioai.patienten.Patient
import de.keller.physioai.shared.PatientId
import java.time.LocalDate

data class TestPatient(
    override val id: PatientId,
    override val titel: String?,
    override val vorname: String,
    override val nachname: String,
    override val strasse: String?,
    override val hausnummer: String?,
    override val plz: String?,
    override val stadt: String?,
    override val telMobil: String?,
    override val telFestnetz: String?,
    override val email: String?,
    override val geburtstag: LocalDate?,
) : Patient
