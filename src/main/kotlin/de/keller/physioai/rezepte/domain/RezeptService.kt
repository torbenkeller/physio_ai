package de.keller.physioai.rezepte.domain

import de.keller.physioai.patienten.PatientId
import de.keller.physioai.patienten.PatientenRepository
import de.keller.physioai.patienten.web.PatientDto
import de.keller.physioai.rezepte.web.BehandlungsartDto
import de.keller.physioai.rezepte.web.RezeptCreateDto
import de.keller.physioai.rezepte.web.RezeptUpdateDto
import de.keller.physioai.shared.web.AggregateNotFoundException
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.multipart.MultipartFile
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.StandardCopyOption
import java.time.LocalDateTime
import java.util.UUID

@Service
class RezeptService
    @Autowired
    constructor(
        private val rezeptRepository: RezeptRepository,
        private val behandlungsartenRepository: BehandlungsartenRepository,
        private val patientenRepository: PatientenRepository,
        private val rezeptAiService: RezeptAiService,
        @Value("\${rezepte.path}") val rezeptePath: String,
    ) {
        val logger: Logger = LoggerFactory.getLogger(RezeptService::class.java)

        @Transactional
        fun createRezept(rezeptCreateDto: RezeptCreateDto): Rezept {
            // Log the received data
            logger.debug("Received rezeptCreateDto: {}", rezeptCreateDto)

            val patientId = PatientId(rezeptCreateDto.patientId)
            val patient =
                patientenRepository.findById(patientId)
                    ?: throw IllegalArgumentException("Patient with ID ${rezeptCreateDto.patientId} not found")
            logger.debug("Found patient: {}", patient)

            // Validate rezept has at least one position
            if (rezeptCreateDto.positionen.isEmpty()) {
                throw IllegalArgumentException("A rezept must have at least one position")
            }

            // Validate all behandlungsarten exist
            val behandlungsartIds =
                rezeptCreateDto.positionen.map { BehandlungsartId.fromUUID(it.behandlungsartId) }.toSet()
            val behandlungsarten = behandlungsartenRepository.findAllById(behandlungsartIds).toList()
            if (behandlungsarten.size != behandlungsartIds.size) {
                throw IllegalArgumentException("One or more BehandlungsartId not found")
            }
            logger.debug("Found all behandlungsarten: {}", behandlungsarten)

            val posSources =
                rezeptCreateDto.positionen.map { pos ->

                    RezeptPosSource(
                        behandlungsart = behandlungsarten.find { it.id == BehandlungsartId.fromUUID(pos.behandlungsartId) }!!,
                        pos.anzahl,
                    )
                }

            val rezept =
                Rezept.createNew(
                    patientId = patientId,
                    ausgestelltAm = rezeptCreateDto.ausgestelltAm,
                    ausgestelltVonArztId = null,
                    posSources = posSources,
                )

            val savedRezept = rezeptRepository.save(rezept)
            logger.debug("Saved rezept with ID: {}, positions count: {}", savedRezept.id.id, savedRezept.positionen.size)

            return savedRezept
        }

        @Transactional
        @Throws(AggregateNotFoundException::class)
        fun updateRezept(
            rezeptId: RezeptId,
            rezeptUpdateDto: RezeptUpdateDto,
        ): Rezept {
            logger.debug("Updating rezept with ID: {}, data: {}", rezeptId, rezeptUpdateDto)

            val rezept =
                rezeptRepository.findById(rezeptId)
                    ?: throw AggregateNotFoundException()

            logger.debug("Found existing rezept: {}", rezept)

            // Validate patient exists
            val patientId = PatientId.fromUUID(rezeptUpdateDto.patientId)
            val patient = patientenRepository.findById(patientId) ?: throw AggregateNotFoundException()

            logger.debug("Found patient: {}", patient)

            // Validate all behandlungsarten exist
            val behandlungsartIds = rezeptUpdateDto.positionen
                .map { BehandlungsartId.fromUUID(it.behandlungsartId) }
                .toSet()

            val behandlungsarten = behandlungsartenRepository.findAllById(behandlungsartIds).toList()
            if (behandlungsarten.size != behandlungsartIds.size) {
                throw AggregateNotFoundException()
            }

            logger.debug("Found all behandlungsarten: {}", behandlungsarten)

            val posSources =
                rezeptUpdateDto.positionen.map { pos ->
                    RezeptPosSource(
                        behandlungsart = behandlungsarten.find { b -> BehandlungsartId.fromUUID(pos.behandlungsartId) == b.id }!!,
                        pos.anzahl,
                    )
                }

            val mutatedRezept =
                rezept.update(
                    patientId = patientId,
                    posSources = posSources,
                    rechnungsnummer = null,
                    ausgestelltVonArztId = null,
                    ausgestelltAm = rezeptUpdateDto.ausgestelltAm,
                )

            val savedRezept = rezeptRepository.save(mutatedRezept)
            logger.debug("Updated rezept with ID: {}, positions count: {}", savedRezept.id.id, savedRezept.positionen.size)

            return savedRezept
        }

        /**
         * Saves a file to the specified location
         * @param file The file to save
         * @param location The location to save the file to
         */
        private fun saveFile(
            file: MultipartFile,
            location: String,
        ) {
            Files.copy(file.inputStream, Path.of(location), StandardCopyOption.REPLACE_EXISTING)
        }

        /**
         * Processes the prescription data from the AI service
         * @param rezeptData The prescription data from the AI service
         * @param filePath The path to the saved file
         * @return The processed prescription data
         */
        fun processRezeptData(
            rezeptData: RezeptAiResponse,
            filePath: String,
        ): RezeptEinlesenResponse {
            val path = "/tmp/${UUID.randomUUID()}.${filePath.split(".").last()}"

            val matchingPatienten = patientenRepository.findPatientByGeburtstag(rezeptData.geburtstag)

            val matchingPatient =
                matchingPatienten.firstOrNull { it.nachname == rezeptData.nachname }
                    ?: matchingPatienten.firstOrNull {
                        it.strasse == rezeptData.strasse &&
                            it.hausnummer == rezeptData.hausnummer &&
                            it.plz == rezeptData.postleitzahl &&
                            it.stadt == rezeptData.stadt
                    }

            val behandlungsarten =
                behandlungsartenRepository.findAllByNameIn(rezeptData.rezeptpositionen.map { it.behandlung })

            return RezeptEinlesenResponse(
                existingPatient = matchingPatient?.let { PatientDto.fromPatient(it) },
                patient = EingelesenerPatientDto(
                    titel = rezeptData.titel,
                    vorname = rezeptData.vorname,
                    nachname = rezeptData.nachname,
                    strasse = rezeptData.strasse,
                    hausnummer = rezeptData.hausnummer,
                    postleitzahl = rezeptData.postleitzahl,
                    stadt = rezeptData.stadt,
                    geburtstag = rezeptData.geburtstag,
                ),
                rezept = EingelesenesRezeptDto(
                    ausgestelltAm = rezeptData.ausgestelltAm,
                    rezeptpositionen = rezeptData.rezeptpositionen.map { pos ->
                        EingelesenesRezeptPosDto(
                            anzahl = pos.anzahl,
                            behandlungsart =
                                behandlungsarten
                                    .first { it.name == pos.behandlung }
                                    .let { BehandlungsartDto.fromBehandlungsart(it) },
                        )
                    },
                ),
                path = "/rezepte$path",
            )
        }

        /**
         * Processes a prescription image
         * @param file The prescription image
         * @param rezeptData The prescription data from the AI service
         * @return The processed prescription data
         */
        fun processRezeptImage(
            file: MultipartFile,
            rezeptData: RezeptAiResponse,
        ): RezeptEinlesenResponse? {
            val path = "/tmp/${UUID.randomUUID()}.${file.originalFilename?.split(".")?.last()}"

            saveFile(file, "$rezeptePath$path")

            return processRezeptData(rezeptData, path)
        }

        /**
         * Processes a prescription image using AI and returns the extracted data
         * @param file The prescription image
         * @return The processed prescription data, or null if processing failed
         */
        fun rezeptEinlesen(file: MultipartFile): RezeptEinlesenResponse? {
            logger.debug("Processing prescription image: {}", file.originalFilename)

            val rezeptData = rezeptAiService.analyzeRezeptImage(file) ?: return null
            logger.debug("Successfully analyzed prescription image")

            return processRezeptImage(file, rezeptData)
        }

        /**
         * Adds a Behandlung to a Rezept
         * @param rezeptId The ID of the Rezept
         * @param startZeit The start time of the Behandlung
         * @param endZeit The end time of the Behandlung
         * @return The updated Rezept
         */
        @Transactional
        @Throws(AggregateNotFoundException::class)
        fun addBehandlung(
            rezeptId: RezeptId,
            startZeit: LocalDateTime,
            endZeit: LocalDateTime,
        ): Rezept {
            logger.debug("Adding Behandlung to Rezept with ID: {}", rezeptId)

            val rezept = rezeptRepository.findById(rezeptId) ?: throw AggregateNotFoundException()

            val updatedRezept = rezept.addBehandlung(startZeit, endZeit)

            val savedRezept = rezeptRepository.save(updatedRezept)
            logger.debug(
                "Added Behandlung to Rezept with ID: {}, new behandlungen count: {}",
                savedRezept.id.id,
                savedRezept.behandlungen.size,
            )

            return savedRezept
        }

        /**
         * Removes a Behandlung from a Rezept
         * @param rezeptId The ID of the Rezept
         * @param behandlungId The ID of the Behandlung to remove
         * @return The updated Rezept
         */
        @Transactional
        @Throws(AggregateNotFoundException::class)
        fun removeBehandlung(
            rezeptId: RezeptId,
            behandlungId: UUID,
        ): Rezept {
            logger.debug("Removing Behandlung with ID: {} from Rezept with ID: {}", behandlungId, rezeptId)

            val rezept = rezeptRepository.findById(rezeptId) ?: throw AggregateNotFoundException()

            val updatedRezept = rezept.removeBehandlung(behandlungId)

            if (updatedRezept == rezept) {
                logger.debug("No Behandlung with ID: {} found in Rezept with ID: {}", behandlungId, rezeptId)
                throw AggregateNotFoundException()
            }

            val savedRezept = rezeptRepository.save(updatedRezept)
            logger.debug(
                "Removed Behandlung from Rezept with ID: {}, new behandlungen count: {}",
                savedRezept.id.id,
                savedRezept.behandlungen.size,
            )

            return savedRezept
        }
    }
