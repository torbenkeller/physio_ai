package de.keller.physio_ai.rezepte.web

import de.keller.physio_ai.patienten.Patient
import de.keller.physio_ai.patienten.PatientId
import de.keller.physio_ai.rezepte.*
import java.time.LocalDate
import java.util.*

data class RezeptDto(
    val id: UUID,
    val patient: RezeptPatientDto,
    val ausgestelltAm: LocalDate,
    val ausgestelltVon: RezeptArztDto?,
    val preisGesamt: Double,
    val rechnung: RezeptRechnungDto?,
    val positionen: List<RezeptPosDto>,
) {

    companion object {
        fun fromRezept(
            rezept: Rezept,
            patient: Patient,
            arzt: Arzt?,
            behandlungsarten: List<Behandlungsart>,
        ): RezeptDto {
            return RezeptDto(
                id = rezept.id.id,
                patient = RezeptPatientDto.fromPatient(patient),
                ausgestelltAm = rezept.ausgestelltAm,
                ausgestelltVon = if (arzt != null) RezeptArztDto.fromArzt(arzt) else null,
                positionen = rezept.positionen.map { pos ->
                    RezeptPosDto.fromRezeptPos(
                        rezeptPos = pos,
                        behandlungsart = behandlungsarten.first { it.id == pos.behandlungsartId }
                    )
                }.toList(),
                rechnung = null,
                preisGesamt = rezept.preisGesamt
            )
        }
    }
}

data class RezeptPatientDto(
    val id: UUID,
    val vorname: String,
    val nachname: String,
) {
    companion object {
        fun fromPatient(patient: Patient): RezeptPatientDto {
            return RezeptPatientDto(
                id = patient.id.id,
                vorname = patient.vorname,
                nachname = patient.nachname,
            )
        }
    }
}

data class RezeptArztDto(
    val id: UUID,
    val name: String
) {
    companion object {
        fun fromArzt(arzt: Arzt): RezeptArztDto {
            return RezeptArztDto(
                id = arzt.id.id,
                name = arzt.name
            )
        }
    }
}

data class RezeptRechnungDto(
    val rechnungsnummer: String,
    val status: RezeptRechnungStatus,
)

enum class RezeptRechnungStatus {
    ERSTELLT,
    OFFEN,
    BEZAHLT
}

data class RezeptPosDto(
    val behandlungsart: BehandlungsartDto,
    val anzahl: Long
) {
    companion object {
        fun fromRezeptPos(
            rezeptPos: RezeptPos,
            behandlungsart: Behandlungsart
        ): RezeptPosDto {
            return RezeptPosDto(
                anzahl = rezeptPos.anzahl,
                behandlungsart = BehandlungsartDto.fromBehandlungsart(behandlungsart)
            )
        }
    }
}

data class BehandlungsartDto(
    val id: UUID,
    val name: String,
    val preis: Double,
) {
    companion object {
        fun fromBehandlungsart(behandlungsart: Behandlungsart): BehandlungsartDto {
            return BehandlungsartDto(
                id = behandlungsart.id.id,
                name = behandlungsart.name,
                preis = behandlungsart.preis
            )
        }
    }
}

/**
 * DTO for creating a new Rezept
 */
data class RezeptCreateDto(
    val patientId: UUID,
    val ausgestelltAm: LocalDate,
    val preisGesamt: Double,
    val positionen: List<RezeptPosCreateDto>,
) {
    fun toRezept(): Rezept {
        val rezeptId = RezeptId.generate()
        
        return Rezept(
            id = rezeptId,
            patientId = PatientId(patientId),
            ausgestelltAm = ausgestelltAm,
            ausgestelltVonArztId = null, // Not provided in frontend
            preisGesamt = preisGesamt,
            rechnungsnummer = null, // No invoice number initially
            positionen = positionen.mapIndexed { index, pos ->
                RezeptPos(
                    id = UUID.randomUUID(),
                    index = index.toLong(),
                    rezeptId = rezeptId,
                    behandlungsartId = BehandlungsartId(pos.behandlungsartId),
                    anzahl = pos.anzahl
                )
            }
        )
    }
}

/**
 * DTO for creating a new RezeptPos
 */
data class RezeptPosCreateDto(
    val behandlungsartId: UUID,
    val anzahl: Long,
)
