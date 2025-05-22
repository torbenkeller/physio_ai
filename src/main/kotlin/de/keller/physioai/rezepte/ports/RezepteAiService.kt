package de.keller.physioai.rezepte.ports

import org.springframework.web.multipart.MultipartFile

interface RezepteAiService {
    /**
     * Analyzes a prescription image using AI and returns the extracted data
     * @param file The prescription image
     * @return The analyzed prescription data, or null if analysis failed
     */
    fun analyzeRezeptImage(file: MultipartFile): EingelesenesRezeptRaw?
}
