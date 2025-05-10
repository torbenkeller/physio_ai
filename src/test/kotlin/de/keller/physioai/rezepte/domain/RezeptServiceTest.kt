package de.keller.physioai.rezepte.domain

import de.keller.physioai.patienten.Patient
import de.keller.physioai.patienten.PatientId
import de.keller.physioai.patienten.PatientenRepository
import de.keller.physioai.rezepte.web.RezeptCreateDto
import de.keller.physioai.rezepte.web.RezeptPosCreateDto
import de.keller.physioai.rezepte.web.RezeptUpdateDto
import io.mockk.clearAllMocks
import io.mockk.every
import io.mockk.impl.annotations.MockK
import io.mockk.junit5.MockKExtension
import io.mockk.slot
import io.mockk.verify
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import java.time.LocalDate
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertNotNull

@ExtendWith(MockKExtension::class)
class RezeptServiceTest {
    @MockK
    private lateinit var rezeptRepository: RezeptRepository

    @MockK
    private lateinit var behandlungsartenRepository: BehandlungsartenRepository

    @MockK
    private lateinit var patientenRepository: PatientenRepository

    private lateinit var rezeptService: RezeptService

    private val patientId = PatientId.generate()
    private val behandlungsartId1 = BehandlungsartId.generate()
    private val behandlungsartId2 = BehandlungsartId.generate()
    private val ausgestelltAm = LocalDate.of(2023, 1, 1)

    private lateinit var patient: Patient
    private lateinit var behandlungsart1: Behandlungsart
    private lateinit var behandlungsart2: Behandlungsart

    @BeforeEach
    fun setUp() {
        clearAllMocks()

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

        rezeptService = RezeptService(
            rezeptRepository,
            behandlungsartenRepository,
            patientenRepository,
        )
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
                behandlungsartenRepository.findAllById(setOf(behandlungsartId1, behandlungsartId2))
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
            verify { behandlungsartenRepository.findAllById(setOf(behandlungsartId1, behandlungsartId2)) }
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
            verify(exactly = 0) { behandlungsartenRepository.findAllById(any()) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }

        @Test
        fun `should throw exception when patient not found`() {
            // Arrange
            val nonExistentPatientId = PatientId.generate()
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
            verify(exactly = 0) { behandlungsartenRepository.findAllById(any()) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }

        @Test
        fun `should throw exception when behandlungsart not found`() {
            // Arrange
            val nonExistentBehandlungsartId = BehandlungsartId.generate()
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
            every { behandlungsartenRepository.findAllById(setOf(nonExistentBehandlungsartId)) } returns emptyList()

            // Act & Assert
            assertFailsWith<IllegalArgumentException> {
                rezeptService.createRezept(createDto)
            }

            // Verify interactions with repositories
            verify { patientenRepository.findById(patientId) }
            verify { behandlungsartenRepository.findAllById(setOf(nonExistentBehandlungsartId)) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }
    }

    @Nested
    inner class UpdateRezept {
        @Test
        fun `should update an existing rezept successfully`() {
            // Arrange
            val rezeptId = RezeptId.generate()

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
                behandlungsartenRepository.findAllById(setOf(behandlungsartId2))
            } returns listOf(behandlungsart2)

            val savedRezeptSlot = slot<Rezept>()
            every { rezeptRepository.save(capture(savedRezeptSlot)) } answers { savedRezeptSlot.captured }

            // Act
            val result = rezeptService.updateRezept(rezeptId.id, updateDto)

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
            verify { behandlungsartenRepository.findAllById(setOf(behandlungsartId2)) }
            verify { rezeptRepository.save(any()) }
        }

        @Test
        fun `should update with multiple positions successfully`() {
            // Arrange
            val rezeptId = RezeptId.generate()

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
                behandlungsartenRepository.findAllById(setOf(behandlungsartId1, behandlungsartId2))
            } returns listOf(behandlungsart1, behandlungsart2)

            val savedRezeptSlot = slot<Rezept>()
            every { rezeptRepository.save(capture(savedRezeptSlot)) } answers { savedRezeptSlot.captured }

            // Act
            val result = rezeptService.updateRezept(rezeptId.id, updateDto)

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
            verify { behandlungsartenRepository.findAllById(setOf(behandlungsartId1, behandlungsartId2)) }
            verify { rezeptRepository.save(any()) }
        }

        @Test
        fun `should throw exception when rezept not found`() {
            // Arrange
            val nonExistentRezeptId = RezeptId.generate()
            val updateDto = RezeptUpdateDto(
                patientId = patientId.id,
                ausgestelltAm = LocalDate.of(2024, 1, 1),
                positionen = emptyList(),
            )

            // Setup mock behavior
            every { rezeptRepository.findById(nonExistentRezeptId) } returns null

            // Act & Assert
            assertFailsWith<IllegalArgumentException> {
                rezeptService.updateRezept(nonExistentRezeptId.id, updateDto)
            }

            // Verify interactions with repositories
            verify { rezeptRepository.findById(nonExistentRezeptId) }
            verify(exactly = 0) { patientenRepository.findById(any()) }
            verify(exactly = 0) { behandlungsartenRepository.findAllById(any()) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }

        @Test
        fun `should throw exception when patient not found`() {
            // Arrange
            val rezeptId = RezeptId.generate()
            val nonExistentPatientId = PatientId.generate()

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
            assertFailsWith<IllegalArgumentException> {
                rezeptService.updateRezept(rezeptId.id, updateDto)
            }

            // Verify interactions with repositories
            verify { rezeptRepository.findById(rezeptId) }
            verify { patientenRepository.findById(nonExistentPatientId) }
            verify(exactly = 0) { behandlungsartenRepository.findAllById(any()) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }

        @Test
        fun `should throw exception when no positions provided`() {
            // Arrange
            val rezeptId = RezeptId.generate()

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

            // Act & Assert
            assertFailsWith<IllegalArgumentException> {
                rezeptService.updateRezept(rezeptId.id, updateDto)
            }

            // Verify interactions with repositories
            verify { rezeptRepository.findById(rezeptId) }
            verify { patientenRepository.findById(patientId) }
            verify(exactly = 0) { behandlungsartenRepository.findAllById(any()) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }

        @Test
        fun `should throw exception when behandlungsart not found`() {
            // Arrange
            val rezeptId = RezeptId.generate()
            val nonExistentBehandlungsartId = BehandlungsartId.generate()

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
            every { behandlungsartenRepository.findAllById(setOf(nonExistentBehandlungsartId)) } returns emptyList()

            // Act & Assert
            assertFailsWith<IllegalArgumentException> {
                rezeptService.updateRezept(rezeptId.id, updateDto)
            }

            // Verify interactions with repositories
            verify { rezeptRepository.findById(rezeptId) }
            verify { patientenRepository.findById(patientId) }
            verify { behandlungsartenRepository.findAllById(setOf(nonExistentBehandlungsartId)) }
            verify(exactly = 0) { rezeptRepository.save(any()) }
        }
    }
}
