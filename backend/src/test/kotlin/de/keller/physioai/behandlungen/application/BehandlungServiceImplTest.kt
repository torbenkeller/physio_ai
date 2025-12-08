package de.keller.physioai.behandlungen.application

import de.keller.physioai.behandlungen.domain.BehandlungAggregate
import de.keller.physioai.behandlungen.ports.BehandlungenRepository
import de.keller.physioai.behandlungen.ports.BehandlungenService
import de.keller.physioai.patienten.PatientenRepository
import de.keller.physioai.shared.AggregateNotFoundException
import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.RezeptId
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
import java.time.LocalDateTime
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertNotNull
import kotlin.test.assertNull

@ExtendWith(MockKExtension::class)
class BehandlungServiceImplTest {
    @MockK
    private lateinit var behandlungenRepository: BehandlungenRepository

    @MockK
    private lateinit var patientenRepository: PatientenRepository

    private lateinit var behandlungenService: BehandlungenService

    @BeforeEach
    fun setUp() {
        clearAllMocks()
        behandlungenService = BehandlungenServiceImpl(behandlungenRepository, patientenRepository)
    }

    @Nested
    inner class CreateBehandlung {
        @Test
        fun `should create behandlung successfully with rezeptId`() {
            // Arrange
            val patientId = PatientId(UUID.randomUUID())
            val rezeptId = RezeptId(UUID.randomUUID())
            val startZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
            val endZeit = LocalDateTime.of(2024, 1, 15, 11, 0)

            val savedBehandlungSlot = slot<BehandlungAggregate>()
            every { behandlungenRepository.save(capture(savedBehandlungSlot)) } answers { savedBehandlungSlot.captured }

            // Act
            val result = behandlungenService.createBehandlung(
                patientId = patientId,
                startZeit = startZeit,
                endZeit = endZeit,
                rezeptId = rezeptId,
                behandlungsartId = null,
            )

            // Assert
            assertNotNull(result)
            assertEquals(patientId, result.patientId)
            assertEquals(startZeit, result.startZeit)
            assertEquals(endZeit, result.endZeit)
            assertEquals(rezeptId, result.rezeptId)
            verify { behandlungenRepository.save(any()) }
        }

        @Test
        fun `should create behandlung successfully without rezeptId`() {
            // Arrange
            val patientId = PatientId(UUID.randomUUID())
            val startZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
            val endZeit = LocalDateTime.of(2024, 1, 15, 11, 0)

            val savedBehandlungSlot = slot<BehandlungAggregate>()
            every { behandlungenRepository.save(capture(savedBehandlungSlot)) } answers { savedBehandlungSlot.captured }

            // Act
            val result = behandlungenService.createBehandlung(
                patientId = patientId,
                startZeit = startZeit,
                endZeit = endZeit,
                rezeptId = null,
                behandlungsartId = null,
            )

            // Assert
            assertNotNull(result)
            assertEquals(patientId, result.patientId)
            assertEquals(startZeit, result.startZeit)
            assertEquals(endZeit, result.endZeit)
            assertNull(result.rezeptId)
            verify { behandlungenRepository.save(any()) }
        }
    }

    @Nested
    inner class UpdateBehandlung {
        @Test
        fun `should update behandlung successfully`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.randomUUID())
            val patientId = PatientId(UUID.randomUUID())
            val originalStartZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
            val originalEndZeit = LocalDateTime.of(2024, 1, 15, 11, 0)
            val newStartZeit = LocalDateTime.of(2024, 1, 15, 14, 0)
            val newEndZeit = LocalDateTime.of(2024, 1, 15, 15, 0)
            val newRezeptId = RezeptId(UUID.randomUUID())

            val existingBehandlung = BehandlungAggregate(
                id = behandlungId,
                patientId = patientId,
                startZeit = originalStartZeit,
                endZeit = originalEndZeit,
                rezeptId = null,
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            every { behandlungenRepository.findById(behandlungId) } returns existingBehandlung

            val savedBehandlungSlot = slot<BehandlungAggregate>()
            every { behandlungenRepository.save(capture(savedBehandlungSlot)) } answers { savedBehandlungSlot.captured }

            // Act
            val result = behandlungenService.updateBehandlung(
                id = behandlungId,
                startZeit = newStartZeit,
                endZeit = newEndZeit,
                rezeptId = newRezeptId,
                behandlungsartId = null,
                bemerkung = null,
            )

            // Assert
            assertNotNull(result)
            assertEquals(behandlungId, result.id)
            assertEquals(patientId, result.patientId)
            assertEquals(newStartZeit, result.startZeit)
            assertEquals(newEndZeit, result.endZeit)
            assertEquals(newRezeptId, result.rezeptId)

            verify { behandlungenRepository.findById(behandlungId) }
            verify { behandlungenRepository.save(any()) }
        }

