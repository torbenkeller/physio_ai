package de.keller.physioai.rezepte.adapters.ai

import de.keller.physioai.rezepte.domain.Behandlungsart
import de.keller.physioai.rezepte.ports.BehandlungsartenRepository
import de.keller.physioai.rezepte.ports.EingelesenesRezeptRaw
import de.keller.physioai.rezepte.ports.RezepteAiService
import org.springframework.stereotype.Service
import org.springframework.web.multipart.MultipartFile

@Service
class RezepteAiServiceImpl(
    private val behandlungsartenRepository: BehandlungsartenRepository,
    private val aiService: AiService,
) : RezepteAiService {
    override fun analyzeRezeptImage(file: MultipartFile): EingelesenesRezeptRaw? {
        val behandlungsarten = behandlungsartenRepository.findAll().map(Behandlungsart::name)
        val schema = aiService.getJsonSchemaForRezeptAiResponse(behandlungsarten)

        val prompt = "Das folgende Bild ist ein Rezept für Physiotherapie. Gib die Informationen aus dem Bild zurück."

        return aiService.analyzeImage(
            file = file,
            schema = schema,
            prompt = prompt,
            responseClass = EingelesenesRezeptRaw::class.java,
        )
    }
}
