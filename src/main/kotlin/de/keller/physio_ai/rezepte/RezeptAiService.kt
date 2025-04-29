package de.keller.physio_ai.rezepte

import com.fasterxml.jackson.databind.PropertyNamingStrategies
import com.fasterxml.jackson.databind.annotation.JsonNaming
import de.keller.physio_ai.patienten.PatientenRepository
import de.keller.physio_ai.patienten.web.PatientDto
import de.keller.physio_ai.rezepte.web.BehandlungsartDto
import org.springframework.ai.chat.client.ChatClient
import org.springframework.ai.chat.messages.UserMessage
import org.springframework.ai.model.Media
import org.springframework.ai.openai.OpenAiChatOptions
import org.springframework.ai.openai.api.OpenAiApi
import org.springframework.ai.openai.api.ResponseFormat
import org.springframework.ai.openai.api.ResponseFormat.JsonSchema
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import org.springframework.util.MimeType
import org.springframework.web.multipart.MultipartFile
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.StandardCopyOption
import java.time.LocalDate
import java.util.*

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
class RezeptService(
    private val behandlungsartenRepository: BehandlungsartenRepository,
    private val chatClientBuilder: ChatClient.Builder,
    private val patientenRepository: PatientenRepository,
    @Value("\${rezepte.path}") val rezeptePath: String,
) {
    fun rezeptEinlesen(file: MultipartFile): RezeptEinlesenResponse? {
        val rezept = getRezeptDataFromImage(file) ?: return null

        val path = "/tmp/${UUID.randomUUID()}.${file.originalFilename?.split(".")?.last()}"

        saveFile(file, "$rezeptePath$path")

        val matchingPatienten = patientenRepository.findPatientByGeburtstag(rezept.geburtstag)

        val matchingPatient =
            matchingPatienten.firstOrNull { it.nachname == rezept.nachname }
                ?: matchingPatienten.firstOrNull {
                    it.strasse == rezept.strasse
                            && it.hausnummer == rezept.hausnummer
                            && it.plz == rezept.postleitzahl
                            && it.stadt == rezept.stadt
                }

        val behandlungsarten = behandlungsartenRepository.findAllByName(rezept.rezeptpositionen.map { it.behandlung })

        return RezeptEinlesenResponse(
            existingPatient = matchingPatient?.let { PatientDto.fromPatient(it) },
            patient = EingelesenerPatientDto(
                titel = rezept.titel,
                vorname = rezept.vorname,
                nachname = rezept.nachname,
                strasse = rezept.strasse,
                hausnummer = rezept.hausnummer,
                postleitzahl = rezept.postleitzahl,
                stadt = rezept.stadt,
                geburtstag = rezept.geburtstag,
            ),
            rezept = EingelesenesRezeptDto(
                ausgestelltAm = rezept.ausgestelltAm,
                rezeptpositionen = rezept.rezeptpositionen.map { pos ->
                    EingelesenesRezeptPosDto(
                        anzahl = pos.anzahl,
                        behandlungsart = behandlungsarten.first { it.name == pos.behandlung }
                            .let { BehandlungsartDto.fromBehandlungsart(it) }
                    )
                }
            ),
            path = "/rezepte$path"
        )
    }

    private fun saveFile(file: MultipartFile, location: String) {
        Files.copy(file.inputStream, Path.of(location), StandardCopyOption.REPLACE_EXISTING)
    }

    private fun getRezeptDataFromImage(file: MultipartFile): RezeptAiResponse? {
        val behandlungsarten = behandlungsartenRepository.findAll().map(Behandlungsart::name)

        val defaultOptions = OpenAiChatOptions.builder()
            .withModel(OpenAiApi.ChatModel.GPT_4_O)
            .withTemperature(0.0)
            .build()

        val chatClient = chatClientBuilder
            .defaultOptions(defaultOptions)
            .build()

        val schema = getJsonSchemaForAiResponse(behandlungsarten)
        val format = ResponseFormat.builder()
            .type(ResponseFormat.Type.JSON_SCHEMA)
            .jsonSchema(schema)
            .build()

        val options = OpenAiChatOptions.builder()
            .withResponseFormat(format)
            .build()

        val response = chatClient
            .prompt()
            .options(options)
            .messages(
                listOf(
                    UserMessage(
                        "Das folgende Bild ist ein Rezept für Physiotherapie. Gibt die Informationen aus dem Bild zurück.",
                        Media(MimeType.valueOf(file.contentType!!), file.resource)
                    )
                )
            )
            .call()

        val parsedResponse = response.responseEntity(RezeptAiResponse::class.java)

        return parsedResponse.entity
    }

    fun getJsonSchemaForAiResponse(behandlungen: List<String>): JsonSchema {
        val schema = """
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

        return JsonSchema.builder().schema(schema).strict(true).build()
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
