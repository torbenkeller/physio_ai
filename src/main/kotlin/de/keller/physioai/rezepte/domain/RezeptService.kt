package de.keller.physioai.rezepte.domain

import de.keller.physioai.patienten.PatientId
import de.keller.physioai.patienten.PatientenRepository
import de.keller.physioai.rezepte.web.RezeptCreateDto
import de.keller.physioai.rezepte.web.RezeptUpdateDto
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

@Service
class RezeptService
    @Autowired
    constructor(
        private val rezeptRepository: RezeptRepository,
        private val behandlungsartenRepository: BehandlungsartenRepository,
        private val patientenRepository: PatientenRepository,
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
        fun updateRezept(
            id: UUID,
            rezeptUpdateDto: RezeptUpdateDto,
        ): Rezept {
            logger.debug("Updating rezept with ID: {}, data: {}", id, rezeptUpdateDto)

            val rezeptId = RezeptId.fromUUID(id)
            val rezept =
                rezeptRepository.findById(rezeptId)
                    ?: throw IllegalArgumentException("Rezept with ID $id not found")

            logger.debug("Found existing rezept: {}", rezept)

            // Validate patient exists
            val patientId = PatientId.fromUUID(rezeptUpdateDto.patientId)
            val patient =
                patientenRepository.findById(patientId)
                    ?: throw IllegalArgumentException("Patient with ID ${rezeptUpdateDto.patientId} not found")
            logger.debug("Found patient: {}", patient)

            // Validate all behandlungsarten exist
            val behandlungsartIds =
                rezeptUpdateDto.positionen.map { BehandlungsartId.fromUUID(it.behandlungsartId) }.toSet()
            val behandlungsarten = behandlungsartenRepository.findAllById(behandlungsartIds).toList()
            if (behandlungsarten.size != behandlungsartIds.size) {
                throw IllegalArgumentException("One or more BehandlungsartId not found")
            }
            logger.debug("Found all behandlungsarten: {}", behandlungsarten)

            val posSources =
                rezeptUpdateDto.positionen.map {
                    RezeptPosSource(
                        behandlungsart = behandlungsarten.find { b -> BehandlungsartId.fromUUID(id) == b.id }!!,
                        it.anzahl,
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
    }
