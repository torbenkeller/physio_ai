package de.keller.physioai.rezepte.web

import com.ninjasquad.springmockk.MockkBean
import de.keller.physioai.config.SecurityConfig
import de.keller.physioai.patienten.Patient
import de.keller.physioai.patienten.PatientId
import de.keller.physioai.patienten.PatientenRepository
import de.keller.physioai.patienten.web.PatientDto
import de.keller.physioai.rezepte.domain.AerzteRepository
import de.keller.physioai.rezepte.domain.Arzt
import de.keller.physioai.rezepte.domain.ArztId
import de.keller.physioai.rezepte.domain.Behandlungsart
import de.keller.physioai.rezepte.domain.BehandlungsartId
import de.keller.physioai.rezepte.domain.BehandlungsartenRepository
import de.keller.physioai.rezepte.domain.EingelesenerPatientDto
import de.keller.physioai.rezepte.domain.EingelesenesRezeptDto
import de.keller.physioai.rezepte.domain.EingelesenesRezeptPosDto
import de.keller.physioai.rezepte.domain.Rezept
import de.keller.physioai.rezepte.domain.RezeptAiService
import de.keller.physioai.rezepte.domain.RezeptEinlesenResponse
import de.keller.physioai.rezepte.domain.RezeptId
import de.keller.physioai.rezepte.domain.RezeptPos
import de.keller.physioai.rezepte.domain.RezeptRepository
import de.keller.physioai.rezepte.domain.RezeptService
import io.mockk.every
import io.mockk.just
import io.mockk.runs
import io.mockk.verify
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.springframework.context.annotation.Import
import org.springframework.http.MediaType
import org.springframework.mock.web.MockMultipartFile
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.content
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.status
import java.time.LocalDate
import java.util.UUID

@Import(SecurityConfig::class)
@WebMvcTest(RezepteController::class)
class RezepteControllerTest {
    @Autowired
    private lateinit var mockMvc: MockMvc

    @MockkBean
    private lateinit var rezeptRepository: RezeptRepository

    @MockkBean
    private lateinit var behandlungsartenRepository: BehandlungsartenRepository

    @MockkBean
    private lateinit var aerzteRepository: AerzteRepository

    @MockkBean
    private lateinit var patientenRepository: PatientenRepository

    @MockkBean
    private lateinit var rezeptAiService: RezeptAiService

    @MockkBean
    private lateinit var rezeptService: RezeptService

    private val patientId = PatientId.generate()
    private val behandlungsartId1 = BehandlungsartId.generate()
    private val behandlungsartId2 = BehandlungsartId.generate()
    private val arztId = ArztId.generate()
    private val rezeptId1 = RezeptId.generate()
    private val rezeptId2 = RezeptId.generate()
    private val ausgestelltAm = LocalDate.of(2023, 1, 1)

    private lateinit var patient: Patient
    private lateinit var behandlungsart1: Behandlungsart
    private lateinit var behandlungsart2: Behandlungsart
    private lateinit var arzt: Arzt
    private lateinit var rezept1: Rezept
    private lateinit var rezept2: Rezept

    @BeforeEach
    fun setUp() {
        // Initialize test data
        patient = Patient(
            id = patientId,
            titel = null,
            vorname = "Max",
            nachname = "Mustermann",
            strasse = "Musterstraße",
            hausnummer = "1",
            plz = "12345",
            stadt = "Musterstadt",
            telMobil = "0123456789",
            telFestnetz = null,
            email = "max.mustermann@example.com",
            geburtstag = LocalDate.of(1980, 1, 1),
        )

        behandlungsart1 = Behandlungsart(
            id = behandlungsartId1,
            name = "Manuelle Therapie",
            preis = 75.2,
        )

        behandlungsart2 = Behandlungsart(
            id = behandlungsartId2,
            name = "Klassische Massagetherapie",
            preis = 22.84,
        )

        arzt = Arzt(
            id = arztId,
            name = "Dr. Medicus",
        )

        val rezeptPos1 = RezeptPos(
            id = UUID.randomUUID(),
            behandlungsartId = behandlungsartId1,
            anzahl = 6,
            einzelpreis = behandlungsart1.preis,
            preisGesamt = behandlungsart1.preis * 6,
            behandlungsartName = behandlungsart1.name,
        )

        val rezeptPos2 = RezeptPos(
            id = UUID.randomUUID(),
            behandlungsartId = behandlungsartId2,
            anzahl = 10,
            einzelpreis = behandlungsart2.preis,
            preisGesamt = behandlungsart2.preis * 10,
            behandlungsartName = behandlungsart2.name,
        )

        rezept1 = Rezept(
            id = rezeptId1,
            patientId = patientId,
            ausgestelltAm = ausgestelltAm,
            ausgestelltVonArztId = arztId,
            preisGesamt = (6 * behandlungsart1.preis),
            positionen = listOf(rezeptPos1),
            version = 1,
        )

        rezept2 = Rezept(
            id = rezeptId2,
            patientId = patientId,
            ausgestelltAm = LocalDate.of(2023, 2, 15),
            ausgestelltVonArztId = null,
            preisGesamt = (10 * behandlungsart2.preis),
            positionen = listOf(rezeptPos2),
            version = 1,
        )
    }

