package de.keller.physioai.rezepte.ports

import com.fasterxml.jackson.databind.PropertyNamingStrategies
import com.fasterxml.jackson.databind.annotation.JsonNaming
import org.jmolecules.architecture.hexagonal.SecondaryPort
import org.springframework.web.multipart.MultipartFile
import java.time.LocalDate

@SecondaryPort
interface RezepteAiService {
    /**
     * Analyzes a prescription image using AI and returns the extracted data
     * @param file The prescription image
     * @return The analyzed prescription data, or null if analysis failed
     */
    fun analyzeRezeptImage(file: MultipartFile): EingelesenesRezeptRaw?

    @JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy::class)
    data class EingelesenesRezeptRaw(
        val ausgestelltAm: LocalDate,
        val titel: String?,
        val vorname: String,
        val nachname: String,
        val strasse: String,
        val hausnummer: String,
        val postleitzahl: String,
        val stadt: String,
        val geburtstag: LocalDate,
        val rezeptpositionen: List<EingelesenesRezeptPosRaw>,
    )

    data class EingelesenesRezeptPosRaw(
        val anzahl: Int,
        val behandlung: String,
    )
}
