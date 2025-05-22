package de.keller.physioai.rezepte.ports

import com.fasterxml.jackson.databind.PropertyNamingStrategies
import com.fasterxml.jackson.databind.annotation.JsonNaming
import java.time.LocalDate

@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy::class)
data class EingelesenesRezeptRaw(
    val ausgestelltAm: LocalDate,
    val titel: String?,
    val vorname: String,
    val nachname: String,
    val strasse: String,
    val hausnummer: String,
    val postleitzahl: String,
    val stadt: String,
    val geburtstag: LocalDate,
    val rezeptpositionen: List<EingelesenesRezeptPosRaw>,
)

data class EingelesenesRezeptPosRaw(
    val anzahl: Int,
    val behandlung: String,
)