    @Nested
    inner class GetRezepte {
        @Test
        fun `should return empty list when no rezepte exist`() {
            // Arrange
            every { rezeptRepository.findAll() } returns emptyList()

            // Act & Assert
            mockMvc
                .perform(get("/rezepte"))
                .andExpect(status().isOk)
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(content().json("[]"))

            verify { rezeptRepository.findAll() }
            verify(exactly = 0) { aerzteRepository.findAllByIdIn(any()) }
            verify(exactly = 0) { patientenRepository.findAllByIdIn(any()) }
        }

        @Test
        fun `should return list of rezepte with related data`() {
            // Arrange
            every { rezeptRepository.findAll() } returns listOf(rezept1, rezept2)
            every { aerzteRepository.findAllByIdIn(listOf(arztId)) } returns listOf(arzt)
            every { patientenRepository.findAllByIdIn(listOf(patientId, patientId)) } returns listOf(patient)

            // Act & Assert
            mockMvc
                .perform(get("/rezepte"))
                .andExpect(status().isOk)
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$").isArray)
                .andExpect(jsonPath("$.length()").value(2))
                .andExpect(jsonPath("$[0].id").value(rezept1.id.id.toString()))
                .andExpect(jsonPath("$[0].patient.id").value(patientId.id.toString()))
                .andExpect(jsonPath("$[0].ausgestelltVon.id").value(arztId.id.toString()))
                .andExpect(jsonPath("$[1].id").value(rezept2.id.id.toString()))
                .andExpect(jsonPath("$[1].patient.id").value(patientId.id.toString()))
                .andExpect(jsonPath("$[1].ausgestelltVon").doesNotExist())

            verify { rezeptRepository.findAll() }
            verify { aerzteRepository.findAllByIdIn(listOf(arztId)) }
            verify { patientenRepository.findAllByIdIn(listOf(patientId, patientId)) }
        }
    }

    @Nested
    inner class DeleteRezept {
        @Test
        fun `should delete rezept successfully`() {
            // Arrange
            every { rezeptRepository.deleteById(any()) } just runs

            // Act & Assert
            mockMvc
                .perform(delete("/rezepte/${rezeptId1.id}"))
                .andExpect(status().isOk)

            verify { rezeptRepository.deleteById(rezeptId1) }
        }
    }

    @Nested
    inner class CreateRezept {
        @Test
        fun `should create rezept successfully`() {
            // Arrange
            every { rezeptService.createRezept(any()) } returns rezept1
            every { patientenRepository.findById(patientId) } returns patient
            every { aerzteRepository.findById(arztId) } returns arzt

            // Act & Assert
            mockMvc
                .perform(
                    post("/rezepte")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                        {
                            "patientId": "${patientId.id}",
                            "ausgestelltAm": "2023-01-01",
                            "positionen": [
                                {
                                    "behandlungsartId": "${behandlungsartId1.id}",
                                    "anzahl": 6
                                }
                            ]
                        }
                    """,
                        ),
                ).andExpect(status().isOk)
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(rezept1.id.id.toString()))
                .andExpect(jsonPath("$.patient.id").value(rezept1.patientId.id.toString()))
                .andExpect(jsonPath("$.ausgestelltAm").value("2023-01-01"))
                .andExpect(jsonPath("$.positionen[0].behandlungsart.id").value(behandlungsartId1.id.toString()))
                .andExpect(jsonPath("$.positionen[0].anzahl").value(6))

            verify { rezeptService.createRezept(any()) }
            verify { patientenRepository.findById(patientId) }
            verify { aerzteRepository.findById(arztId) }
        }
    }

    @Nested
    inner class UpdateRezept {
        @Test
        fun `should update rezept successfully`() {
            // Arrange
            val newAusgestelltAm = LocalDate.of(2023, 3, 15)
            val updatedRezept = rezept1.copy(
                ausgestelltAm = newAusgestelltAm,
                positionen = listOf(
                    RezeptPos(
                        id = UUID.randomUUID(),
                        behandlungsartId = behandlungsartId2,
                        anzahl = 12,
                        einzelpreis = behandlungsart2.preis,
                        preisGesamt = behandlungsart2.preis * 12,
                        behandlungsartName = behandlungsart2.name,
                    ),
                ),
                preisGesamt = behandlungsart2.preis * 12,
            )

            // Mock the service and repository calls
            every { rezeptService.updateRezept(any(), any()) } returns updatedRezept
            every { patientenRepository.findById(patientId) } returns patient
            every { aerzteRepository.findById(arztId) } returns arzt

            // Act & Assert
            mockMvc
                .perform(
                    patch("/rezepte/${rezeptId1.id}")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                        {
                            "patientId": "${patientId.id}",
                            "ausgestelltAm": "2023-03-15",
                            "positionen": [
                                {
                                    "behandlungsartId": "${behandlungsartId2.id}",
                                    "anzahl": 12
                                }
                            ]
                        }
                    """,
                        ),
                ).andExpect(status().isOk)
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(rezeptId1.id.toString()))
                .andExpect(jsonPath("$.patient.id").value(patientId.id.toString()))
                .andExpect(jsonPath("$.ausgestelltAm").value("2023-03-15"))
                .andExpect(jsonPath("$.positionen[0].behandlungsart.id").value(behandlungsartId2.id.toString()))
                .andExpect(jsonPath("$.positionen[0].anzahl").value(12))

