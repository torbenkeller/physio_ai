package de.keller.physioai.rezepte.domain

import org.springframework.ai.chat.client.ChatClient
import org.springframework.ai.chat.messages.UserMessage
import org.springframework.ai.model.Media
import org.springframework.ai.openai.OpenAiChatOptions
import org.springframework.ai.openai.api.OpenAiApi
import org.springframework.ai.openai.api.ResponseFormat
import org.springframework.ai.openai.api.ResponseFormat.JsonSchema
import org.springframework.stereotype.Service
import org.springframework.util.MimeType
import org.springframework.web.multipart.MultipartFile

@Service
class AiService(
    private val chatClientBuilder: ChatClient.Builder,
) {
    /**
     * Analyzes an image using the LLM and returns the extracted data
     * @param file The image file to analyze
     * @param schema The JSON schema to use for the response
     * @param prompt The prompt to send to the LLM
     * @return The extracted data from the image, or null if extraction failed
     */
    fun <T> analyzeImage(
        file: MultipartFile,
        schema: JsonSchema,
        prompt: String,
        responseClass: Class<T>,
    ): T? {
        val defaultOptions =
            OpenAiChatOptions
                .builder()
                .withModel(OpenAiApi.ChatModel.GPT_4_O)
                .withTemperature(0.0)
                .build()

        val chatClient =
            chatClientBuilder
                .defaultOptions(defaultOptions)
                .build()

        val format =
            ResponseFormat
                .builder()
                .type(ResponseFormat.Type.JSON_SCHEMA)
                .jsonSchema(schema)
                .build()

        val options =
            OpenAiChatOptions
                .builder()
                .withResponseFormat(format)
                .build()

        val response =
            chatClient
                .prompt()
                .options(options)
                .messages(
                    listOf(
                        UserMessage(
                            prompt,
                            Media(MimeType.valueOf(file.contentType!!), file.resource),
                        ),
                    ),
                ).call()

        val parsedResponse = response.responseEntity(responseClass)

        return parsedResponse.entity
    }

    /**
     * Creates a JSON schema for the RezeptAiResponse
     * @param behandlungen List of available treatment types
     * @return The JSON schema for the RezeptAiResponse
     */
    fun getJsonSchemaForRezeptAiResponse(behandlungen: List<String>): JsonSchema {
        val schema =
            """
            {
              "type": "object",
              "properties": {
                "ausgestellt_am": {
                  "type": "string",
                  "description": "Das Datum an dem das Rezept ausgestellt wurde im Format YYYY-MM-DD"
                },
                "titel": {
                  "type": ["string", "null"],
                  "description": "Der Titel des Namens des Patienten ohne Anrede. Zum Beispiel: 'Dr.', 'Prof.', 'Prof. Dr.', 'Dr. med.', oder ähnliches"
                },
                "vorname": {
                  "type": "string",
                  "description": "Der Vorname des Patienten ohne Titel, Anrede und Nachnamen"
                },
                "nachname": {
                  "type": "string",
                  "description": "Der Nachname des Patienten ohne Titel, Anrede und Vorname"
                },
                "strasse": {
                  "type": "string",
                  "description": "Die Straße der Adresse des Patienten ohne die Hausnummer"
                },
                "hausnummer": {
                  "type": "string",
                  "description": "Die Hausnummer der Adresse des Patienten ohne die Straße"
                },
                "postleitzahl": {
                  "type": "string",
                  "description": "Die Postleitzahl der Adresse des Patienten ohne die Stadt"
                },
                "stadt": {
                  "type": "string",
                  "description": "Die Stadt der Adresse des Patienten ohne die Postleitzahl"
                },
                "geburtstag": {
                  "type": "string",
                  "description": "Der Geburtstag des Patienten im Format YYYY-MM-DD"
                },
                "rezeptpositionen": {
                  "type": "array",
                  "description": "Die aufgelisteten benötigten Behandlungen auf dem Rezept",
                  "items": {
                    "type": "object",
                    "properties": {
                      "anzahl": {
                        "type": "integer",
                        "description": "Wie oft die Behandlung durchgeführt werden soll"
                      },
                      "behandlung": {
                        "enum": [
                          "${behandlungen.joinToString("\",\"")}"
                        ],
                        "description": "Welche Behandlung verschrieben wurde"
                      }
                    },
                    "required": ["anzahl", "behandlung"],
                    "additionalProperties" : false
                  }
                }
              },
              "required": ["ausgestellt_am", "titel", "vorname", "nachname", "strasse", "hausnummer", "postleitzahl", "stadt", "geburtstag", "rezeptpositionen"],
              "additionalProperties" : false
            }
            """.trimIndent()

        return JsonSchema
            .builder()
            .schema(schema)
            .strict(true)
            .build()
    }
}
