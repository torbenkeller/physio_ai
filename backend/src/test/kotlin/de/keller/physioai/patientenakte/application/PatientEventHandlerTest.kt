package de.keller.physioai.patientenakte.application

import de.keller.physioai.patienten.PatientErstelltEvent
import de.keller.physioai.patientenakte.domain.PatientenakteAggregate
import de.keller.physioai.patientenakte.ports.PatientenakteRepository
import de.keller.physioai.shared.PatientId
import io.mockk.clearAllMocks
import io.mockk.every
import io.mockk.junit5.MockKExtension
import io.mockk.mockk
import io.mockk.slot
import io.mockk.verify
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import org.junit.jupiter.api.extension.ExtendWith
import java.util.UUID

@ExtendWith(MockKExtension::class)
class PatientEventHandlerTest {
    private val patientenakteRepository: PatientenakteRepository = mockk(relaxed = true)
    private lateinit var eventHandler: PatientEventHandler

    @BeforeEach
    fun setUp() {
        clearAllMocks()
        eventHandler = PatientEventHandler(patientenakteRepository)
    }

    @Test
    fun `should create patientenakte when patient is created`() {
        // Arrange
        val patientId = PatientId(UUID.randomUUID())
        val event = PatientErstelltEvent(patientId)

        val savedAkteSlot = slot<PatientenakteAggregate>()
        every { patientenakteRepository.save(capture(savedAkteSlot)) } answers { savedAkteSlot.captured }

        // Act
        eventHandler.on(event)

        // Assert
        verify(exactly = 1) { patientenakteRepository.save(any()) }
        assertEquals(patientId, savedAkteSlot.captured.patientId)
    }

    @Test
    fun `should rethrow exception when repository fails`() {
        // Arrange
        val patientId = PatientId(UUID.randomUUID())
        val event = PatientErstelltEvent(patientId)

        every { patientenakteRepository.save(any()) } throws RuntimeException("Database error")

        // Act & Assert
        assertThrows<RuntimeException> {
            eventHandler.on(event)
        }

        verify(exactly = 1) { patientenakteRepository.save(any()) }
    }
}