            // Verify that the service was called
            verify { rezeptService.updateRezept(rezeptId1, any()) }
            verify { patientenRepository.findById(patientId) }
            verify { aerzteRepository.findById(arztId) }
        }
    }

    @Nested
    inner class CreateFromImage {
        @Test
        fun `should process rezept image successfully`() {
            // Arrange
            val mockFile = MockMultipartFile(
                "file",
                "test-rezept.jpg",
                MediaType.IMAGE_JPEG_VALUE,
                "test image content".toByteArray(),
            )

            val expectedResponse = RezeptEinlesenResponse(
                existingPatient = PatientDto.fromPatient(patient),
                patient = EingelesenerPatientDto(
                    titel = null,
                    vorname = "Max",
                    nachname = "Mustermann",
                    strasse = "Musterstraße",
                    hausnummer = "1",
                    postleitzahl = "12345",
                    stadt = "Musterstadt",
                    geburtstag = LocalDate.of(1980, 1, 1),
                ),
                rezept = EingelesenesRezeptDto(
                    ausgestelltAm = ausgestelltAm,
                    rezeptpositionen = listOf(
                        EingelesenesRezeptPosDto(
                            anzahl = 6,
                            behandlungsart = BehandlungsartDto(
                                id = behandlungsartId1.id,
                                name = behandlungsart1.name,
                                preis = behandlungsart1.preis,
                            ),
                        ),
                    ),
                ),
                path = "/rezepte/tmp/some-file.jpg",
            )

            every { rezeptService.rezeptEinlesen(any()) } returns expectedResponse

            // Act & Assert
            mockMvc
                .perform(
                    multipart("/rezepte/createFromImage")
                        .file(mockFile),
                ).andExpect(status().isOk)
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.existingPatient.id").value(patientId.id.toString()))
                .andExpect(jsonPath("$.patient.vorname").value("Max"))
                .andExpect(jsonPath("$.rezept.ausgestelltAm").value("2023-01-01"))
                .andExpect(jsonPath("$.path").value("/rezepte/tmp/some-file.jpg"))

            verify { rezeptService.rezeptEinlesen(any()) }
        }

        @Test
        fun `should handle null response from AI service`() {
            // Arrange
            val mockFile = MockMultipartFile(
                "file",
                "test-rezept.jpg",
                MediaType.IMAGE_JPEG_VALUE,
                "test image content".toByteArray(),
            )

            every { rezeptService.rezeptEinlesen(any()) } returns null

            // Act & Assert
            mockMvc
                .perform(
                    multipart("/rezepte/createFromImage")
                        .file(mockFile),
                ).andExpect(status().isOk)
                .andExpect(jsonPath("$").doesNotExist())

            verify { rezeptService.rezeptEinlesen(any()) }
        }
    }

    @Nested
    inner class GetBehandlungsarten {
        @Test
        fun `should return list of behandlungsarten`() {
            // Arrange
            every { behandlungsartenRepository.findAll() } returns listOf(behandlungsart1, behandlungsart2)

            // Act & Assert
            mockMvc
                .perform(get("/rezepte/behandlungsarten"))
                .andExpect(status().isOk)
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$").isArray)
                .andExpect(jsonPath("$.length()").value(2))
                .andExpect(jsonPath("$[0].id").value(behandlungsartId1.id.toString()))
                .andExpect(jsonPath("$[0].name").value("Manuelle Therapie"))
                .andExpect(jsonPath("$[0].preis").value(75.2))
                .andExpect(jsonPath("$[1].id").value(behandlungsartId2.id.toString()))
                .andExpect(jsonPath("$[1].name").value("Klassische Massagetherapie"))
                .andExpect(jsonPath("$[1].preis").value(22.84))

            verify { behandlungsartenRepository.findAll() }
        }

        @Test
        fun `should return empty list when no behandlungsarten exist`() {
            // Arrange
            every { behandlungsartenRepository.findAll() } returns emptyList()

            // Act & Assert
            mockMvc
                .perform(get("/rezepte/behandlungsarten"))
                .andExpect(status().isOk)
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(content().json("[]"))

            verify { behandlungsartenRepository.findAll() }
        }
    }
}
