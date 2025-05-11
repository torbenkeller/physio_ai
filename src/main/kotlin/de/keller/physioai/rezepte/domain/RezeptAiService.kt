package de.keller.physioai.rezepte.domain

import com.fasterxml.jackson.databind.PropertyNamingStrategies
import com.fasterxml.jackson.databind.annotation.JsonNaming
import de.keller.physioai.patienten.web.PatientDto
import de.keller.physioai.rezepte.web.BehandlungsartDto
import org.springframework.stereotype.Service
import org.springframework.web.multipart.MultipartFile
import java.time.LocalDate

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
    val existingPatient: PatientDto?,
    val patient: EingelesenerPatientDto,
    val rezept: EingelesenesRezeptDto,
    val path: String,
)

@Service
class RezeptAiService(
    private val behandlungsartenRepository: BehandlungsartenRepository,
    private val aiService: AiService,
) {
    /**
     * Analyzes a prescription image using AI and returns the extracted data
     * @param file The prescription image
     * @return The analyzed prescription data, or null if analysis failed
     */
    fun analyzeRezeptImage(file: MultipartFile): RezeptAiResponse? {
        val behandlungsarten = behandlungsartenRepository.findAll().map(Behandlungsart::name)
        val schema = aiService.getJsonSchemaForRezeptAiResponse(behandlungsarten)

        val prompt = "Das folgende Bild ist ein Rezept für Physiotherapie. Gib die Informationen aus dem Bild zurück."

        return aiService.analyzeImage(
            file = file,
            schema = schema,
            prompt = prompt,
            responseClass = RezeptAiResponse::class.java,
        )
    }
}

@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy::class)
data class RezeptAiResponse(
    val ausgestelltAm: LocalDate,
    val titel: String?,
    val vorname: String,
    val nachname: String,
    val strasse: String,
    val hausnummer: String,
    val postleitzahl: String,
    val stadt: String,
    val geburtstag: LocalDate,
    val rezeptpositionen: List<RezeptPosAiResponse>,
)

data class RezeptPosAiResponse(
    val anzahl: Int,
    val behandlung: String,
)
