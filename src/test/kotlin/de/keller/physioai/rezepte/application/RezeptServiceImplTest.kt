package de.keller.physioai.rezepte.application

import de.keller.physioai.patienten.PatientId
import de.keller.physioai.patienten.adapters.jdbc.PatientenRepositoryImpl
import de.keller.physioai.patienten.domain.PatientAggregate
import de.keller.physioai.rezepte.RezeptId
import de.keller.physioai.rezepte.RezeptRepository
import de.keller.physioai.rezepte.adapters.rest.RezeptCreateDto
import de.keller.physioai.rezepte.adapters.rest.RezeptPosCreateDto
import de.keller.physioai.rezepte.adapters.rest.RezeptUpdateDto
import de.keller.physioai.rezepte.domain.Behandlung
import de.keller.physioai.rezepte.domain.Behandlungsart
import de.keller.physioai.rezepte.domain.BehandlungsartId
import de.keller.physioai.rezepte.domain.Rezept
import de.keller.physioai.rezepte.domain.RezeptPos
import de.keller.physioai.rezepte.ports.BehandlungsartenRepository
import de.keller.physioai.rezepte.ports.EingelesenesRezeptPosRaw
import de.keller.physioai.rezepte.ports.EingelesenesRezeptRaw
import de.keller.physioai.rezepte.ports.RezeptService
import de.keller.physioai.rezepte.ports.RezepteAiService
import de.keller.physioai.shared.AggregateNotFoundException
import io.mockk.clearAllMocks
import io.mockk.every
import io.mockk.impl.annotations.MockK
import io.mockk.junit5.MockKExtension
import io.mockk.mockkStatic
import io.mockk.slot
import io.mockk.verify
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.springframework.mock.web.MockMultipartFile
import java.io.InputStream
import java.nio.file.Files
import java.nio.file.Path
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertNotNull
import kotlin.test.assertNull

@ExtendWith(MockKExtension::class)
class RezeptServiceImplTest {
    @MockK
    private lateinit var rezeptRepository: RezeptRepository

    @MockK
    private lateinit var behandlungsartenRepository: BehandlungsartenRepository

    @MockK
    private lateinit var patientenRepository: PatientenRepositoryImpl

    @MockK
    private lateinit var rezepteAiService: RezepteAiService

    private lateinit var rezeptService: RezeptService

    private val patientId = PatientId.Companion.generate()
    private val behandlungsartId1 = BehandlungsartId.Companion.generate()
    private val behandlungsartId2 = BehandlungsartId.Companion.generate()
    private val ausgestelltAm = LocalDate.of(2023, 1, 1)

    private lateinit var patient: PatientAggregate
    private lateinit var behandlungsart1: Behandlungsart
    private lateinit var behandlungsart2: Behandlungsart

