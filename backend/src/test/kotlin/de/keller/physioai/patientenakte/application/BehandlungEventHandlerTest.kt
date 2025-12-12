package de.keller.physioai.patientenakte.application

import de.keller.physioai.behandlungen.BehandlungGeaendertEvent
import de.keller.physioai.behandlungen.BehandlungGeloeschtEvent
import de.keller.physioai.behandlungen.BehandlungenGeaendertEvent
import de.keller.physioai.patientenakte.ports.PatientenakteService
import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.PatientId
import io.mockk.clearAllMocks
import io.mockk.every
import io.mockk.junit5.MockKExtension
import io.mockk.mockk
import io.mockk.verify
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import org.junit.jupiter.api.extension.ExtendWith
import java.time.LocalDateTime
import java.util.UUID

@ExtendWith(MockKExtension::class)
class BehandlungEventHandlerTest {
    private val patientenakteService: PatientenakteService = mockk(relaxed = true)
    private lateinit var eventHandler: BehandlungEventHandler

    @BeforeEach
    fun setUp() {
        clearAllMocks()
        eventHandler = BehandlungEventHandler(patientenakteService)
    }

    @Nested
    inner class OnBehandlungGeaendertEvent {
        @Test
        fun `should synchronize behandlung eintrag when event is received`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.randomUUID())
            val patientId = PatientId(UUID.randomUUID())
            val startZeit = LocalDateTime.now()
            val bemerkung = "Test Bemerkung"

            val event = BehandlungGeaendertEvent(
                behandlungId = behandlungId,
                patientId = patientId,
                startZeit = startZeit,
                bemerkung = bemerkung,
            )

            every {
                patientenakteService.synchronisiereBehandlungsEintrag(
                    behandlungId = behandlungId,
                    patientId = patientId,
                    behandlungsDatum = startZeit,
                    bemerkung = bemerkung,
                )
            } returns Unit

            // Act
            eventHandler.on(event)

            // Assert
            verify(exactly = 1) {
                patientenakteService.synchronisiereBehandlungsEintrag(
                    behandlungId = behandlungId,
                    patientId = patientId,
                    behandlungsDatum = startZeit,
                    bemerkung = bemerkung,
                )
            }
        }

        @Test
        fun `should rethrow exception when service fails`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.randomUUID())
            val patientId = PatientId(UUID.randomUUID())
            val startZeit = LocalDateTime.now()

            val event = BehandlungGeaendertEvent(
                behandlungId = behandlungId,
                patientId = patientId,
                startZeit = startZeit,
                bemerkung = null,
            )

            every {
                patientenakteService.synchronisiereBehandlungsEintrag(
                    behandlungId = behandlungId,
                    patientId = patientId,
                    behandlungsDatum = startZeit,
                    bemerkung = null,
                )
            } throws RuntimeException("Database error")

            // Act & Assert
            assertThrows<RuntimeException> {
                eventHandler.on(event)
            }

            verify(exactly = 1) {
                patientenakteService.synchronisiereBehandlungsEintrag(
                    behandlungId = behandlungId,
                    patientId = patientId,
                    behandlungsDatum = startZeit,
                    bemerkung = null,
                )
            }
        }
    }

    @Nested
    inner class OnBehandlungenGeaendertEvent {
        @Test
        fun `should synchronize batch when event is received`() {
            // Arrange
            val behandlungId1 = BehandlungId(UUID.randomUUID())
            val behandlungId2 = BehandlungId(UUID.randomUUID())
            val patientId = PatientId(UUID.randomUUID())
            val startZeit1 = LocalDateTime.now()
            val startZeit2 = LocalDateTime.now().plusHours(1)

            val event = BehandlungenGeaendertEvent(
                behandlungen = listOf(
                    BehandlungenGeaendertEvent.BehandlungData(
                        behandlungId = behandlungId1,
                        patientId = patientId,
                        startZeit = startZeit1,
                        bemerkung = "Bemerkung 1",
                    ),
                    BehandlungenGeaendertEvent.BehandlungData(
                        behandlungId = behandlungId2,
                        patientId = patientId,
                        startZeit = startZeit2,
                        bemerkung = null,
                    ),
                ),
            )

            every {
                patientenakteService.synchronisiereBehandlungsEintraegeBatch(any())
            } returns Unit

            // Act
            eventHandler.on(event)

            // Assert
            verify(exactly = 1) {
                patientenakteService.synchronisiereBehandlungsEintraegeBatch(
                    match { eintraege ->
                        eintraege.size == 2 &&
                            eintraege[0].behandlungId == behandlungId1 &&
                            eintraege[1].behandlungId == behandlungId2
                    },
                )
            }
        }

        @Test
        fun `should rethrow exception when batch service fails`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.randomUUID())
            val patientId = PatientId(UUID.randomUUID())
            val startZeit = LocalDateTime.now()

            val event = BehandlungenGeaendertEvent(
                behandlungen = listOf(
                    BehandlungenGeaendertEvent.BehandlungData(
                        behandlungId = behandlungId,
                        patientId = patientId,
                        startZeit = startZeit,
                        bemerkung = null,
                    ),
                ),
            )

            every {
                patientenakteService.synchronisiereBehandlungsEintraegeBatch(any())
            } throws RuntimeException("Batch processing error")

            // Act & Assert
            assertThrows<RuntimeException> {
                eventHandler.on(event)
            }
        }
    }

    @Nested
    inner class OnBehandlungGeloeschtEvent {
        @Test
        fun `should delete behandlung eintrag when event is received`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.randomUUID())
            val patientId = PatientId(UUID.randomUUID())

            val event = BehandlungGeloeschtEvent(
                behandlungId = behandlungId,
                patientId = patientId,
            )

            every {
                patientenakteService.loescheBehandlungsEintrag(
                    behandlungId = behandlungId,
                    patientId = patientId,
                )
            } returns Unit

            // Act
            eventHandler.on(event)

            // Assert
            verify(exactly = 1) {
                patientenakteService.loescheBehandlungsEintrag(
                    behandlungId = behandlungId,
                    patientId = patientId,
                )
            }
        }

        @Test
        fun `should rethrow exception when delete service fails`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.randomUUID())
            val patientId = PatientId(UUID.randomUUID())

            val event = BehandlungGeloeschtEvent(
                behandlungId = behandlungId,
                patientId = patientId,
            )

            every {
                patientenakteService.loescheBehandlungsEintrag(
                    behandlungId = behandlungId,
                    patientId = patientId,
                )
            } throws RuntimeException("Delete error")

            // Act & Assert
            assertThrows<RuntimeException> {
                eventHandler.on(event)
            }

            verify(exactly = 1) {
                patientenakteService.loescheBehandlungsEintrag(
                    behandlungId = behandlungId,
                    patientId = patientId,
                )
            }
        }
    }
}
