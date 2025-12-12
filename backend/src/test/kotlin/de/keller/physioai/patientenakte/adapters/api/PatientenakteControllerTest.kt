package de.keller.physioai.patientenakte.adapters.api

import com.ninjasquad.springmockk.MockkBean
import de.keller.physioai.patientenakte.domain.FreieNotiz
import de.keller.physioai.patientenakte.domain.NotizKategorie
import de.keller.physioai.patientenakte.ports.PatientenakteService
import de.keller.physioai.shared.EintragId
import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.config.SecurityConfig
import io.mockk.every
import io.mockk.verify
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.springframework.context.annotation.Import
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.status
import java.time.LocalDateTime
import java.util.UUID

@Import(SecurityConfig::class)
@WebMvcTest(PatientenakteController::class)
class PatientenakteControllerTest {
    @Autowired
    private lateinit var mockMvc: MockMvc

    @MockkBean(relaxed = true)
    private lateinit var patientenakteService: PatientenakteService

    @Nested
    inner class CreateFreieNotiz {
        @Test
        fun `should return 201 when creating freie notiz with valid data`() {
            // Arrange
            val patientId = PatientId(UUID.randomUUID())
            val eintragId = EintragId(UUID.randomUUID())
            val now = LocalDateTime.now()

            val createdNotiz = FreieNotiz(
                id = eintragId,
                kategorie = NotizKategorie.SONSTIGES,
                inhalt = "Eine Testnotiz",
                istAngepinnt = false,
                erstelltAm = now,
                aktualisiertAm = null,
            )

            every {
                patientenakteService.erstelleFreieNotiz(
                    patientId = patientId,
                    kategorie = NotizKategorie.SONSTIGES,
                    inhalt = "Eine Testnotiz",
                )
            } returns createdNotiz

            // Act & Assert
            mockMvc
                .perform(
                    post("/patientenakte/${patientId.id}/notizen")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                        {
                            "kategorie": "SONSTIGES",
                            "inhalt": "Eine Testnotiz"
                        }
                        """,
                        ),
                ).andExpect(status().isCreated)
                .andExpect(jsonPath("$.id").value(eintragId.id.toString()))
                .andExpect(jsonPath("$.kategorie").value("SONSTIGES"))
                .andExpect(jsonPath("$.inhalt").value("Eine Testnotiz"))

            verify { patientenakteService.erstelleFreieNotiz(patientId, NotizKategorie.SONSTIGES, "Eine Testnotiz") }
        }

        @Test
        fun `should return 400 when kategorie is blank`() {
            // Arrange
            val patientId = UUID.randomUUID()

            // Act & Assert
            mockMvc
                .perform(
                    post("/patientenakte/$patientId/notizen")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                        {
                            "kategorie": "",
                            "inhalt": "Eine Testnotiz"
                        }
                        """,
                        ),
                ).andExpect(status().isBadRequest)
        }

        @Test
        fun `should return 400 when kategorie is whitespace only`() {
            // Arrange
            val patientId = UUID.randomUUID()

            // Act & Assert
            mockMvc
                .perform(
                    post("/patientenakte/$patientId/notizen")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                        {
                            "kategorie": "   ",
                            "inhalt": "Eine Testnotiz"
                        }
                        """,
                        ),
                ).andExpect(status().isBadRequest)
        }

        @Test
        fun `should return 400 when inhalt is blank`() {
            // Arrange
            val patientId = UUID.randomUUID()

            // Act & Assert
            mockMvc
                .perform(
                    post("/patientenakte/$patientId/notizen")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                        {
                            "kategorie": "SONSTIGES",
                            "inhalt": ""
                        }
                        """,
                        ),
                ).andExpect(status().isBadRequest)
        }

        @Test
        fun `should return 400 when inhalt is whitespace only`() {
            // Arrange
            val patientId = UUID.randomUUID()

            // Act & Assert
            mockMvc
                .perform(
                    post("/patientenakte/$patientId/notizen")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                        {
                            "kategorie": "SONSTIGES",
                            "inhalt": "   "
                        }
                        """,
                        ),
                ).andExpect(status().isBadRequest)
        }

        @Test
        fun `should return 400 when inhalt exceeds maximum length`() {
            // Arrange
            val patientId = UUID.randomUUID()
            val tooLongInhalt = "a".repeat(10001)

            // Act & Assert
            mockMvc
                .perform(
                    post("/patientenakte/$patientId/notizen")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                        {
                            "kategorie": "SONSTIGES",
                            "inhalt": "$tooLongInhalt"
                        }
                        """,
                        ),
                ).andExpect(status().isBadRequest)
        }
    }

    @Nested
    inner class UpdateFreieNotiz {
        @Test
        fun `should return 400 when inhalt is blank`() {
            // Arrange
            val patientId = UUID.randomUUID()
            val eintragId = UUID.randomUUID()

            // Act & Assert
            mockMvc
                .perform(
                    patch("/patientenakte/$patientId/notizen/$eintragId")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                        {
                            "inhalt": ""
                        }
                        """,
                        ),
                ).andExpect(status().isBadRequest)
        }

        @Test
        fun `should return 400 when inhalt is whitespace only`() {
            // Arrange
            val patientId = UUID.randomUUID()
            val eintragId = UUID.randomUUID()

            // Act & Assert
            mockMvc
                .perform(
                    patch("/patientenakte/$patientId/notizen/$eintragId")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                        {
                            "inhalt": "   "
                        }
                        """,
                        ),
                ).andExpect(status().isBadRequest)
        }

        @Test
        fun `should return 400 when inhalt exceeds maximum length`() {
            // Arrange
            val patientId = UUID.randomUUID()
            val eintragId = UUID.randomUUID()
            val tooLongInhalt = "a".repeat(10001)

            // Act & Assert
            mockMvc
                .perform(
                    patch("/patientenakte/$patientId/notizen/$eintragId")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                        {
                            "inhalt": "$tooLongInhalt"
                        }
                        """,
                        ),
                ).andExpect(status().isBadRequest)
        }
    }

    @Nested
    inner class UpdateBehandlungsNotiz {
        @Test
        fun `should return 400 when inhalt is blank`() {
            // Arrange
            val patientId = UUID.randomUUID()
            val eintragId = UUID.randomUUID()

            // Act & Assert
            mockMvc
                .perform(
                    patch("/patientenakte/$patientId/behandlungen/$eintragId/notiz")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                        {
                            "inhalt": ""
                        }
                        """,
                        ),
                ).andExpect(status().isBadRequest)
        }

        @Test
        fun `should return 400 when inhalt exceeds maximum length`() {
            // Arrange
            val patientId = UUID.randomUUID()
            val eintragId = UUID.randomUUID()
            val tooLongInhalt = "a".repeat(10001)

            // Act & Assert
            mockMvc
                .perform(
                    patch("/patientenakte/$patientId/behandlungen/$eintragId/notiz")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                        {
                            "inhalt": "$tooLongInhalt"
                        }
                        """,
                        ),
                ).andExpect(status().isBadRequest)
        }
    }
}
