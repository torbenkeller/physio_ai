package de.keller.physio_ai.rezepte.web

import de.keller.physio_ai.patienten.PatientenRepository
import de.keller.physio_ai.rezepte.domain.*
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.core.io.Resource
import org.springframework.core.io.UrlResource
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile
import java.nio.file.Path
import java.util.*


@CrossOrigin
@RestController
@RequestMapping("/rezepte")
class RezepteController @Autowired constructor(
    private val rezeptRepository: RezeptRepository,
    private val behandlungsartenRepository: BehandlungsartenRepository,
    private val aerzteRepository: AerzteRepository,
    private val patientenRepository: PatientenRepository,
    private val rezeptAiService: RezeptAiService,
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
        val patienten = patientenRepository.findAllById(patientenIds)

        return rezepte.map { r ->
            RezeptDto.fromRezept(
                rezept = r,
                arzt = aerzte.firstOrNull { it.id == r.ausgestelltVonArztId },
                patient = patienten.first { it.id == r.patientId },
            )
        }
    }

    @DeleteMapping("/{id}")
    fun deleteRezept(@PathVariable id: UUID) {
        rezeptRepository.deleteById(RezeptId.fromUUID(id))
    }

    @PostMapping
    fun createRezept(@RequestBody rezeptCreateDto: RezeptCreateDto): RezeptDto {
        val savedRezept = rezeptService.createRezept(rezeptCreateDto)

        val patient = patientenRepository.findById(savedRezept.patientId)
            ?: throw IllegalStateException("Patient not found after saving rezept")

        val arzt = savedRezept.ausgestelltVonArztId?.let { arztId ->
            aerzteRepository.findById(arztId)
        }

        return RezeptDto.fromRezept(
            rezept = savedRezept,
            patient = patient,
            arzt = arzt,
        )
    }

    @PatchMapping("/{id}")
    fun updateRezept(@PathVariable id: UUID, @RequestBody rezeptUpdateDto: RezeptUpdateDto): RezeptDto {
        val savedRezept = rezeptService.updateRezept(id, rezeptUpdateDto)

        val patient = patientenRepository.findById(savedRezept.patientId)
            ?: throw IllegalStateException("Patient not found after saving rezept")

        val arzt = savedRezept.ausgestelltVonArztId?.let { arztId ->
            aerzteRepository.findById(arztId)
        }

        return RezeptDto.fromRezept(
            rezept = savedRezept,
            patient = patient,
            arzt = arzt,
        )
    }

    @PostMapping("/createFromImage", consumes = [MediaType.MULTIPART_FORM_DATA_VALUE])
    fun createFromImage(@RequestParam("file") file: MultipartFile): RezeptEinlesenResponse? {
        return rezeptAiService.rezeptEinlesen(file)
    }

    @GetMapping("/tmp/{filename:.+}")
    @ResponseBody
    fun serveFile(@PathVariable filename: String?): ResponseEntity<Resource?>? {

        val file: Path = Path.of("rezepte/tmp/$filename")
        val resource: Resource = UrlResource(file.toUri())
        if (resource.exists() || resource.isReadable) {
            return ResponseEntity
                .ok()
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(resource)
        }

        return ResponseEntity.notFound().build()
    }

    @GetMapping("/behandlungsarten")
    fun getBehandlungsarten(): List<BehandlungsartDto> {
        return behandlungsartenRepository.findAll()
            .map { BehandlungsartDto.fromBehandlungsart(it) }
            .toList()
    }


    private fun getRootCause(throwable: Throwable): Throwable {
        var rootCause = throwable
        while (rootCause.cause != null && rootCause.cause !== rootCause) {
            rootCause = rootCause.cause!!
        }
        return rootCause
    }
}