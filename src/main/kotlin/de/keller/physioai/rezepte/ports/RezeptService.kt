package de.keller.physioai.rezepte.ports

import de.keller.physioai.rezepte.RezeptId
import de.keller.physioai.rezepte.adapters.rest.RezeptCreateDto
import de.keller.physioai.rezepte.adapters.rest.RezeptUpdateDto
import de.keller.physioai.rezepte.domain.Rezept
import org.springframework.web.multipart.MultipartFile
import java.time.LocalDateTime
import java.util.UUID

interface RezeptService {
    /**
     * Processes and reads a prescription file
     * @param file The prescription file to be processed
     * @return Response containing the processed prescription information, or null if processing failed
     */
    fun rezeptEinlesen(file: MultipartFile): RezeptEinlesenResponse?

    fun createRezept(rezeptCreateDto: RezeptCreateDto): Rezept

    fun updateRezept(
        rezeptId: RezeptId,
        rezeptUpdateDto: RezeptUpdateDto,
    ): Rezept

    fun addBehandlung(
        rezeptId: RezeptId,
        startZeit: LocalDateTime,
        endZeit: LocalDateTime,
    ): Rezept

    fun removeBehandlung(
        rezeptId: RezeptId,
        behandlungId: UUID,
    ): Rezept
}
