package de.keller.physioai.rezepte.web

import de.keller.physioai.patienten.PatientenRepository
import de.keller.physioai.rezepte.domain.AerzteRepository
import de.keller.physioai.rezepte.domain.BehandlungsartenRepository
import de.keller.physioai.rezepte.domain.RezeptAiService
import de.keller.physioai.rezepte.domain.RezeptEinlesenResponse
import de.keller.physioai.rezepte.domain.RezeptId
import de.keller.physioai.rezepte.domain.RezeptRepository
import de.keller.physioai.rezepte.domain.RezeptService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.core.io.Resource
import org.springframework.core.io.UrlResource
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseBody
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.multipart.MultipartFile
import java.nio.file.Path
import java.util.UUID

@CrossOrigin
@RestController
@RequestMapping("/rezepte")
class RezepteController
    @Autowired
    constructor(
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
            val patienten = patientenRepository.findAllByIdIn(patientenIds)

            return rezepte.map { r ->
                RezeptDto.fromRezept(
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
            rezeptRepository.deleteById(RezeptId.fromUUID(id))
        }

        @PostMapping
        fun createRezept(
            @RequestBody rezeptCreateDto: RezeptCreateDto,
        ): RezeptDto {
            val savedRezept = rezeptService.createRezept(rezeptCreateDto)

            val patient =
                patientenRepository.findById(savedRezept.patientId)
                    ?: throw IllegalStateException("Patient not found after saving rezept")

            val arzt =
                savedRezept.ausgestelltVonArztId?.let { arztId ->
                    aerzteRepository.findById(arztId)
                }

            return RezeptDto.fromRezept(
                rezept = savedRezept,
                patient = patient,
                arzt = arzt,
            )
        }

        @PatchMapping("/{id}")
        fun updateRezept(
            @PathVariable id: UUID,
            @RequestBody rezeptUpdateDto: RezeptUpdateDto,
        ): RezeptDto {
            val savedRezept = rezeptService.updateRezept(RezeptId.fromUUID(id), rezeptUpdateDto)

            val patient =
                patientenRepository.findById(savedRezept.patientId)
                    ?: throw IllegalStateException("Patient not found after saving rezept")

            val arzt =
                savedRezept.ausgestelltVonArztId?.let { arztId ->
                    aerzteRepository.findById(arztId)
                }

            return RezeptDto.fromRezept(
                rezept = savedRezept,
                patient = patient,
                arzt = arzt,
            )
        }

        @PostMapping("/createFromImage", consumes = [MediaType.MULTIPART_FORM_DATA_VALUE])
        fun createFromImage(
            @RequestParam("file") file: MultipartFile,
        ): RezeptEinlesenResponse? = rezeptService.rezeptEinlesen(file)

        @GetMapping("/tmp/{filename:.+}")
        @ResponseBody
        fun serveFile(
            @PathVariable filename: String?,
        ): ResponseEntity<Resource?>? {
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
        fun getBehandlungsarten(): List<BehandlungsartDto> =
            behandlungsartenRepository
                .findAll()
                .map { BehandlungsartDto.fromBehandlungsart(it) }
                .toList()
    }