    @BeforeEach
    fun setUp() {
        clearAllMocks()

        // Initialize test data
        patient = PatientAggregate(
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

        rezeptService = RezeptServiceImpl(
            rezeptRepository,
            behandlungsartenRepository,
            patientenRepository,
            rezepteAiService,
        )
    }

    @Nested
    inner class RezeptEinlesen {
        @Test
        fun `should process prescription image successfully`() {
            // Arrange
            val file = MockMultipartFile(
                "file",
                "test.jpg",
                "image/jpeg",
                "test image content".toByteArray(),
            )

            val rezeptAiResponse = EingelesenesRezeptRaw(
                ausgestelltAm = LocalDate.of(2023, 1, 1),
                titel = null,
                vorname = "Max",
                nachname = "Mustermann",
                strasse = "Musterstraße",
                hausnummer = "1",
                postleitzahl = "12345",
                stadt = "Musterstadt",
                geburtstag = LocalDate.of(1980, 1, 1),
                rezeptpositionen = listOf(
                    EingelesenesRezeptPosRaw(
                        anzahl = 6,
                        behandlung = "Manuelle Therapie",
                    ),
                ),
            )

            // Setup mock behavior
            every { rezepteAiService.analyzeRezeptImage(file) } returns rezeptAiResponse
            every { patientenRepository.findPatientByGeburtstag(any()) } returns listOf(patient)
            every { behandlungsartenRepository.findAllByNameIn(any()) } returns listOf(behandlungsart1)

            // Mock file system operations
            mockkStatic(Files::class)
            every { Files.copy(any<InputStream>(), any<Path>(), any()) } returns 0L

            // Act
            val result = rezeptService.rezeptEinlesen(file)

            // Assert
            assertNotNull(result)
            assertEquals("Max", result.patient.vorname)
            assertEquals("Mustermann", result.patient.nachname)
            assertEquals(1, result.rezept.rezeptpositionen.size)

            // Verify interactions
            verify { rezepteAiService.analyzeRezeptImage(file) }
            verify { patientenRepository.findPatientByGeburtstag(any()) }
            verify { behandlungsartenRepository.findAllByNameIn(any()) }
        }

        @Test
        fun `should return null when AI analysis fails`() {
            // Arrange
            val file = MockMultipartFile(
                "file",
                "test.jpg",
                "image/jpeg",
                "test image content".toByteArray(),
            )

            // Setup mock behavior
            every { rezepteAiService.analyzeRezeptImage(file) } returns null

            // Act
            val result = rezeptService.rezeptEinlesen(file)

            // Assert
            assertNull(result)

            // Verify interactions
            verify { rezepteAiService.analyzeRezeptImage(file) }
            verify(exactly = 0) { patientenRepository.findPatientByGeburtstag(any()) }
            verify(exactly = 0) { behandlungsartenRepository.findAllByNameIn(any()) }
        }
    }

    @Nested
    inner class CreateRezept {
        @Test
        fun `should create a new rezept successfully`() {
            // Arrange
            val posCreateDto1 = RezeptPosCreateDto(
                behandlungsartId = behandlungsartId1.id,
                anzahl = 12,
            )

            val posCreateDto2 = RezeptPosCreateDto(
                behandlungsartId = behandlungsartId2.id,
                anzahl = 6,
            )

            val createDto = RezeptCreateDto(
                patientId = patientId.id,
                ausgestelltAm = ausgestelltAm,
                positionen = listOf(posCreateDto1, posCreateDto2),
            )

            // Setup mock behavior
            every { patientenRepository.findById(patientId) } returns patient
            every {
                behandlungsartenRepository.findAllByIdIn(setOf(behandlungsartId1, behandlungsartId2))
            } returns listOf(behandlungsart1, behandlungsart2)

            val savedRezeptSlot = slot<Rezept>()
            every { rezeptRepository.save(capture(savedRezeptSlot)) } answers { savedRezeptSlot.captured }

            // Act
            val result = rezeptService.createRezept(createDto)

            // Assert
            assertNotNull(result)
            assertEquals(patientId, result.patientId)
            assertEquals(ausgestelltAm, result.ausgestelltAm)
            assertEquals(2, result.positionen.size)

            // Verify expected preisGesamt calculation
            val expectedPreisGesamt = (12 * 75.2) + (6 * 22.84)
            assertEquals(expectedPreisGesamt, result.preisGesamt)

            // Verify interactions with repositories
            verify { patientenRepository.findById(patientId) }
            verify { behandlungsartenRepository.findAllByIdIn(setOf(behandlungsartId1, behandlungsartId2)) }
            verify { rezeptRepository.save(any()) }
        }

        @Test
        fun `should throw when no positions provided`() {
            // Arrange
            val createDto = RezeptCreateDto(
                patientId = patientId.id,
                ausgestelltAm = ausgestelltAm,
                positionen = emptyList(),
            )

            // Setup mock behavior
            every { patientenRepository.findById(patientId) } returns patient

            // Act & Assert
            assertFailsWith<IllegalArgumentException> {
                rezeptService.createRezept(createDto)
            }

            // Verify interactions with repositories
            verify { patientenRepository.findById(patientId) }
            verify(exactly = 0) { behandlungsartenRepository.findAllByIdIn(any()) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }

        @Test
        fun `should throw exception when patient not found`() {
            // Arrange
            val nonExistentPatientId = PatientId.Companion.generate()
            val createDto = RezeptCreateDto(
                patientId = nonExistentPatientId.id,
                ausgestelltAm = ausgestelltAm,
                positionen = emptyList(),
            )

            // Setup mock behavior
            every { patientenRepository.findById(nonExistentPatientId) } returns null

            // Act & Assert
            assertFailsWith<IllegalArgumentException> {
                rezeptService.createRezept(createDto)
            }

            // Verify interactions with repositories
            verify { patientenRepository.findById(nonExistentPatientId) }
            verify(exactly = 0) { behandlungsartenRepository.findAllByIdIn(any()) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }

        @Test
        fun `should throw exception when behandlungsart not found`() {
            // Arrange
            val nonExistentBehandlungsartId = BehandlungsartId.Companion.generate()
            val posCreateDto = RezeptPosCreateDto(
                behandlungsartId = nonExistentBehandlungsartId.id,
                anzahl = 5,
            )

            val createDto = RezeptCreateDto(
                patientId = patientId.id,
                ausgestelltAm = ausgestelltAm,
                positionen = listOf(posCreateDto),
            )

            // Setup mock behavior
            every { patientenRepository.findById(patientId) } returns patient
            every { behandlungsartenRepository.findAllByIdIn(setOf(nonExistentBehandlungsartId)) } returns emptyList()

            // Act & Assert
            assertFailsWith<IllegalArgumentException> {
                rezeptService.createRezept(createDto)
            }

            // Verify interactions with repositories
            verify { patientenRepository.findById(patientId) }
            verify { behandlungsartenRepository.findAllByIdIn(setOf(nonExistentBehandlungsartId)) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }
    }

    @Nested
    inner class BehandlungManagement {
        @Test
        fun `should add behandlung to rezept successfully`() {
            // Arrange
            val rezeptId = RezeptId.Companion.generate()
            val startZeit = LocalDateTime.of(2023, 5, 15, 10, 0)
            val endZeit = LocalDateTime.of(2023, 5, 15, 11, 0)

            val originalRezept = Rezept(
                id = rezeptId,
                patientId = patientId,
                ausgestelltAm = ausgestelltAm,
                ausgestelltVonArztId = null,
                preisGesamt = 752.0,
                rechnungsnummer = null,
                positionen = listOf(
                    RezeptPos(
                        id = UUID.randomUUID(),
                        behandlungsartId = behandlungsartId1,
                        anzahl = 10,
                        einzelpreis = 75.2,
                        preisGesamt = 752.0,
                        behandlungsartName = "Manuelle Therapie",
                    ),
                ),
                behandlungen = emptyList(),
                version = 1,
            )

            // Setup mock behavior
            every { rezeptRepository.findById(rezeptId) } returns originalRezept

            val updatedRezeptSlot = slot<Rezept>()
            every { rezeptRepository.save(capture(updatedRezeptSlot)) } answers { updatedRezeptSlot.captured }

            // Act
            val result = rezeptService.addBehandlung(rezeptId, startZeit, endZeit)

            // Assert
            assertNotNull(result)
            assertEquals(1, result.behandlungen.size)
            assertEquals(startZeit, result.behandlungen[0].startZeit)
            assertEquals(endZeit, result.behandlungen[0].endZeit)
            assertEquals(rezeptId, result.behandlungen[0].rezeptId)

            // Verify interactions with repositories
            verify { rezeptRepository.findById(rezeptId) }
            verify { rezeptRepository.save(any()) }
        }

        @Test
        fun `should throw exception when rezept not found for adding behandlung`() {
            // Arrange
            val nonExistentRezeptId = RezeptId.Companion.generate()
            val startZeit = LocalDateTime.of(2023, 5, 15, 10, 0)
            val endZeit = LocalDateTime.of(2023, 5, 15, 11, 0)

            // Setup mock behavior
            every { rezeptRepository.findById(nonExistentRezeptId) } returns null

            // Act & Assert
            assertFailsWith<AggregateNotFoundException> {
                rezeptService.addBehandlung(nonExistentRezeptId, startZeit, endZeit)
            }

            // Verify interactions with repositories
            verify { rezeptRepository.findById(nonExistentRezeptId) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }

        @Test
        fun `should throw exception when rezept not found for removing behandlung`() {
            // Arrange
            val nonExistentRezeptId = RezeptId.Companion.generate()
            val behandlungId = UUID.randomUUID()

            // Setup mock behavior
            every { rezeptRepository.findById(nonExistentRezeptId) } returns null

            // Act & Assert
            assertFailsWith<AggregateNotFoundException> {
                rezeptService.removeBehandlung(nonExistentRezeptId, behandlungId)
            }

            // Verify interactions with repositories
            verify { rezeptRepository.findById(nonExistentRezeptId) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }

        @Test
        fun `should throw exception when behandlung not found for removal`() {
            // Arrange
            val rezeptId = RezeptId.Companion.generate()
            val existingBehandlungId = UUID.randomUUID()
            val nonExistentBehandlungId = UUID.randomUUID()

            val behandlung = Behandlung(
                id = existingBehandlungId,
                rezeptId = rezeptId,
                startZeit = LocalDateTime.of(2023, 5, 15, 10, 0),
                endZeit = LocalDateTime.of(2023, 5, 15, 11, 0),
                version = 0,
            )

            val originalRezept = Rezept(
                id = rezeptId,
                patientId = patientId,
                ausgestelltAm = ausgestelltAm,
                ausgestelltVonArztId = null,
                preisGesamt = 752.0,
                rechnungsnummer = null,
                positionen = listOf(
                    RezeptPos(
                        id = UUID.randomUUID(),
                        behandlungsartId = behandlungsartId1,
                        anzahl = 10,
                        einzelpreis = 75.2,
                        preisGesamt = 752.0,
                        behandlungsartName = "Manuelle Therapie",
                    ),
                ),
                behandlungen = listOf(behandlung),
                version = 1,
            )

            // Setup mock behavior
            every { rezeptRepository.findById(rezeptId) } returns originalRezept

            // Act & Assert
            assertFailsWith<AggregateNotFoundException> {
                rezeptService.removeBehandlung(rezeptId, nonExistentBehandlungId)
            }

            // Verify interactions with repositories
            verify { rezeptRepository.findById(rezeptId) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }
    }

    @Nested
    inner class UpdateRezept {
        @Test
        fun `should update an existing rezept successfully`() {
            // Arrange
            val rezeptId = RezeptId.Companion.generate()

            val originalPos1 = RezeptPos(
                id = UUID.randomUUID(),
                behandlungsartId = behandlungsartId1,
                anzahl = 10,
                einzelpreis = 75.2,
                preisGesamt = 752.0,
                behandlungsartName = "Manuelle Therapie",
            )

            val originalRezept = Rezept(
                id = rezeptId,
                patientId = patientId,
                ausgestelltAm = ausgestelltAm,
                ausgestelltVonArztId = null,
                preisGesamt = 752.0,
                rechnungsnummer = null,
                positionen = listOf(originalPos1),
                version = 1,
            )

            // New data for update
            val newAusgestelltAm = LocalDate.of(2024, 1, 1)
            val updatedPositionDto = RezeptPosCreateDto(
                behandlungsartId = behandlungsartId2.id,
                anzahl = 5,
            )

            val updateDto = RezeptUpdateDto(
                patientId = patientId.id,
                ausgestelltAm = newAusgestelltAm,
                positionen = listOf(updatedPositionDto),
            )

            // Setup mock behavior
            every { rezeptRepository.findById(rezeptId) } returns originalRezept
            every { patientenRepository.findById(patientId) } returns patient
            every {
                behandlungsartenRepository.findAllByIdIn(setOf(behandlungsartId2))
            } returns listOf(behandlungsart2)

            val savedRezeptSlot = slot<Rezept>()
            every { rezeptRepository.save(capture(savedRezeptSlot)) } answers { savedRezeptSlot.captured }

            // Act
            val result = rezeptService.updateRezept(rezeptId, updateDto)

            // Assert
            assertNotNull(result)
            assertEquals(patientId, result.patientId)
            assertEquals(newAusgestelltAm, result.ausgestelltAm)
            assertEquals(1, result.positionen.size)

            // Verify expected preisGesamt calculation for updated positions
            val expectedPreisGesamt = 5 * 22.84
            assertEquals(expectedPreisGesamt, result.preisGesamt)

            // Verify interactions with repositories
            verify { rezeptRepository.findById(rezeptId) }
            verify { patientenRepository.findById(patientId) }
            verify { behandlungsartenRepository.findAllByIdIn(setOf(behandlungsartId2)) }
            verify { rezeptRepository.save(any()) }
        }

        @Test
        fun `should update with multiple positions successfully`() {
            // Arrange
            val rezeptId = RezeptId.Companion.generate()

            val originalPos1 = RezeptPos(
                id = UUID.randomUUID(),
                behandlungsartId = behandlungsartId1,
                anzahl = 10,
                einzelpreis = 75.2,
                preisGesamt = 752.0,
                behandlungsartName = "Manuelle Therapie",
            )

            val originalRezept = Rezept(
                id = rezeptId,
                patientId = patientId,
                ausgestelltAm = ausgestelltAm,
                ausgestelltVonArztId = null,
                preisGesamt = 752.0,
                rechnungsnummer = null,
                positionen = listOf(originalPos1),
                version = 1,
            )

            // New data for update with multiple positions
            val newAusgestelltAm = LocalDate.of(2024, 1, 1)
            val updatedPositionDto1 = RezeptPosCreateDto(
                behandlungsartId = behandlungsartId1.id,
                anzahl = 8,
            )

            val updatedPositionDto2 = RezeptPosCreateDto(
                behandlungsartId = behandlungsartId2.id,
                anzahl = 4,
            )

            val updateDto = RezeptUpdateDto(
                patientId = patientId.id,
                ausgestelltAm = newAusgestelltAm,
                positionen = listOf(updatedPositionDto1, updatedPositionDto2),
            )

            // Setup mock behavior
            every { rezeptRepository.findById(rezeptId) } returns originalRezept
            every { patientenRepository.findById(patientId) } returns patient
            every {
                behandlungsartenRepository.findAllByIdIn(setOf(behandlungsartId1, behandlungsartId2))
            } returns listOf(behandlungsart1, behandlungsart2)

            val savedRezeptSlot = slot<Rezept>()
            every { rezeptRepository.save(capture(savedRezeptSlot)) } answers { savedRezeptSlot.captured }

            // Act
            val result = rezeptService.updateRezept(rezeptId, updateDto)

            // Assert
            assertNotNull(result)
            assertEquals(patientId, result.patientId)
            assertEquals(newAusgestelltAm, result.ausgestelltAm)
            assertEquals(2, result.positionen.size)

            // Verify expected preisGesamt calculation for updated positions
            val expectedPreisGesamt = (8 * 75.2) + (4 * 22.84)
            assertEquals(expectedPreisGesamt, result.preisGesamt)

            // Verify interactions with repositories
            verify { rezeptRepository.findById(rezeptId) }
            verify { patientenRepository.findById(patientId) }
            verify { behandlungsartenRepository.findAllByIdIn(setOf(behandlungsartId1, behandlungsartId2)) }
            verify { rezeptRepository.save(any()) }
        }

        @Test
        fun `should throw exception when rezept not found`() {
            // Arrange
            val nonExistentRezeptId = RezeptId.Companion.generate()
            val updateDto = RezeptUpdateDto(
                patientId = patientId.id,
                ausgestelltAm = LocalDate.of(2024, 1, 1),
                positionen = emptyList(),
            )

            // Setup mock behavior
            every { rezeptRepository.findById(nonExistentRezeptId) } returns null

            // Act & Assert
            assertFailsWith<AggregateNotFoundException> {
                rezeptService.updateRezept(nonExistentRezeptId, updateDto)
            }

            // Verify interactions with repositories
            verify { rezeptRepository.findById(nonExistentRezeptId) }
            verify(exactly = 0) { patientenRepository.findById(any()) }
            verify(exactly = 0) { behandlungsartenRepository.findAllByIdIn(any()) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }

        @Test
        fun `should throw exception when patient not found`() {
            // Arrange
            val rezeptId = RezeptId.Companion.generate()
            val nonExistentPatientId = PatientId.Companion.generate()

            val originalRezept = Rezept(
                id = rezeptId,
                patientId = patientId,
                ausgestelltAm = ausgestelltAm,
                ausgestelltVonArztId = null,
                preisGesamt = 0.0,
                rechnungsnummer = null,
                positionen = emptyList(),
                version = 1,
            )

            val posUpdateDto = RezeptPosCreateDto(
                behandlungsartId = behandlungsartId1.id,
                anzahl = 1,
            )

            val updateDto = RezeptUpdateDto(
                patientId = nonExistentPatientId.id,
                ausgestelltAm = LocalDate.of(2024, 1, 1),
                positionen = listOf(posUpdateDto),
            )

            // Setup mock behavior
            every { rezeptRepository.findById(rezeptId) } returns originalRezept
            every { patientenRepository.findById(nonExistentPatientId) } returns null

            // Act & Assert
            assertFailsWith<AggregateNotFoundException> {
                rezeptService.updateRezept(rezeptId, updateDto)
            }

            // Verify interactions with repositories
            verify { rezeptRepository.findById(rezeptId) }
            verify { patientenRepository.findById(nonExistentPatientId) }
            verify(exactly = 0) { behandlungsartenRepository.findAllByIdIn(any()) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }

        @Test
        fun `should throw exception when no positions provided`() {
            // Arrange
            val rezeptId = RezeptId.Companion.generate()

            val originalPos1 = RezeptPos(
                id = UUID.randomUUID(),
                behandlungsartId = behandlungsartId1,
                anzahl = 10,
                einzelpreis = 75.2,
                preisGesamt = 752.0,
                behandlungsartName = "Manuelle Therapie",
            )

            val originalRezept = Rezept(
                id = rezeptId,
                patientId = patientId,
                ausgestelltAm = ausgestelltAm,
                ausgestelltVonArztId = null,
                preisGesamt = 752.0,
                rechnungsnummer = null,
                positionen = listOf(originalPos1),
                version = 1,
            )

            val updateDto = RezeptUpdateDto(
                patientId = patientId.id,
                ausgestelltAm = LocalDate.of(2024, 1, 1),
                positionen = emptyList(),
            )

            // Setup mock behavior
            every { rezeptRepository.findById(rezeptId) } returns originalRezept
            every { patientenRepository.findById(patientId) } returns patient
            every { behandlungsartenRepository.findAllByIdIn(any()) } returns emptyList()

            // Act & Assert
            assertFailsWith<IllegalArgumentException> {
                rezeptService.updateRezept(rezeptId, updateDto)
            }

            // Verify interactions with repositories
            verify { rezeptRepository.findById(rezeptId) }
            verify { patientenRepository.findById(patientId) }
            verify { behandlungsartenRepository.findAllByIdIn(any()) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }

        @Test
        fun `should throw exception when behandlungsart not found`() {
            // Arrange
            val rezeptId = RezeptId.Companion.generate()
            val nonExistentBehandlungsartId = BehandlungsartId.Companion.generate()

            val originalRezept = Rezept(
                id = rezeptId,
                patientId = patientId,
                ausgestelltAm = ausgestelltAm,
                ausgestelltVonArztId = null,
                preisGesamt = 0.0,
                rechnungsnummer = null,
                positionen = emptyList(),
                version = 1,
            )

            val posUpdateDto = RezeptPosCreateDto(
                behandlungsartId = nonExistentBehandlungsartId.id,
                anzahl = 5,
            )

            val updateDto = RezeptUpdateDto(
                patientId = patientId.id,
                ausgestelltAm = LocalDate.of(2024, 1, 1),
                positionen = listOf(posUpdateDto),
            )

            // Setup mock behavior
            every { rezeptRepository.findById(rezeptId) } returns originalRezept
            every { patientenRepository.findById(patientId) } returns patient
            every { behandlungsartenRepository.findAllByIdIn(setOf(nonExistentBehandlungsartId)) } returns emptyList()

            // Act & Assert
            assertFailsWith<AggregateNotFoundException> {
                rezeptService.updateRezept(rezeptId, updateDto)
            }

            // Verify interactions with repositories
            verify { rezeptRepository.findById(rezeptId) }
            verify { patientenRepository.findById(patientId) }
            verify { behandlungsartenRepository.findAllByIdIn(setOf(nonExistentBehandlungsartId)) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }
    }
}
