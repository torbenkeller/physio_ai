package de.keller.physioai.behandlungen.application

import de.keller.physioai.behandlungen.domain.BehandlungAggregate
import de.keller.physioai.behandlungen.ports.BehandlungenRepository
import de.keller.physioai.behandlungen.ports.BehandlungenService
import de.keller.physioai.behandlungen.ports.GetWeeklyCalendarBehandlungResponse
import de.keller.physioai.patienten.PatientenRepository
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
    ): BehandlungAggregate {
        val behandlung = BehandlungAggregate.create(
            patientId = patientId,
            startZeit = startZeit,
            endZeit = endZeit,
            rezeptId = rezeptId,
        )
        return behandlungenRepository.save(behandlung)
    }

    override fun updateBehandlung(
        id: BehandlungId,
        startZeit: LocalDateTime,
        endZeit: LocalDateTime,
        rezeptId: RezeptId?,
    ): BehandlungAggregate {
        val behandlung = behandlungenRepository.findById(id)
            ?: throw AggregateNotFoundException()

        val updatedBehandlung = behandlung.update(
            startZeit = startZeit,
            endZeit = endZeit,
            rezeptId = rezeptId,
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
}
