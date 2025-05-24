package de.keller.physioai.behandlungen.application

import de.keller.physioai.behandlungen.domain.BehandlungAggregate
import de.keller.physioai.behandlungen.ports.BehandlungRepository
import de.keller.physioai.behandlungen.ports.BehandlungService
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
    private lateinit var behandlungRepository: BehandlungRepository

    private lateinit var behandlungService: BehandlungService

    @BeforeEach
    fun setUp() {
        clearAllMocks()
        behandlungService = BehandlungServiceImpl(behandlungRepository)
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
            every { behandlungRepository.save(capture(savedBehandlungSlot)) } answers { savedBehandlungSlot.captured }

            // Act
            val result = behandlungService.createBehandlung(
                patientId = patientId,
                startZeit = startZeit,
                endZeit = endZeit,
                rezeptId = rezeptId,
            )

            // Assert
            assertNotNull(result)
            assertEquals(patientId, result.patientId)
            assertEquals(startZeit, result.startZeit)
            assertEquals(endZeit, result.endZeit)
            assertEquals(rezeptId, result.rezeptId)
            verify { behandlungRepository.save(any()) }
        }

        @Test
        fun `should create behandlung successfully without rezeptId`() {
            // Arrange
            val patientId = PatientId(UUID.randomUUID())
            val startZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
            val endZeit = LocalDateTime.of(2024, 1, 15, 11, 0)

            val savedBehandlungSlot = slot<BehandlungAggregate>()
            every { behandlungRepository.save(capture(savedBehandlungSlot)) } answers { savedBehandlungSlot.captured }

            // Act
            val result = behandlungService.createBehandlung(
                patientId = patientId,
                startZeit = startZeit,
                endZeit = endZeit,
                rezeptId = null,
            )

            // Assert
            assertNotNull(result)
            assertEquals(patientId, result.patientId)
            assertEquals(startZeit, result.startZeit)
            assertEquals(endZeit, result.endZeit)
            assertNull(result.rezeptId)
            verify { behandlungRepository.save(any()) }
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
                version = 0,
            )

            every { behandlungRepository.findById(behandlungId) } returns existingBehandlung

            val savedBehandlungSlot = slot<BehandlungAggregate>()
            every { behandlungRepository.save(capture(savedBehandlungSlot)) } answers { savedBehandlungSlot.captured }

            // Act
            val result = behandlungService.updateBehandlung(
                id = behandlungId,
                startZeit = newStartZeit,
                endZeit = newEndZeit,
                rezeptId = newRezeptId,
            )

            // Assert
            assertNotNull(result)
            assertEquals(behandlungId, result.id)
            assertEquals(patientId, result.patientId)
            assertEquals(newStartZeit, result.startZeit)
            assertEquals(newEndZeit, result.endZeit)
            assertEquals(newRezeptId, result.rezeptId)

            verify { behandlungRepository.findById(behandlungId) }
            verify { behandlungRepository.save(any()) }
        }

        @Test
        fun `should throw AggregateNotFoundException when behandlung does not exist`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.randomUUID())
            val startZeit = LocalDateTime.of(2024, 1, 15, 14, 0)
            val endZeit = LocalDateTime.of(2024, 1, 15, 15, 0)

            every { behandlungRepository.findById(behandlungId) } returns null

            // Act & Assert
            assertFailsWith<AggregateNotFoundException> {
                behandlungService.updateBehandlung(
                    id = behandlungId,
                    startZeit = startZeit,
                    endZeit = endZeit,
                    rezeptId = null,
                )
            }

            verify { behandlungRepository.findById(behandlungId) }
            verify(exactly = 0) { behandlungRepository.save(any()) }
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
                version = 0,
            )

            every { behandlungRepository.findById(behandlungId) } returns existingBehandlung

            val savedBehandlungSlot = slot<BehandlungAggregate>()
            every { behandlungRepository.save(capture(savedBehandlungSlot)) } answers { savedBehandlungSlot.captured }

            // Act
            val result = behandlungService.updateBehandlung(
                id = behandlungId,
                startZeit = newStartZeit,
                endZeit = newEndZeit,
                rezeptId = null,
            )

            // Assert
            assertNotNull(result)
            assertEquals(behandlungId, result.id)
            assertEquals(patientId, result.patientId)
            assertEquals(newStartZeit, result.startZeit)
            assertEquals(newEndZeit, result.endZeit)
            assertNull(result.rezeptId)

            verify { behandlungRepository.findById(behandlungId) }
            verify { behandlungRepository.save(any()) }
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
                version = 0,
            )

            every { behandlungRepository.findById(behandlungId) } returns behandlung
            every { behandlungRepository.delete(behandlung) } returns Unit

            // Act
            behandlungService.deleteBehandlung(behandlungId)

            // Assert
            verify { behandlungRepository.findById(behandlungId) }
            verify { behandlungRepository.delete(behandlung) }
        }

        @Test
        fun `should throw AggregateNotFoundException when behandlung does not exist`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.randomUUID())

            every { behandlungRepository.findById(behandlungId) } returns null

            // Act & Assert
            assertFailsWith<AggregateNotFoundException> {
                behandlungService.deleteBehandlung(behandlungId)
            }

            verify { behandlungRepository.findById(behandlungId) }
            verify(exactly = 0) { behandlungRepository.delete(any()) }
        }
    }
}
