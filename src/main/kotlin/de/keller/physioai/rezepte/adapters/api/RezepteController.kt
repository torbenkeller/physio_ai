package de.keller.physioai.rezepte.adapters.api

import de.keller.physioai.patienten.PatientenRepository
import de.keller.physioai.rezepte.ports.AerzteRepository
import de.keller.physioai.rezepte.ports.BehandlungsartenRepository
import de.keller.physioai.rezepte.ports.RezeptRepository
import de.keller.physioai.rezepte.ports.RezeptService
import de.keller.physioai.shared.AggregateNotFoundException
import de.keller.physioai.shared.RezeptId
import org.springframework.http.MediaType
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.multipart.MultipartFile
import java.util.UUID

@CrossOrigin
@RestController
@RequestMapping("/rezepte")
class RezepteController(
    private val rezeptRepository: RezeptRepository,
    private val behandlungsartenRepository: BehandlungsartenRepository,
    private val aerzteRepository: AerzteRepository,
    private val patientenRepository: PatientenRepository,
    private val rezeptService: RezeptService,
) {
    @GetMapping
    fun getRezepte(): List<RezeptDto> {
        val rezepte = rezeptRepository.findAll()
        if (rezepte.isEmpty()) {
            return emptyList()
        }

        val aerzteIds = rezepte.mapNotNull { it.ausgestelltVonArztId }.toList()
        val aerzte = aerzteRepository.findAllByIdIn(aerzteIds).toList()

        val patientenIds = rezepte.map { it.patientId }.toList()
        val patienten = patientenRepository.findAllByIdIn(patientenIds)

        return rezepte.map { r ->
            RezeptDto.Companion.fromDomain(
                rezept = r,
                arzt = aerzte.firstOrNull { it.id == r.ausgestelltVonArztId },
                patient = patienten.first { it.id == r.patientId },
            )
        }
    }

    @DeleteMapping("/{id}")
    fun deleteRezept(
        @PathVariable id: UUID,
    ) {
        rezeptRepository.deleteById(RezeptId(id))
    }

    @PostMapping
    fun createRezept(
        @RequestBody rezeptCreateDto: RezeptCreateDto,
    ): RezeptDto {
        val savedRezept = rezeptService.createRezept(rezeptCreateDto)

        val patient = patientenRepository.findById(savedRezept.patientId) ?: throw AggregateNotFoundException()

        val arzt = savedRezept.ausgestelltVonArztId?.let { arztId ->
            aerzteRepository.findById(arztId)
        }

        return RezeptDto.fromDomain(
            rezept = savedRezept,
            patient = patient,
            arzt = arzt,
        )
    }

    @PostMapping("/createFromImage", consumes = [MediaType.MULTIPART_FORM_DATA_VALUE])
    fun createFromImage(
        @RequestParam("file") file: MultipartFile,
    ): EingelesenesRezeptDto? {
        val response = rezeptService.rezeptEinlesen(file)

        return response?.let { r ->
            EingelesenesRezeptDto(
                existingPatient = r.existingPatient?.let { PatientDto.fromDomain(it) },
                patient = r.patient,
                rezept = r.rezept,
            )
        }
    }

    @PatchMapping("/{id}")
    fun updateRezept(
        @PathVariable id: UUID,
        @RequestBody rezeptUpdateDto: RezeptUpdateDto,
    ): RezeptDto {
        val savedRezept = rezeptService.updateRezept(RezeptId(id), rezeptUpdateDto)

        val patient = patientenRepository.findById(savedRezept.patientId) ?: throw AggregateNotFoundException()

        val arzt = savedRezept.ausgestelltVonArztId?.let { aerzteRepository.findById(it) }

        return RezeptDto.fromDomain(
            rezept = savedRezept,
            patient = patient,
            arzt = arzt,
        )
    }

    @GetMapping("/behandlungsarten")
    fun getBehandlungsarten(): List<BehandlungsartDto> =
        behandlungsartenRepository
            .findAll()
            .map { BehandlungsartDto.fromBehandlungsart(it) }
            .toList()
}
