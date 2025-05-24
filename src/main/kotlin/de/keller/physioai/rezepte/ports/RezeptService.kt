package de.keller.physioai.rezepte.ports

import de.keller.physioai.patienten.Patient
import de.keller.physioai.rezepte.adapters.rest.BehandlungsartDto
import de.keller.physioai.rezepte.adapters.rest.RezeptCreateDto
import de.keller.physioai.rezepte.adapters.rest.RezeptUpdateDto
import de.keller.physioai.rezepte.domain.Rezept
import de.keller.physioai.shared.RezeptId
import org.jmolecules.architecture.hexagonal.PrimaryPort
import org.springframework.web.multipart.MultipartFile
import java.time.LocalDate

@PrimaryPort
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

    data class EingelesenerPatientDto(
        val titel: String?,
        val vorname: String,
        val nachname: String,
        val strasse: String,
        val hausnummer: String,
        val postleitzahl: String,
        val stadt: String,
        val geburtstag: LocalDate,
    )

    data class EingelesenesRezeptDto(
        val ausgestelltAm: LocalDate,
        val rezeptpositionen: List<EingelesenesRezeptPosDto>,
    )

    data class EingelesenesRezeptPosDto(
        val anzahl: Int,
        val behandlungsart: BehandlungsartDto,
    )

    data class RezeptEinlesenResponse(
        val existingPatient: Patient?,
        val patient: EingelesenerPatientDto,
        val rezept: EingelesenesRezeptDto,
    )
}
