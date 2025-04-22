package de.keller.physio_ai.rezepte.web

import de.keller.physio_ai.patienten.PatientId
import de.keller.physio_ai.patienten.PatientenRepository
import de.keller.physio_ai.rezepte.*
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.core.io.Resource
import org.springframework.core.io.UrlResource
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.transaction.annotation.Transactional
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
    
    @PostMapping
    @Transactional
    fun createRezept(@RequestBody rezeptCreateDto: RezeptCreateDto): RezeptDto {
        try {
            // Log the received data
            println("Received rezeptCreateDto: $rezeptCreateDto")
            
            // Validate patient exists first
            val patientId = PatientId(rezeptCreateDto.patientId)
            val patient = patientenRepository.findById(patientId) 
                ?: throw IllegalArgumentException("Patient with ID ${rezeptCreateDto.patientId} not found")
            println("Found patient: $patient")
            
            // Validate all behandlungsarten exist
            val behandlungsartIds = rezeptCreateDto.positionen.map { BehandlungsartId(it.behandlungsartId) }
            val behandlungsarten = behandlungsartenRepository.findAllById(behandlungsartIds).toList()
            if (behandlungsarten.size != behandlungsartIds.size) {
                throw IllegalArgumentException("One or more BehandlungsartId not found")
            }
            println("Found all behandlungsarten: $behandlungsarten")
            
            // Use the toRezept method from the DTO to create the entity
            // This ensures proper ID generation and structure
            val rezept = rezeptCreateDto.toRezept()
            println("Generated new Rezept with ID: ${rezept.id.id} and ${rezept.positionen.size} positionen")
            
            // Save the complete rezept with positions
            val savedRezept = rezeptRepository.save(rezept)
            println("Saved rezept with ID: ${savedRezept.id.id}, positions count: ${savedRezept.positionen.size}")
            
            // Return DTO with the saved rezept
            return RezeptDto.fromRezept(
                rezept = savedRezept,
                patient = patient,
                arzt = null, // No doctor information in the frontend
                behandlungsarten = behandlungsarten
            )
        } catch (e: Exception) {
            val errorMessage = "Failed to create Rezept: ${e.message ?: "Unknown error"}"
            val rootCause = getRootCause(e)
            println("Error creating rezept: $errorMessage. Root cause: ${rootCause.message}")
            e.printStackTrace()
            throw e
        }
    }
    
    @PatchMapping("/{id}")
    @Transactional
    fun updateRezept(@PathVariable id: UUID, @RequestBody rezeptUpdateDto: RezeptUpdateDto): RezeptDto {
        try {
            // Log the received data
            println("Updating rezept with ID: $id, data: $rezeptUpdateDto")
            
            // Check if rezept exists
            val rezeptId = RezeptId.fromUUID(id)
            val existingRezept = rezeptRepository.findById(rezeptId)
                ?: throw IllegalArgumentException("Rezept with ID $id not found")
            println("Found existing rezept: $existingRezept")
            
            // Validate patient exists
            val patientId = PatientId(rezeptUpdateDto.patientId)
            val patient = patientenRepository.findById(patientId)
                ?: throw IllegalArgumentException("Patient with ID ${rezeptUpdateDto.patientId} not found")
            println("Found patient: $patient")
            
            // Validate all behandlungsarten exist
            val behandlungsartIds = rezeptUpdateDto.positionen.map { BehandlungsartId(it.behandlungsartId) }
            val behandlungsarten = behandlungsartenRepository.findAllById(behandlungsartIds).toList()
            if (behandlungsarten.size != behandlungsartIds.size) {
                throw IllegalArgumentException("One or more BehandlungsartId not found")
            }
            println("Found all behandlungsarten: $behandlungsarten")
            
            // Convert DTO to entity, preserving ID and version
            val rezeptToUpdate = rezeptUpdateDto.toRezept(existingRezept.id, existingRezept.version)
            println("Updating rezept with ${rezeptToUpdate.positionen.size} positionen")
            
            // Save the updated rezept with positions
            val savedRezept = rezeptRepository.save(rezeptToUpdate)
            println("Updated rezept with ID: ${savedRezept.id.id}, positions count: ${savedRezept.positionen.size}")
            
            // Return DTO with the updated rezept
            return RezeptDto.fromRezept(
                rezept = savedRezept,
                patient = patient,
                arzt = null, // No doctor information from frontend
                behandlungsarten = behandlungsarten
            )
        } catch (e: Exception) {
            val errorMessage = "Failed to update Rezept: ${e.message ?: "Unknown error"}"
            val rootCause = getRootCause(e)
            println("Error updating rezept: $errorMessage. Root cause: ${rootCause.message}")
            e.printStackTrace()
            throw e
        }
    }
    
    private fun getRootCause(throwable: Throwable): Throwable {
        var rootCause = throwable
        while (rootCause.cause != null && rootCause.cause !== rootCause) {
            rootCause = rootCause.cause!!
        }
        return rootCause
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
    
    @GetMapping("/behandlungsarten")
    fun getBehandlungsarten(): List<BehandlungsartDto> {
        return behandlungsartenRepository.findAll()
            .map { BehandlungsartDto.fromBehandlungsart(it) }
            .toList()
    }

}