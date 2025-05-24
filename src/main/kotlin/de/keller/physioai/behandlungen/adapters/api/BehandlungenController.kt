package de.keller.physioai.behandlungen.adapters.api

import de.keller.physioai.behandlungen.ports.BehandlungenRepository
import de.keller.physioai.behandlungen.ports.BehandlungenService
import de.keller.physioai.shared.AggregateNotFoundException
import de.keller.physioai.shared.BehandlungId
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
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@PrimaryAdapter
@RestController
@RequestMapping("/behandlungen")
class BehandlungenController(
    private val behandlungenService: BehandlungenService,
    private val behandlungenRepository: BehandlungenRepository,
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
        )

        return BehandlungDto.fromDomain(behandlung)
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
        )
        return BehandlungDto.fromDomain(behandlung)
    }

    @DeleteMapping("/{id}")
    fun deleteBehandlung(
        @PathVariable id: UUID,
    ) = behandlungenService.deleteBehandlung(BehandlungId(id))
}
