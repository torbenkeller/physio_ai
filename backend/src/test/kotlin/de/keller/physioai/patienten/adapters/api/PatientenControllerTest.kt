package de.keller.physioai.patienten.adapters.api

import com.ninjasquad.springmockk.MockkBean
import de.keller.physioai.patienten.domain.PatientAggregate
import de.keller.physioai.patienten.ports.PatientenRepository
import de.keller.physioai.patienten.ports.PatientenService
import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.config.SecurityConfig
import io.mockk.every
import io.mockk.verify
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.springframework.context.annotation.Import
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.status
import java.time.LocalDate
import java.util.UUID

@Import(SecurityConfig::class)
@WebMvcTest(PatientenController::class)
class PatientenControllerTest {
    @Autowired
    private lateinit var mockMvc: MockMvc

    @MockkBean
    private lateinit var patientenService: PatientenService

    @MockkBean
    private lateinit var patientenRepository: PatientenRepository

    @Test
    fun `createPatient should return PatientDto when valid data is provided`() {
        // Given - valid patient data
        val patientId = PatientId(UUID.randomUUID())
        val expectedPatient = PatientAggregate
            .create(
                titel = "Dr.",
                vorname = "Max",
                nachname = "Mustermann",
                strasse = "Musterstraße",
                hausnummer = "1",
                plz = "12345",
                stadt = "Musterstadt",
                telMobil = "0123456789",
                telFestnetz = "0987654321",
                email = "max@example.com",
                geburtstag = LocalDate.of(1990, 1, 1),
                behandlungenProRezept = null,
            ).copy(id = patientId)

        every {
            patientenService.createPatient(
                titel = "Dr.",
                vorname = "Max",
                nachname = "Mustermann",
                strasse = "Musterstraße",
                hausnummer = "1",
                plz = "12345",
                stadt = "Musterstadt",
                telMobil = "0123456789",
                telFestnetz = "0987654321",
                email = "max@example.com",
                geburtstag = LocalDate.of(1990, 1, 1),
                behandlungenProRezept = null,
            )
        } returns expectedPatient

        // When/Then - POST request with valid data should succeed
        mockMvc
            .perform(
                post("/patienten")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        """
                        {
                            "titel": "Dr.",
                            "vorname": "Max",
                            "nachname": "Mustermann",
                            "strasse": "Musterstraße",
                            "hausnummer": "1",
                            "plz": "12345",
                            "stadt": "Musterstadt",
                            "telMobil": "0123456789",
                            "telFestnetz": "0987654321",
                            "email": "max@example.com",
                            "geburtstag": "1990-01-01"
                        }
                        """.trimIndent(),
                    ),
            ).andExpect(status().isOk)
            .andExpect(jsonPath("$.id").value(patientId.id.toString()))
            .andExpect(jsonPath("$.vorname").value("Max"))
            .andExpect(jsonPath("$.nachname").value("Mustermann"))

