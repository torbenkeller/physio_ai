package de.keller.physioai.behandlungen.application

import de.keller.physioai.behandlungen.domain.BehandlungAggregate
import de.keller.physioai.behandlungen.ports.BehandlungenRepository
import de.keller.physioai.behandlungen.ports.BehandlungenService
import de.keller.physioai.behandlungen.ports.GetWeeklyCalendarBehandlungResponse
import de.keller.physioai.patienten.PatientenRepository
import de.keller.physioai.rezepte.domain.BehandlungsartId
import de.keller.physioai.shared.AggregateNotFoundException
import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.RezeptId
import org.jmolecules.architecture.hexagonal.Application
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.DayOfWeek
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.temporal.TemporalAdjusters

@Application
@Service
@Transactional
class BehandlungenServiceImpl(
    private val behandlungenRepository: BehandlungenRepository,
    private val patientenRepository: PatientenRepository,
) : BehandlungenService {
    override fun createBehandlung(
        patientId: PatientId,
        startZeit: LocalDateTime,
        endZeit: LocalDateTime,
        rezeptId: RezeptId?,
        behandlungsartId: BehandlungsartId?,
    ): BehandlungAggregate {
        val behandlung = BehandlungAggregate.create(
            patientId = patientId,
            startZeit = startZeit,
            endZeit = endZeit,
            rezeptId = rezeptId,
            behandlungsartId = behandlungsartId,
        )
        return behandlungenRepository.save(behandlung)
    }

    override fun createBehandlungenBatch(behandlungen: List<BehandlungenService.CreateBehandlungCommand>): List<BehandlungAggregate> {
        require(behandlungen.isNotEmpty()) { "Mindestens eine Behandlung erforderlich" }

        return behandlungen.map { cmd ->
            val behandlung = BehandlungAggregate.create(
                patientId = cmd.patientId,
                startZeit = cmd.startZeit,
                endZeit = cmd.endZeit,
                rezeptId = cmd.rezeptId,
                behandlungsartId = cmd.behandlungsartId,
            )
            behandlungenRepository.save(behandlung)
        }
    }

    override fun updateBehandlung(
        id: BehandlungId,
        startZeit: LocalDateTime,
        endZeit: LocalDateTime,
        rezeptId: RezeptId?,
        behandlungsartId: BehandlungsartId?,
    ): BehandlungAggregate {
        val behandlung = behandlungenRepository.findById(id)
            ?: throw AggregateNotFoundException()

        val updatedBehandlung = behandlung.update(
            startZeit = startZeit,
            endZeit = endZeit,
            rezeptId = rezeptId,
            behandlungsartId = behandlungsartId,
        )
        return behandlungenRepository.save(updatedBehandlung)
    }

    override fun deleteBehandlung(id: BehandlungId) {
        val behandlung = behandlungenRepository.findById(id)
            ?: throw AggregateNotFoundException()

        return behandlungenRepository.delete(behandlung)
    }

    override fun verschiebeBehandlung(
        id: BehandlungId,
        nach: LocalDateTime,
    ): BehandlungAggregate {
        val behandlung = behandlungenRepository.findById(id)
            ?: throw AggregateNotFoundException()

        val verschobeneBehandlung = behandlung.verschiebe(nach)
        return behandlungenRepository.save(verschobeneBehandlung)
    }

    override fun getWeeklyCalendar(date: LocalDate): Map<LocalDate, List<GetWeeklyCalendarBehandlungResponse>> {
        // Calculate week boundaries (Monday to Sunday)
        val weekStart = date.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY))
        val weekEnd = date.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY))

        // Get all treatments for the week
        val startDateTime = weekStart.atStartOfDay()
        val endDateTime = weekEnd.atTime(23, 59, 59)

        // Fetch treatments from repository
        val behandlungen = behandlungenRepository.findAllByDateRange(startDateTime, endDateTime)

        // Fetch patient data for all treatments
        val patientIds = behandlungen.map { it.patientId }.toSet()
        val patients = patientenRepository.findAllByIdIn(patientIds)

        // Enrich treatments with patient data
        val enrichedBehandlungen = behandlungen.map { behandlung ->
            GetWeeklyCalendarBehandlungResponse(
                behandlungAggregate = behandlung,
                patient = patients.find { it.id == behandlung.patientId } ?: throw AggregateNotFoundException(),
            )
        }

        // Group enriched treatments by actual date
        val behandlungByDate = enrichedBehandlungen.groupBy { response ->
            response.behandlungAggregate.startZeit.toLocalDate()
        }

        // Return map with all dates in the week, using empty lists for dates without treatments
        return mapOf(
            weekStart to behandlungByDate[weekStart].orEmpty(),
            weekStart.plusDays(1) to behandlungByDate[weekStart.plusDays(1)].orEmpty(),
            weekStart.plusDays(2) to behandlungByDate[weekStart.plusDays(2)].orEmpty(),
            weekStart.plusDays(3) to behandlungByDate[weekStart.plusDays(3)].orEmpty(),
            weekStart.plusDays(4) to behandlungByDate[weekStart.plusDays(4)].orEmpty(),
            weekStart.plusDays(5) to behandlungByDate[weekStart.plusDays(5)].orEmpty(),
            weekStart.plusDays(6) to behandlungByDate[weekStart.plusDays(6)].orEmpty(),
        )
    }

    override fun checkConflicts(slots: List<BehandlungenService.TimeSlotCheck>): List<BehandlungenService.ConflictResult> {
        // Collect all overlapping behandlungen for all slots
        val allOverlapping = slots
            .flatMap { slot ->
                behandlungenRepository.findOverlapping(slot.startZeit, slot.endZeit)
            }.distinctBy { it.id }

        // Fetch patient data for conflicting behandlungen
        val patientIds = allOverlapping.map { it.patientId }.toSet()
        val patients = if (patientIds.isNotEmpty()) {
            patientenRepository.findAllByIdIn(patientIds)
        } else {
            emptyList()
        }

        // Check each slot for conflicts
        return slots.mapIndexed { index, slot ->
            val conflicting = allOverlapping.filter { behandlung ->
                behandlung.startZeit < slot.endZeit && behandlung.endZeit > slot.startZeit
            }

            BehandlungenService.ConflictResult(
                slotIndex = index,
                hasConflict = conflicting.isNotEmpty(),
                conflictingBehandlungen = conflicting.map { behandlung ->
                    val patient = patients.find { it.id == behandlung.patientId }
                    BehandlungenService.ConflictingBehandlung(
                        id = behandlung.id,
                        startZeit = behandlung.startZeit,
                        endZeit = behandlung.endZeit,
                        patientName = patient?.let { "${it.vorname} ${it.nachname}" } ?: "Unbekannt",
                    )
                },
            )
        }
    }
}
