package de.keller.physioai.rezepte.adapters.rest

import de.keller.physioai.patienten.Patient
import de.keller.physioai.rezepte.domain.Arzt
import de.keller.physioai.rezepte.domain.Behandlungsart
import de.keller.physioai.rezepte.domain.Rezept
import java.time.LocalDate
import java.util.UUID

data class RezeptDto(
    val id: UUID,
    val patient: PatientDto,
    val ausgestelltAm: LocalDate,
    val ausgestelltVon: ArztDto?,
    val preisGesamt: Double,
    val rechnung: RechnungDto?,
    val positionen: List<RezeptPosDto>,
) {
    companion object {
        fun fromDomain(
            rezept: Rezept,
            patient: Patient,
            arzt: Arzt?,
        ): RezeptDto =
            RezeptDto(
                id = rezept.id.id,
                patient = PatientDto.fromDomain(patient),
                ausgestelltAm = rezept.ausgestelltAm,
                ausgestelltVon = if (arzt != null) ArztDto.fromDomain(arzt) else null,
                positionen =
                    rezept.positionen
                        .map { pos ->
                            RezeptPosDto(
                                anzahl = pos.anzahl,
                                behandlungsart =
                                    BehandlungsartDto(
                                        preis = pos.einzelpreis,
                                        id = pos.behandlungsartId.id,
                                        name = pos.behandlungsartName,
                                    ),
                            )
                        }.toList(),
                rechnung = null,
                preisGesamt = rezept.preisGesamt,
            )
    }
}

data class ArztDto(
    val id: UUID,
    val name: String,
) {
    companion object {
        fun fromDomain(arzt: Arzt): ArztDto =
            ArztDto(
                id = arzt.id.id,
                name = arzt.name,
            )
    }
}

data class RechnungDto(
    val rechnungsnummer: String,
    val status: RezeptRechnungStatus,
)

enum class RezeptRechnungStatus {
    ERSTELLT,
    OFFEN,
    BEZAHLT,
}

data class RezeptPosDto(
    val behandlungsart: BehandlungsartDto,
    val anzahl: Int,
)

data class BehandlungsartDto(
    val id: UUID,
    val name: String,
    val preis: Double,
) {
    companion object {
        fun fromBehandlungsart(behandlungsart: Behandlungsart): BehandlungsartDto =
            BehandlungsartDto(
                id = behandlungsart.id.id,
                name = behandlungsart.name,
                preis = behandlungsart.preis,
            )
    }
}

/**
 * DTO for creating a new Rezept
 */
data class RezeptCreateDto(
    val patientId: UUID,
    val ausgestelltAm: LocalDate,
    val positionen: List<RezeptPosCreateDto>,
)

/**
 * DTO for updating an existing Rezept
 */
data class RezeptUpdateDto(
    val patientId: UUID,
    val ausgestelltAm: LocalDate,
    val positionen: List<RezeptPosCreateDto>,
)

/**
 * DTO for creating a new RezeptPos
 */
data class RezeptPosCreateDto(
    val behandlungsartId: UUID,
    val anzahl: Int,
)
