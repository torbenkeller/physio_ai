package de.keller.physioai.behandlungen.ports

import de.keller.physioai.behandlungen.domain.BehandlungAggregate
import de.keller.physioai.patienten.Patient
import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.BehandlungsartId
import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.RezeptId
import org.jmolecules.architecture.hexagonal.PrimaryPort
import java.time.LocalDate
import java.time.LocalDateTime

@PrimaryPort
interface BehandlungenService {
    fun createBehandlung(
        patientId: PatientId,
        startZeit: LocalDateTime,
        endZeit: LocalDateTime,
        rezeptId: RezeptId?,
        behandlungsartId: BehandlungsartId?,
    ): BehandlungAggregate

    fun createBehandlungenBatch(behandlungen: List<CreateBehandlungCommand>): List<BehandlungAggregate>

    data class CreateBehandlungCommand(
        val patientId: PatientId,
        val startZeit: LocalDateTime,
        val endZeit: LocalDateTime,
        val rezeptId: RezeptId?,
        val behandlungsartId: BehandlungsartId?,
    )

    fun updateBehandlung(
        id: BehandlungId,
        startZeit: LocalDateTime,
        endZeit: LocalDateTime,
        rezeptId: RezeptId?,
        behandlungsartId: BehandlungsartId?,
    ): BehandlungAggregate

    fun deleteBehandlung(id: BehandlungId)

    fun verschiebeBehandlung(
        id: BehandlungId,
        nach: LocalDateTime,
    ): BehandlungAggregate

    fun getWeeklyCalendar(date: LocalDate): Map<LocalDate, List<GetWeeklyCalendarBehandlungResponse>>

    fun checkConflicts(slots: List<TimeSlotCheck>): List<ConflictResult>

    data class TimeSlotCheck(
        val startZeit: LocalDateTime,
        val endZeit: LocalDateTime,
    )

    data class ConflictResult(
        val slotIndex: Int,
        val hasConflict: Boolean,
        val conflictingBehandlungen: List<ConflictingBehandlung>,
    )

    data class ConflictingBehandlung(
        val id: BehandlungId,
        val startZeit: LocalDateTime,
        val endZeit: LocalDateTime,
        val patientName: String,
    )
}

data class GetWeeklyCalendarBehandlungResponse(
    val behandlungAggregate: BehandlungAggregate,
    val patient: Patient,
)
