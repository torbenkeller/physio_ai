package de.keller.physioai.patienten.adapters.api

import jakarta.validation.constraints.Email
import jakarta.validation.constraints.Past
import org.springframework.format.annotation.DateTimeFormat
import java.time.LocalDate

data class PatientFormDto(
    val titel: String?,
    val vorname: String?,
    val nachname: String?,
    val strasse: String?,
    val hausnummer: String?,
    val plz: String?,
    val stadt: String?,
    val telMobil: String?,
    val telFestnetz: String?,
    @Email
    val email: String?,
    @Past
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    val geburtstag: LocalDate?,
)
