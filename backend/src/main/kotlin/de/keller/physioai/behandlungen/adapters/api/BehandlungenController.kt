package de.keller.physioai.behandlungen.adapters.api

import de.keller.physioai.behandlungen.ports.BehandlungenRepository
import de.keller.physioai.behandlungen.ports.BehandlungenService
import de.keller.physioai.behandlungen.ports.GetWeeklyCalendarBehandlungResponse
import de.keller.physioai.patienten.PatientenRepository
import de.keller.physioai.shared.AggregateNotFoundException
import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.BehandlungsartId
import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.RezeptId
import org.jmolecules.architecture.hexagonal.PrimaryAdapter
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.web.bind.annotation.RestController
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.UUID

@PrimaryAdapter
@RestController
@RequestMapping("/behandlungen")
class BehandlungenController(
    private val behandlungenService: BehandlungenService,
    private val behandlungenRepository: BehandlungenRepository,
    private val patientenRepository: PatientenRepository,
) {
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun createBehandlung(
        @RequestBody formDto: BehandlungFormDto,
    ): BehandlungDto {
        val behandlung = behandlungenService.createBehandlung(
            patientId = PatientId(formDto.patientId),
            startZeit = formDto.startZeit,
            endZeit = formDto.endZeit,
            rezeptId = formDto.rezeptId?.let { RezeptId(it) },
            behandlungsartId = formDto.behandlungsartId?.let { BehandlungsartId(it) },
        )

        return BehandlungDto.fromDomain(behandlung)
    }

    @PostMapping("/batch")
    @ResponseStatus(HttpStatus.CREATED)
    fun createBehandlungenBatch(
        @RequestBody formDtos: List<BehandlungFormDto>,
    ): List<BehandlungDto> {
        val commands = formDtos.map { formDto ->
            BehandlungenService.CreateBehandlungCommand(
                patientId = PatientId(formDto.patientId),
                startZeit = formDto.startZeit,
                endZeit = formDto.endZeit,
                rezeptId = formDto.rezeptId?.let { RezeptId(it) },
                behandlungsartId = formDto.behandlungsartId?.let { BehandlungsartId(it) },
            )
        }

        val behandlungen = behandlungenService.createBehandlungenBatch(commands)
        return behandlungen.map { BehandlungDto.fromDomain(it) }
    }

    @GetMapping("/{id}")
    fun getBehandlung(
        @PathVariable id: UUID,
    ): BehandlungDto {
        val behandlung = behandlungenRepository.findById(BehandlungId(id))
            ?: throw AggregateNotFoundException()

        return BehandlungDto.fromDomain(behandlung)
    }

    @GetMapping
    fun getAllBehandlungen(): List<BehandlungDto> {
        val behandlungen = behandlungenRepository.findAll()
        return behandlungen.map { BehandlungDto.fromDomain(it) }
    }

    @GetMapping("/patient/{patientId}")
    fun getBehandlungenByPatient(
        @PathVariable patientId: UUID,
    ): List<BehandlungDto> {
        val behandlungen = behandlungenRepository.findAllByPatientId(PatientId(patientId))
        return behandlungen.map { BehandlungDto.fromDomain(it) }
    }

    @GetMapping("/patient/{patientId}/unassigned")
    fun getUnassignedBehandlungenByPatient(
        @PathVariable patientId: UUID,
    ): List<BehandlungKalenderDto> {
        val behandlungen = behandlungenRepository.findUnassignedByPatientId(PatientId(patientId))
        val patient = patientenRepository.findById(PatientId(patientId))
            ?: throw AggregateNotFoundException()

        return behandlungen.map { behandlung ->
            BehandlungKalenderDto.fromDomain(
                GetWeeklyCalendarBehandlungResponse(
                    behandlungAggregate = behandlung,
                    patient = patient,
                ),
            )
        }
    }

    @GetMapping("/rezept/{rezeptId}")
    fun getBehandlungenByRezept(
        @PathVariable rezeptId: UUID,
    ): List<BehandlungKalenderDto> {
        val behandlungen = behandlungenRepository.findByRezeptId(RezeptId(rezeptId))

        if (behandlungen.isEmpty()) {
            return emptyList()
        }

        val patientIds = behandlungen.map { it.patientId }.toSet()
        val patients = patientenRepository.findAllByIdIn(patientIds)

        return behandlungen.map { behandlung ->
            BehandlungKalenderDto.fromDomain(
                GetWeeklyCalendarBehandlungResponse(
                    behandlungAggregate = behandlung,
                    patient = patients.find { it.id == behandlung.patientId }
                        ?: throw AggregateNotFoundException(),
                ),
            )
        }
    }

    @PutMapping("/{id}")
    fun updateBehandlung(
        @PathVariable id: UUID,
        @RequestBody formDto: BehandlungFormDto,
    ): BehandlungDto {
        val behandlung = behandlungenService.updateBehandlung(
            id = BehandlungId(id),
            startZeit = formDto.startZeit,
            endZeit = formDto.endZeit,
            rezeptId = formDto.rezeptId?.let { RezeptId(it) },
            behandlungsartId = formDto.behandlungsartId?.let { BehandlungsartId(it) },
        )
        return BehandlungDto.fromDomain(behandlung)
    }

    @DeleteMapping("/{id}")
    fun deleteBehandlung(
        @PathVariable id: UUID,
    ) = behandlungenService.deleteBehandlung(BehandlungId(id))

    @PutMapping("/{id}/verschiebe")
    fun verschiebeBehandlung(
        @PathVariable id: UUID,
        @RequestBody dto: VerschiebeBehandlungDto,
    ): BehandlungDto {
        val behandlung = behandlungenService.verschiebeBehandlung(BehandlungId(id), dto.nach)
        return BehandlungDto.fromDomain(behandlung)
    }

    @GetMapping("/calender/week")
    fun getWeeklyCalendar(
        @RequestParam date: String,
    ): Map<LocalDate, List<BehandlungKalenderDto>> {
        val parsedDate = LocalDate.parse(date)
        val weeklyCalendar = behandlungenService.getWeeklyCalendar(parsedDate)
        return weeklyCalendar
            .mapValues { (_, behandlungen) ->
                behandlungen.map { BehandlungKalenderDto.fromDomain(it) }
            }
    }

    @PostMapping("/check-conflicts")
    fun checkConflicts(
        @RequestBody request: ConflictCheckRequestDto,
    ): List<ConflictResultDto> {
        val slots = request.slots.map { slot ->
            BehandlungenService.TimeSlotCheck(
                startZeit = slot.startZeit,
                endZeit = slot.endZeit,
            )
        }

        val results = behandlungenService.checkConflicts(slots)

        return results.map { result ->
            ConflictResultDto(
                slotIndex = result.slotIndex,
                hasConflict = result.hasConflict,
                conflictingBehandlungen = result.conflictingBehandlungen.map { conflicting ->
                    ConflictingBehandlungDto(
                        id = conflicting.id.id,
                        startZeit = conflicting.startZeit,
                        endZeit = conflicting.endZeit,
                        patientName = conflicting.patientName,
                    )
                },
            )
        }
    }

    data class VerschiebeBehandlungDto(
        val nach: LocalDateTime,
    )
}
