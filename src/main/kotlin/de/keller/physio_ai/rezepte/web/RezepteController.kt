package de.keller.physio_ai.rezepte.web

import de.keller.physio_ai.patienten.PatientenRepository
import de.keller.physio_ai.rezepte.*
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
    private val rezeptService: RezeptService,
) {

    @GetMapping
    fun getRezepte(): List<RezeptDto> {
        val rezepte = rezeptRepository.findAll()
        if (rezepte.isEmpty()) {
            return emptyList()
        }

        val behandlungsarten = behandlungsartenRepository.findAll().toList()

        val aerzteIds = rezepte.mapNotNull { it.ausgestelltVonArztId }.toList()
        val aerzte = aerzteRepository.findAllById(aerzteIds).toList()

        val patientenIds = rezepte.map { it.patientId }.toList()
        val patienten = patientenRepository.findAllById(patientenIds)

        return rezepte.map { r ->
            RezeptDto.fromRezept(
                rezept = r,
                arzt = aerzte.firstOrNull { it.id == r.ausgestelltVonArztId },
                behandlungsarten = behandlungsarten,
                patient = patienten.first { it.id == r.patientId },
            )
        }
    }

    @DeleteMapping("/{id}")
    fun deleteRezept(@PathVariable id: UUID) {
        rezeptRepository.deleteById(RezeptId.fromUUID(id))
    }

    @PostMapping("/createFromImage", consumes = [MediaType.MULTIPART_FORM_DATA_VALUE])
    fun createFromImage(@RequestParam("file") file: MultipartFile): RezeptEinlesenResponse? {
        return rezeptService.rezeptEinlesen(file)
    }

    @GetMapping("/tmp/{filename:.+}")
    @ResponseBody
    fun serveFile(@PathVariable filename: String?): ResponseEntity<Resource?>? {

        val file: Path = Path.of("rezepte/tmp/$filename")
        val resource: Resource = UrlResource(file.toUri())
        if (resource.exists() || resource.isReadable) {
            return  ResponseEntity
                .ok()
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(resource)
        }

        return ResponseEntity.notFound().build()
    }

}