        verify {
            patientenService.createPatient(
                titel = "Dr.",
                vorname = "Max",
                nachname = "Mustermann",
                strasse = "Musterstraße",
                hausnummer = "1",
                plz = "12345",
                stadt = "Musterstadt",
                telMobil = "0123456789",
                telFestnetz = "0987654321",
                email = "max@example.com",
                geburtstag = LocalDate.of(1990, 1, 1),
                behandlungenProRezept = null,
            )
        }
    }

    @Test
    fun `createPatient should return 400 when vorname is empty`() {
        // Given - empty vorname causes service to throw IllegalArgumentException
        every {
            patientenService.createPatient(
                titel = null,
                vorname = "",
                nachname = "Mustermann",
                strasse = null,
                hausnummer = null,
                plz = null,
                stadt = null,
                telMobil = null,
                telFestnetz = null,
                email = null,
                geburtstag = null,
                behandlungenProRezept = null,
            )
        } throws IllegalArgumentException("Vorname darf nicht leer sein")

        // When/Then - POST request with empty vorname should return 400
        mockMvc
            .perform(
                post("/patienten")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        """
                        {
                            "vorname": "",
                            "nachname": "Mustermann"
                        }
                        """.trimIndent(),
                    ),
            ).andExpect(status().isBadRequest)

        verify {
            patientenService.createPatient(
                titel = null,
                vorname = "",
                nachname = "Mustermann",
                strasse = null,
                hausnummer = null,
                plz = null,
                stadt = null,
                telMobil = null,
                telFestnetz = null,
                email = null,
                geburtstag = null,
                behandlungenProRezept = null,
            )
        }
    }

    @Test
    fun `createPatient should return 400 when nachname is empty`() {
        // Given - empty nachname causes service to throw IllegalArgumentException
        every {
            patientenService.createPatient(
                titel = null,
                vorname = "Max",
                nachname = "",
                strasse = null,
                hausnummer = null,
                plz = null,
                stadt = null,
                telMobil = null,
                telFestnetz = null,
                email = null,
                geburtstag = null,
                behandlungenProRezept = null,
            )
        } throws IllegalArgumentException("Nachname darf nicht leer sein")

        // When/Then - POST request with empty nachname should return 400
        mockMvc
            .perform(
                post("/patienten")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        """
                        {
                            "vorname": "Max",
                            "nachname": ""
                        }
                        """.trimIndent(),
                    ),
            ).andExpect(status().isBadRequest)

        verify {
            patientenService.createPatient(
                titel = null,
                vorname = "Max",
                nachname = "",
                strasse = null,
                hausnummer = null,
                plz = null,
                stadt = null,
                telMobil = null,
                telFestnetz = null,
                email = null,
                geburtstag = null,
                behandlungenProRezept = null,
            )
        }
    }

    @Test
    fun `createPatient should return 400 when both vorname and nachname are empty`() {
        // Given - both names empty causes service to throw IllegalArgumentException
        every {
            patientenService.createPatient(
                titel = null,
                vorname = "",
                nachname = "",
                strasse = null,
                hausnummer = null,
                plz = null,
                stadt = null,
                telMobil = null,
                telFestnetz = null,
                email = null,
                geburtstag = null,
                behandlungenProRezept = null,
            )
        } throws IllegalArgumentException("Vorname darf nicht leer sein")

        // When/Then - POST request with both names empty should return 400
        mockMvc
            .perform(
                post("/patienten")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        """
                        {
                            "vorname": "",
                            "nachname": ""
                        }
                        """.trimIndent(),
                    ),
            ).andExpect(status().isBadRequest)

        verify {
            patientenService.createPatient(
                titel = null,
                vorname = "",
                nachname = "",
                strasse = null,
                hausnummer = null,
                plz = null,
                stadt = null,
                telMobil = null,
                telFestnetz = null,
                email = null,
                geburtstag = null,
                behandlungenProRezept = null,
            )
        }
    }

    @Test
    fun `createPatient should return 400 when vorname is blank (whitespace only)`() {
        // Given - blank vorname causes service to throw IllegalArgumentException
        every {
            patientenService.createPatient(
                titel = null,
                vorname = "   ",
                nachname = "Mustermann",
                strasse = null,
                hausnummer = null,
                plz = null,
                stadt = null,
                telMobil = null,
                telFestnetz = null,
                email = null,
                geburtstag = null,
                behandlungenProRezept = null,
            )
        } throws IllegalArgumentException("Vorname darf nicht leer sein")

        // When/Then - POST request with blank vorname should return 400
        mockMvc
            .perform(
                post("/patienten")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        """
                        {
                            "vorname": "   ",
                            "nachname": "Mustermann"
                        }
                        """.trimIndent(),
                    ),
            ).andExpect(status().isBadRequest)

        verify {
            patientenService.createPatient(
                titel = null,
                vorname = "   ",
                nachname = "Mustermann",
                strasse = null,
                hausnummer = null,
                plz = null,
                stadt = null,
                telMobil = null,
                telFestnetz = null,
                email = null,
                geburtstag = null,
                behandlungenProRezept = null,
            )
        }
    }

    @Test
    fun `createPatient should return 400 when nachname is blank (whitespace only)`() {
        // Given - blank nachname causes service to throw IllegalArgumentException
        every {
            patientenService.createPatient(
                titel = null,
                vorname = "Max",
                nachname = "   ",
                strasse = null,
                hausnummer = null,
                plz = null,
                stadt = null,
                telMobil = null,
                telFestnetz = null,
                email = null,
                geburtstag = null,
                behandlungenProRezept = null,
            )
        } throws IllegalArgumentException("Nachname darf nicht leer sein")

        // When/Then - POST request with blank nachname should return 400
        mockMvc
            .perform(
                post("/patienten")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        """
                        {
                            "vorname": "Max",
                            "nachname": "   "
                        }
                        """.trimIndent(),
                    ),
            ).andExpect(status().isBadRequest)

        verify {
            patientenService.createPatient(
                titel = null,
                vorname = "Max",
                nachname = "   ",
                strasse = null,
                hausnummer = null,
                plz = null,
                stadt = null,
                telMobil = null,
                telFestnetz = null,
                email = null,
                geburtstag = null,
                behandlungenProRezept = null,
            )
        }
    }
}