        @Test
        fun `should throw AggregateNotFoundException when behandlung does not exist`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.randomUUID())
            val startZeit = LocalDateTime.of(2024, 1, 15, 14, 0)
            val endZeit = LocalDateTime.of(2024, 1, 15, 15, 0)

            every { behandlungenRepository.findById(behandlungId) } returns null

            // Act & Assert
            assertFailsWith<AggregateNotFoundException> {
                behandlungenService.updateBehandlung(
                    id = behandlungId,
                    startZeit = startZeit,
                    endZeit = endZeit,
                    rezeptId = null,
                    behandlungsartId = null,
                    bemerkung = null,
                )
            }

            verify { behandlungenRepository.findById(behandlungId) }
            verify(exactly = 0) { behandlungenRepository.save(any()) }
        }

        @Test
        fun `should update behandlung and remove rezeptId when set to null`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.randomUUID())
            val patientId = PatientId(UUID.randomUUID())
            val startZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
            val endZeit = LocalDateTime.of(2024, 1, 15, 11, 0)
            val newStartZeit = LocalDateTime.of(2024, 1, 15, 14, 0)
            val newEndZeit = LocalDateTime.of(2024, 1, 15, 15, 0)

            val existingBehandlung = BehandlungAggregate(
                id = behandlungId,
                patientId = patientId,
                startZeit = startZeit,
                endZeit = endZeit,
                rezeptId = RezeptId(UUID.randomUUID()),
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            every { behandlungenRepository.findById(behandlungId) } returns existingBehandlung

            val savedBehandlungSlot = slot<BehandlungAggregate>()
            every { behandlungenRepository.save(capture(savedBehandlungSlot)) } answers { savedBehandlungSlot.captured }

            // Act
            val result = behandlungenService.updateBehandlung(
                id = behandlungId,
                startZeit = newStartZeit,
                endZeit = newEndZeit,
                rezeptId = null,
                behandlungsartId = null,
                bemerkung = null,
            )

            // Assert
            assertNotNull(result)
            assertEquals(behandlungId, result.id)
            assertEquals(patientId, result.patientId)
            assertEquals(newStartZeit, result.startZeit)
            assertEquals(newEndZeit, result.endZeit)
            assertNull(result.rezeptId)

            verify { behandlungenRepository.findById(behandlungId) }
            verify { behandlungenRepository.save(any()) }
        }
    }

    @Nested
    inner class VerschiebeBehandlung {
        @Test
        fun `should move behandlung to new time successfully`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.randomUUID())
            val patientId = PatientId(UUID.randomUUID())
            val originalStartZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
            val originalEndZeit = LocalDateTime.of(2024, 1, 15, 11, 0)
            val neueStartZeit = LocalDateTime.of(2024, 1, 15, 14, 0)

            val existingBehandlung = BehandlungAggregate(
                id = behandlungId,
                patientId = patientId,
                startZeit = originalStartZeit,
                endZeit = originalEndZeit,
                rezeptId = null,
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            every { behandlungenRepository.findById(behandlungId) } returns existingBehandlung

            val savedBehandlungSlot = slot<BehandlungAggregate>()
            every { behandlungenRepository.save(capture(savedBehandlungSlot)) } answers { savedBehandlungSlot.captured }

            // Act
            val result = behandlungenService.verschiebeBehandlung(behandlungId, neueStartZeit)

            // Assert - verify the returned behandlung has correct new times
            assertNotNull(result)
            assertEquals(behandlungId, result.id)
            assertEquals(patientId, result.patientId)
            assertEquals(neueStartZeit, result.startZeit)
            assertEquals(LocalDateTime.of(2024, 1, 15, 15, 0), result.endZeit) // same duration

            verify { behandlungenRepository.findById(behandlungId) }
            verify { behandlungenRepository.save(any()) }
        }

        @Test
        fun `should throw AggregateNotFoundException when behandlung does not exist`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.randomUUID())
            val neueStartZeit = LocalDateTime.of(2024, 1, 15, 14, 0)

            every { behandlungenRepository.findById(behandlungId) } returns null

            // Act & Assert
            assertFailsWith<AggregateNotFoundException> {
                behandlungenService.verschiebeBehandlung(behandlungId, neueStartZeit)
            }

            verify { behandlungenRepository.findById(behandlungId) }
            verify(exactly = 0) { behandlungenRepository.save(any()) }
        }
    }

    @Nested
    inner class DeleteBehandlung {
        @Test
        fun `should delete behandlung successfully`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.randomUUID())
            val behandlung = BehandlungAggregate(
                id = behandlungId,
                patientId = PatientId(UUID.randomUUID()),
                startZeit = LocalDateTime.of(2024, 1, 15, 10, 0),
                endZeit = LocalDateTime.of(2024, 1, 15, 11, 0),
                rezeptId = null,
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            every { behandlungenRepository.findById(behandlungId) } returns behandlung
            every { behandlungenRepository.delete(behandlung) } returns Unit

            // Act
            behandlungenService.deleteBehandlung(behandlungId)

            // Assert
            verify { behandlungenRepository.findById(behandlungId) }
            verify { behandlungenRepository.delete(behandlung) }
        }

        @Test
        fun `should throw AggregateNotFoundException when behandlung does not exist`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.randomUUID())

            every { behandlungenRepository.findById(behandlungId) } returns null

            // Act & Assert
            assertFailsWith<AggregateNotFoundException> {
                behandlungenService.deleteBehandlung(behandlungId)
            }

            verify { behandlungenRepository.findById(behandlungId) }
            verify(exactly = 0) { behandlungenRepository.delete(any()) }
        }
    }

    @Nested
    inner class CheckConflicts {
        private fun createTestPatient(
            id: PatientId,
            vorname: String,
            nachname: String,
        ) = de.keller.physioai.behandlungen.TestPatient(
            id = id,
            titel = null,
            vorname = vorname,
            nachname = nachname,
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

        @Test
        fun `should return no conflicts when no overlapping behandlungen exist`() {
            // Arrange
            val slot = BehandlungenService.TimeSlotCheck(
                startZeit = LocalDateTime.of(2024, 1, 15, 10, 0),
                endZeit = LocalDateTime.of(2024, 1, 15, 11, 30),
            )

            every {
                behandlungenRepository.findOverlapping(slot.startZeit, slot.endZeit)
            } returns emptyList()

            // Act
            val results = behandlungenService.checkConflicts(listOf(slot))

            // Assert
            assertEquals(1, results.size)
            assertEquals(0, results[0].slotIndex)
            assertEquals(false, results[0].hasConflict)
            assertEquals(0, results[0].conflictingBehandlungen.size)

            verify { behandlungenRepository.findOverlapping(slot.startZeit, slot.endZeit) }
        }

        @Test
        fun `should return conflict when overlapping behandlung exists`() {
            // Arrange
            val slot = BehandlungenService.TimeSlotCheck(
                startZeit = LocalDateTime.of(2024, 1, 15, 10, 0),
                endZeit = LocalDateTime.of(2024, 1, 15, 11, 30),
            )

            val conflictingPatientId = PatientId(UUID.randomUUID())
            val conflictingBehandlung = BehandlungAggregate(
                id = BehandlungId(UUID.randomUUID()),
                patientId = conflictingPatientId,
                startZeit = LocalDateTime.of(2024, 1, 15, 10, 30),
                endZeit = LocalDateTime.of(2024, 1, 15, 12, 0),
                rezeptId = null,
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            every {
                behandlungenRepository.findOverlapping(slot.startZeit, slot.endZeit)
            } returns listOf(conflictingBehandlung)

            every {
                patientenRepository.findAllByIdIn(setOf(conflictingPatientId))
            } returns listOf(createTestPatient(conflictingPatientId, "Max", "Mustermann"))

            // Act
            val results = behandlungenService.checkConflicts(listOf(slot))

            // Assert
            assertEquals(1, results.size)
            assertEquals(0, results[0].slotIndex)
            assertEquals(true, results[0].hasConflict)
            assertEquals(1, results[0].conflictingBehandlungen.size)
            assertEquals("Max Mustermann", results[0].conflictingBehandlungen[0].patientName)

            verify { behandlungenRepository.findOverlapping(slot.startZeit, slot.endZeit) }
            verify { patientenRepository.findAllByIdIn(setOf(conflictingPatientId)) }
        }

        @Test
        fun `should check multiple slots and return correct conflicts for each`() {
            // Arrange
            val slot1 = BehandlungenService.TimeSlotCheck(
                startZeit = LocalDateTime.of(2024, 1, 15, 10, 0),
                endZeit = LocalDateTime.of(2024, 1, 15, 11, 30),
            )
            val slot2 = BehandlungenService.TimeSlotCheck(
                startZeit = LocalDateTime.of(2024, 1, 16, 14, 0),
                endZeit = LocalDateTime.of(2024, 1, 16, 15, 30),
            )

            val conflictingPatientId = PatientId(UUID.randomUUID())
            val conflictingBehandlung = BehandlungAggregate(
                id = BehandlungId(UUID.randomUUID()),
                patientId = conflictingPatientId,
                startZeit = LocalDateTime.of(2024, 1, 15, 10, 30),
                endZeit = LocalDateTime.of(2024, 1, 15, 12, 0),
                rezeptId = null,
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            // Slot 1 has conflict, slot 2 does not
            every {
                behandlungenRepository.findOverlapping(slot1.startZeit, slot1.endZeit)
            } returns listOf(conflictingBehandlung)

            every {
                behandlungenRepository.findOverlapping(slot2.startZeit, slot2.endZeit)
            } returns emptyList()

            every {
                patientenRepository.findAllByIdIn(setOf(conflictingPatientId))
            } returns listOf(createTestPatient(conflictingPatientId, "Anna", "Schmidt"))

            // Act
            val results = behandlungenService.checkConflicts(listOf(slot1, slot2))

            // Assert
            assertEquals(2, results.size)

            assertEquals(0, results[0].slotIndex)
            assertEquals(true, results[0].hasConflict)
            assertEquals(1, results[0].conflictingBehandlungen.size)

            assertEquals(1, results[1].slotIndex)
            assertEquals(false, results[1].hasConflict)
            assertEquals(0, results[1].conflictingBehandlungen.size)
        }
    }
}
