package de.keller.physioai.behandlungen.adapters.api

import de.keller.physioai.behandlungen.ports.GetWeeklyCalendarBehandlungResponse
import de.keller.physioai.patienten.Patient
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.UUID

data class BehandlungKalenderDto(
    val id: UUID,
    val startZeit: LocalDateTime,
    val endZeit: LocalDateTime,
    val rezeptId: UUID?,
    val patient: PatientSummaryDto,
) {
    companion object {
        fun fromDomain(response: GetWeeklyCalendarBehandlungResponse): BehandlungKalenderDto =
            BehandlungKalenderDto(
                id = response.behandlungAggregate.id.id,
                startZeit = response.behandlungAggregate.startZeit,
                endZeit = response.behandlungAggregate.endZeit,
                rezeptId = response.behandlungAggregate.rezeptId?.id,
                patient = PatientSummaryDto.fromDomain(response.patient),
            )
    }
}

data class PatientSummaryDto(
    val id: UUID,
    val name: String,
    val birthday: LocalDate?,
) {
    companion object {
        fun fromDomain(patient: Patient): PatientSummaryDto =
            PatientSummaryDto(
                id = patient.id.id,
                name = "${patient.vorname} ${patient.nachname}",
                birthday = patient.geburtstag,
            )
    }
}
