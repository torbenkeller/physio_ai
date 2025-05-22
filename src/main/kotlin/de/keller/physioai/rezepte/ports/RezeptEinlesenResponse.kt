package de.keller.physioai.rezepte.ports

import de.keller.physioai.patienten.Patient
import de.keller.physioai.rezepte.adapters.rest.BehandlungsartDto
import java.time.LocalDate

data class EingelesenerPatientDto(
    val titel: String?,
    val vorname: String,
    val nachname: String,
    val strasse: String,
    val hausnummer: String,
    val postleitzahl: String,
    val stadt: String,
    val geburtstag: LocalDate,
)

data class EingelesenesRezeptDto(
    val ausgestelltAm: LocalDate,
    val rezeptpositionen: List<EingelesenesRezeptPosDto>,
)

data class EingelesenesRezeptPosDto(
    val anzahl: Int,
    val behandlungsart: BehandlungsartDto,
)

data class RezeptEinlesenResponse(
    val existingPatient: Patient?,
    val patient: EingelesenerPatientDto,
    val rezept: EingelesenesRezeptDto,
)
