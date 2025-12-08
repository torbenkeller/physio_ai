package de.keller.physioai.behandlungen.adapters.api

import com.ninjasquad.springmockk.MockkBean
import de.keller.physioai.behandlungen.domain.BehandlungAggregate
import de.keller.physioai.behandlungen.ports.BehandlungenRepository
import de.keller.physioai.behandlungen.ports.BehandlungenService
import de.keller.physioai.behandlungen.ports.GetWeeklyCalendarBehandlungResponse
import de.keller.physioai.patienten.PatientenRepository
import de.keller.physioai.patienten.domain.PatientAggregate
import de.keller.physioai.shared.AggregateNotFoundException
import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.RezeptId
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
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
import org.springframework.test.web.servlet.result.MockMvcResultMatchers
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.UUID

@Import(SecurityConfig::class)
@WebMvcTest(BehandlungenController::class)
class BehandlungenControllerTest {
    @Autowired
    private lateinit var mockMvc: MockMvc

    @MockkBean
    private lateinit var behandlungenService: BehandlungenService

    @MockkBean
    private lateinit var behandlungenRepository: BehandlungenRepository

    @MockkBean
    private lateinit var patientenRepository: PatientenRepository

    @Nested
    inner class CreateBehandlung {
        @Test
        fun `should return created BehandlungDto with 201 status`() {
            // Arrange
            val patientId = PatientId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            val rezeptId = RezeptId(UUID.fromString("a1b2c3d4-e5f6-7890-1234-567890abcdef"))
            val behandlungId = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba"))
            val startZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
            val endZeit = LocalDateTime.of(2024, 1, 15, 11, 0)

            val createdBehandlung = BehandlungAggregate(
                id = behandlungId,
                patientId = patientId,
                startZeit = startZeit,
                endZeit = endZeit,
                rezeptId = rezeptId,
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            every {
                behandlungenService.createBehandlung(
                    patientId,
                    startZeit,
                    endZeit,
                    rezeptId,
                    null,
                )
            } returns createdBehandlung

            // Act & Assert
            mockMvc
                .perform(
                    MockMvcRequestBuilders
                        .post("/behandlungen")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                            {
                                "patientId": "${patientId.id}",
                                "startZeit": "2024-01-15T10:00:00",
                                "endZeit": "2024-01-15T11:00:00",
                                "rezeptId": "${rezeptId.id}"
                            }
                            """,
                        ),
                ).andExpect(MockMvcResultMatchers.status().isCreated)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(behandlungId.id.toString()))
                .andExpect(MockMvcResultMatchers.jsonPath("$.patientId").value(patientId.id.toString()))
                .andExpect(MockMvcResultMatchers.jsonPath("$.startZeit").value("2024-01-15T10:00:00"))
                .andExpect(MockMvcResultMatchers.jsonPath("$.endZeit").value("2024-01-15T11:00:00"))
                .andExpect(MockMvcResultMatchers.jsonPath("$.rezeptId").value(rezeptId.id.toString()))

            verify { behandlungenService.createBehandlung(patientId, startZeit, endZeit, rezeptId, null) }
        }

        @Test
        fun `should work without rezeptId`() {
            // Arrange
            val patientId = PatientId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            val behandlungId = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba"))
            val startZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
            val endZeit = LocalDateTime.of(2024, 1, 15, 11, 0)

            val createdBehandlung = BehandlungAggregate(
                id = behandlungId,
                patientId = patientId,
                startZeit = startZeit,
                endZeit = endZeit,
                rezeptId = null,
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            every {
                behandlungenService.createBehandlung(
                    patientId,
                    startZeit,
                    endZeit,
                    null,
                    null,
                )
            } returns createdBehandlung

            // Act & Assert
            mockMvc
                .perform(
                    MockMvcRequestBuilders
                        .post("/behandlungen")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                            {
                                "patientId": "${patientId.id}",
                                "startZeit": "2024-01-15T10:00:00",
                                "endZeit": "2024-01-15T11:00:00",
                                "rezeptId": null
                            }
                            """,
                        ),
                ).andExpect(MockMvcResultMatchers.status().isCreated)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(behandlungId.id.toString()))
                .andExpect(MockMvcResultMatchers.jsonPath("$.patientId").value(patientId.id.toString()))
                .andExpect(MockMvcResultMatchers.jsonPath("$.startZeit").value("2024-01-15T10:00:00"))
                .andExpect(MockMvcResultMatchers.jsonPath("$.endZeit").value("2024-01-15T11:00:00"))
                .andExpect(MockMvcResultMatchers.jsonPath("$.rezeptId").doesNotExist())

            verify { behandlungenService.createBehandlung(patientId, startZeit, endZeit, null, null) }
        }
    }

    @Nested
    inner class GetBehandlung {
        @Test
        fun `should return BehandlungDto when behandlung exists`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba"))
            val patientId = PatientId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            val rezeptId = RezeptId(UUID.fromString("a1b2c3d4-e5f6-7890-1234-567890abcdef"))
            val startZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
            val endZeit = LocalDateTime.of(2024, 1, 15, 11, 0)

            val behandlung = BehandlungAggregate(
                id = behandlungId,
                patientId = patientId,
                startZeit = startZeit,
                endZeit = endZeit,
                rezeptId = rezeptId,
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            every { behandlungenRepository.findById(behandlungId) } returns behandlung

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.get("/behandlungen/${behandlungId.id}"))
                .andExpect(MockMvcResultMatchers.status().isOk)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(behandlungId.id.toString()))
                .andExpect(MockMvcResultMatchers.jsonPath("$.patientId").value(patientId.id.toString()))
                .andExpect(MockMvcResultMatchers.jsonPath("$.startZeit").value("2024-01-15T10:00:00"))
                .andExpect(MockMvcResultMatchers.jsonPath("$.endZeit").value("2024-01-15T11:00:00"))
                .andExpect(MockMvcResultMatchers.jsonPath("$.rezeptId").value(rezeptId.id.toString()))

            verify { behandlungenRepository.findById(behandlungId) }
        }

        @Test
        fun `should throw AggregateNotFoundException when behandlung does not exist`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba"))

            every { behandlungenRepository.findById(behandlungId) } returns null

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.get("/behandlungen/${behandlungId.id}"))
                .andExpect(MockMvcResultMatchers.status().isNotFound)

            verify { behandlungenRepository.findById(behandlungId) }
        }
    }

    @Nested
    inner class GetAllBehandlungen {
        @Test
        fun `should return list of BehandlungDto`() {
            // Arrange
            val behandlung1 = BehandlungAggregate(
                id = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba")),
                patientId = PatientId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a")),
                startZeit = LocalDateTime.of(2024, 1, 15, 10, 0),
                endZeit = LocalDateTime.of(2024, 1, 15, 11, 0),
                rezeptId = RezeptId(UUID.fromString("a1b2c3d4-e5f6-7890-1234-567890abcdef")),
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            val behandlung2 = BehandlungAggregate(
                id = BehandlungId(UUID.fromString("a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5")),
                patientId = PatientId(UUID.fromString("b2b2b2b2-c3c3-d4d4-e5e5-f6f6f6f6f6f6")),
                startZeit = LocalDateTime.of(2024, 1, 16, 14, 0),
                endZeit = LocalDateTime.of(2024, 1, 16, 15, 0),
                rezeptId = null,
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            every { behandlungenRepository.findAll() } returns listOf(behandlung1, behandlung2)

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.get("/behandlungen"))
                .andExpect(MockMvcResultMatchers.status().isOk)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(2))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].id").value("f1e2d3c4-b5a6-9870-1234-567890fedcba"))
                .andExpect(MockMvcResultMatchers.jsonPath("$[1].id").value("a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5"))

            verify { behandlungenRepository.findAll() }
        }
    }

    @Nested
    inner class GetBehandlungenByPatient {
        @Test
        fun `should return list of BehandlungDto for specific patient`() {
            // Arrange
            val patientId = PatientId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            val behandlung = BehandlungAggregate(
                id = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba")),
                patientId = patientId,
                startZeit = LocalDateTime.of(2024, 1, 15, 10, 0),
                endZeit = LocalDateTime.of(2024, 1, 15, 11, 0),
                rezeptId = RezeptId(UUID.fromString("a1b2c3d4-e5f6-7890-1234-567890abcdef")),
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            every { behandlungenRepository.findAllByPatientId(patientId) } returns listOf(behandlung)

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.get("/behandlungen/patient/${patientId.id}"))
                .andExpect(MockMvcResultMatchers.status().isOk)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].id").value("f1e2d3c4-b5a6-9870-1234-567890fedcba"))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].patientId").value(patientId.id.toString()))

            verify { behandlungenRepository.findAllByPatientId(patientId) }
        }
    }

    @Nested
    inner class UpdateBehandlung {
        @Test
        fun `should return updated BehandlungDto`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba"))
            val patientId = PatientId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            val rezeptId = RezeptId(UUID.fromString("a1b2c3d4-e5f6-7890-1234-567890abcdef"))
            val startZeit = LocalDateTime.of(2024, 1, 15, 14, 0)
            val endZeit = LocalDateTime.of(2024, 1, 15, 15, 0)

            val updatedBehandlung = BehandlungAggregate(
                id = behandlungId,
                patientId = patientId,
                startZeit = startZeit,
                endZeit = endZeit,
                rezeptId = rezeptId,
                behandlungsartId = null,
                bemerkung = null,
                version = 1,
            )

            every {
                behandlungenService.updateBehandlung(
                    behandlungId,
                    startZeit,
                    endZeit,
                    rezeptId,
                    null,
                    null,
                )
            } returns updatedBehandlung

            // Act & Assert
            mockMvc
                .perform(
                    MockMvcRequestBuilders
                        .put("/behandlungen/${behandlungId.id}")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                            {
                                "patientId": "${patientId.id}",
                                "startZeit": "2024-01-15T14:00:00",
                                "endZeit": "2024-01-15T15:00:00",
                                "rezeptId": "${rezeptId.id}"
                            }
                            """,
                        ),
                ).andExpect(MockMvcResultMatchers.status().isOk)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(behandlungId.id.toString()))
                .andExpect(MockMvcResultMatchers.jsonPath("$.startZeit").value("2024-01-15T14:00:00"))
                .andExpect(MockMvcResultMatchers.jsonPath("$.endZeit").value("2024-01-15T15:00:00"))

            verify {
                behandlungenService.updateBehandlung(
                    behandlungId,
                    startZeit,
                    endZeit,
                    rezeptId,
                    null,
                    null,
                )
            }
        }

        @Test
        fun `should throw AggregateNotFoundException when behandlung does not exist`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba"))
            val startZeit = LocalDateTime.of(2024, 1, 15, 14, 0)
            val endZeit = LocalDateTime.of(2024, 1, 15, 15, 0)
            val rezeptId = RezeptId(UUID.fromString("a1b2c3d4-e5f6-7890-1234-567890abcdef"))

            every {
                behandlungenService.updateBehandlung(behandlungId, startZeit, endZeit, rezeptId, null, null)
            } throws AggregateNotFoundException()

            // Act & Assert
            mockMvc
                .perform(
                    MockMvcRequestBuilders
                        .put("/behandlungen/${behandlungId.id}")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                            {
                                "patientId": "d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a",
                                "startZeit": "2024-01-15T14:00:00",
                                "endZeit": "2024-01-15T15:00:00",
                                "rezeptId": "a1b2c3d4-e5f6-7890-1234-567890abcdef"
                            }
                            """,
                        ),
                ).andExpect(MockMvcResultMatchers.status().isNotFound)

            verify { behandlungenService.updateBehandlung(behandlungId, startZeit, endZeit, rezeptId, null, null) }
        }
    }

    @Nested
    inner class DeleteBehandlung {
        @Test
        fun `should call service delete method`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba"))

            every { behandlungenService.deleteBehandlung(behandlungId) } returns Unit

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.delete("/behandlungen/${behandlungId.id}"))
                .andExpect(MockMvcResultMatchers.status().isOk)

            verify { behandlungenService.deleteBehandlung(behandlungId) }
        }

        @Test
        fun `should throw AggregateNotFoundException when behandlung does not exist`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba"))

            every { behandlungenService.deleteBehandlung(behandlungId) } throws AggregateNotFoundException()

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.delete("/behandlungen/${behandlungId.id}"))
                .andExpect(MockMvcResultMatchers.status().isNotFound)

            verify { behandlungenService.deleteBehandlung(behandlungId) }
        }
    }

    @Nested
    inner class VerschiebeBehandlung {
        @Test
        fun `should move behandlung to new time successfully`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba"))
            val patientId = PatientId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            val neueStartZeit = LocalDateTime.of(2024, 1, 15, 14, 0)
            val neueEndZeit = LocalDateTime.of(2024, 1, 15, 15, 0)

            val verschobeneBehandlung = BehandlungAggregate(
                id = behandlungId,
                patientId = patientId,
                startZeit = neueStartZeit,
                endZeit = neueEndZeit,
                rezeptId = null,
                behandlungsartId = null,
                bemerkung = null,
                version = 1,
            )

            every { behandlungenService.verschiebeBehandlung(behandlungId, neueStartZeit) } returns verschobeneBehandlung

            // Act & Assert
            mockMvc
                .perform(
                    MockMvcRequestBuilders
                        .put("/behandlungen/${behandlungId.id}/verschiebe")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                            {
                                "nach": "2024-01-15T14:00:00"
                            }
                            """,
                        ),
                ).andExpect(MockMvcResultMatchers.status().isOk)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(behandlungId.id.toString()))
                .andExpect(MockMvcResultMatchers.jsonPath("$.patientId").value(patientId.id.toString()))
                .andExpect(MockMvcResultMatchers.jsonPath("$.startZeit").value("2024-01-15T14:00:00"))
                .andExpect(MockMvcResultMatchers.jsonPath("$.endZeit").value("2024-01-15T15:00:00"))

            verify { behandlungenService.verschiebeBehandlung(behandlungId, neueStartZeit) }
        }

        @Test
        fun `should return 404 when behandlung does not exist`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba"))
            val neueStartZeit = LocalDateTime.of(2024, 1, 15, 14, 0)

            every { behandlungenService.verschiebeBehandlung(behandlungId, neueStartZeit) } throws AggregateNotFoundException()

            // Act & Assert
            mockMvc
                .perform(
                    MockMvcRequestBuilders
                        .put("/behandlungen/${behandlungId.id}/verschiebe")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                            {
                                "nach": "2024-01-15T14:00:00"
                            }
                            """,
                        ),
                ).andExpect(MockMvcResultMatchers.status().isNotFound)

            verify { behandlungenService.verschiebeBehandlung(behandlungId, neueStartZeit) }
        }
    }

    @Nested
    inner class GetWeeklyCalendar {
        @Test
        fun `should return treatments grouped by weekdays for given week`() {
            // Arrange
            val queryDate = "2024-01-15" // Monday

            // Create test treatments for that week (Monday 15th to Sunday 21st)
            val mondayTreatment = BehandlungAggregate(
                id = BehandlungId(UUID.fromString("11111111-1111-1111-1111-111111111111")),
                patientId = PatientId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a")),
                startZeit = LocalDateTime.of(2024, 1, 15, 10, 0), // Monday
                endZeit = LocalDateTime.of(2024, 1, 15, 11, 0),
                rezeptId = null,
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            val wednesdayTreatment = BehandlungAggregate(
                id = BehandlungId(UUID.fromString("22222222-2222-2222-2222-222222222222")),
                patientId = PatientId(UUID.fromString("a1b2c3d4-e5f6-7890-1234-567890abcdef")),
                startZeit = LocalDateTime.of(2024, 1, 17, 14, 0), // Wednesday
                endZeit = LocalDateTime.of(2024, 1, 17, 15, 0),
                rezeptId = null,
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            // Mock service to return enriched treatments grouped by dates
            val weeklyCalendar: Map<LocalDate, List<GetWeeklyCalendarBehandlungResponse>> = mapOf(
                LocalDate.of(2024, 1, 15) to emptyList(), // Monday
                LocalDate.of(2024, 1, 16) to emptyList(), // Tuesday
                LocalDate.of(2024, 1, 17) to emptyList(), // Wednesday
                LocalDate.of(2024, 1, 18) to emptyList(), // Thursday
                LocalDate.of(2024, 1, 19) to emptyList(), // Friday
                LocalDate.of(2024, 1, 20) to emptyList(), // Saturday
                LocalDate.of(2024, 1, 21) to emptyList(), // Sunday
            )

            every { behandlungenService.getWeeklyCalendar(LocalDate.of(2024, 1, 15)) } returns weeklyCalendar

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.get("/behandlungen/calender/week?date=2024-01-15"))
                .andExpect(MockMvcResultMatchers.status().isOk)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$['2024-01-15'].length()").value(0)) // Monday
                .andExpect(MockMvcResultMatchers.jsonPath("$['2024-01-16'].length()").value(0)) // Tuesday
                .andExpect(MockMvcResultMatchers.jsonPath("$['2024-01-17'].length()").value(0)) // Wednesday
                .andExpect(MockMvcResultMatchers.jsonPath("$['2024-01-18'].length()").value(0)) // Thursday
                .andExpect(MockMvcResultMatchers.jsonPath("$['2024-01-19'].length()").value(0)) // Friday
                .andExpect(MockMvcResultMatchers.jsonPath("$['2024-01-20'].length()").value(0)) // Saturday
                .andExpect(MockMvcResultMatchers.jsonPath("$['2024-01-21'].length()").value(0)) // Sunday

            verify { behandlungenService.getWeeklyCalendar(LocalDate.of(2024, 1, 15)) }
        }
    }

    @Nested
    inner class CheckConflicts {
        @Test
        fun `should return conflict results for given slots`() {
            // Arrange
            val conflictingBehandlungId = BehandlungId(UUID.fromString("11111111-1111-1111-1111-111111111111"))

            every {
                behandlungenService.checkConflicts(any())
            } returns listOf(
                BehandlungenService.ConflictResult(
                    slotIndex = 0,
                    hasConflict = true,
                    conflictingBehandlungen = listOf(
                        BehandlungenService.ConflictingBehandlung(
                            id = conflictingBehandlungId,
                            startZeit = LocalDateTime.of(2024, 1, 15, 10, 30),
                            endZeit = LocalDateTime.of(2024, 1, 15, 12, 0),
                            patientName = "Max Mustermann",
                        ),
                    ),
                ),
                BehandlungenService.ConflictResult(
                    slotIndex = 1,
                    hasConflict = false,
                    conflictingBehandlungen = emptyList(),
                ),
            )

            // Act & Assert
            mockMvc
                .perform(
                    MockMvcRequestBuilders
                        .post("/behandlungen/check-conflicts")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                            {
                                "slots": [
                                    {
                                        "startZeit": "2024-01-15T10:00:00",
                                        "endZeit": "2024-01-15T11:30:00"
                                    },
                                    {
                                        "startZeit": "2024-01-16T14:00:00",
                                        "endZeit": "2024-01-16T15:30:00"
                                    }
                                ]
                            }
                            """,
                        ),
                ).andExpect(MockMvcResultMatchers.status().isOk)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(2))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].slotIndex").value(0))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].hasConflict").value(true))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].conflictingBehandlungen.length()").value(1))
                .andExpect(
                    MockMvcResultMatchers.jsonPath("$[0].conflictingBehandlungen[0].id").value("11111111-1111-1111-1111-111111111111"),
                ).andExpect(MockMvcResultMatchers.jsonPath("$[0].conflictingBehandlungen[0].patientName").value("Max Mustermann"))
                .andExpect(MockMvcResultMatchers.jsonPath("$[1].slotIndex").value(1))
                .andExpect(MockMvcResultMatchers.jsonPath("$[1].hasConflict").value(false))
                .andExpect(MockMvcResultMatchers.jsonPath("$[1].conflictingBehandlungen.length()").value(0))

            verify { behandlungenService.checkConflicts(any()) }
        }

        @Test
        fun `should return empty conflicts when no overlapping exists`() {
            // Arrange
            every {
                behandlungenService.checkConflicts(any())
            } returns listOf(
                BehandlungenService.ConflictResult(
                    slotIndex = 0,
                    hasConflict = false,
                    conflictingBehandlungen = emptyList(),
                ),
            )

            // Act & Assert
            mockMvc
                .perform(
                    MockMvcRequestBuilders
                        .post("/behandlungen/check-conflicts")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(
                            """
                            {
                                "slots": [
                                    {
                                        "startZeit": "2024-01-15T10:00:00",
                                        "endZeit": "2024-01-15T11:30:00"
                                    }
                                ]
                            }
                            """,
                        ),
                ).andExpect(MockMvcResultMatchers.status().isOk)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].slotIndex").value(0))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].hasConflict").value(false))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].conflictingBehandlungen.length()").value(0))

            verify { behandlungenService.checkConflicts(any()) }
        }
    }

    @Nested
    inner class GetUnassignedBehandlungenByPatient {
        @Test
        fun `should return list of unassigned behandlungen for patient`() {
            // Arrange
            val patientId = PatientId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            val behandlungId = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba"))
            val startZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
            val endZeit = LocalDateTime.of(2024, 1, 15, 11, 0)

            val behandlung = BehandlungAggregate(
                id = behandlungId,
                patientId = patientId,
                startZeit = startZeit,
                endZeit = endZeit,
                rezeptId = null,
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            val patient = PatientAggregate(
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
                email = "max@example.com",
                geburtstag = LocalDate.of(1990, 1, 1),
                behandlungenProRezept = null,
                version = 0,
            )

            every { behandlungenRepository.findUnassignedByPatientId(patientId) } returns listOf(behandlung)
            every { patientenRepository.findById(patientId) } returns patient

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.get("/behandlungen/patient/${patientId.id}/unassigned"))
                .andExpect(MockMvcResultMatchers.status().isOk)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].id").value(behandlungId.id.toString()))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].startZeit").value("2024-01-15T10:00:00"))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].endZeit").value("2024-01-15T11:00:00"))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].patient.name").value("Max Mustermann"))

            verify { behandlungenRepository.findUnassignedByPatientId(patientId) }
            verify { patientenRepository.findById(patientId) }
        }

        @Test
        fun `should return empty list when no unassigned behandlungen exist`() {
            // Arrange
            val patientId = PatientId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))

            val patient = PatientAggregate(
                id = patientId,
                titel = null,
                vorname = "Max",
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
                version = 0,
            )

            every { behandlungenRepository.findUnassignedByPatientId(patientId) } returns emptyList()
            every { patientenRepository.findById(patientId) } returns patient

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.get("/behandlungen/patient/${patientId.id}/unassigned"))
                .andExpect(MockMvcResultMatchers.status().isOk)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(0))

            verify { behandlungenRepository.findUnassignedByPatientId(patientId) }
            verify { patientenRepository.findById(patientId) }
        }

        @Test
        fun `should return 404 when patient does not exist`() {
            // Arrange
            val patientId = PatientId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))

            every { behandlungenRepository.findUnassignedByPatientId(patientId) } returns emptyList()
            every { patientenRepository.findById(patientId) } returns null

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.get("/behandlungen/patient/${patientId.id}/unassigned"))
                .andExpect(MockMvcResultMatchers.status().isNotFound)

            verify { behandlungenRepository.findUnassignedByPatientId(patientId) }
            verify { patientenRepository.findById(patientId) }
        }
    }

    @Nested
    inner class GetBehandlungenByRezept {
        @Test
        fun `should return list of behandlungen for rezept`() {
            // Arrange
            val patientId = PatientId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            val rezeptId = RezeptId(UUID.fromString("a1b2c3d4-e5f6-7890-1234-567890abcdef"))
            val behandlungId = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba"))
            val startZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
            val endZeit = LocalDateTime.of(2024, 1, 15, 11, 0)

            val behandlung = BehandlungAggregate(
                id = behandlungId,
                patientId = patientId,
                startZeit = startZeit,
                endZeit = endZeit,
                rezeptId = rezeptId,
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            val patient = PatientAggregate(
                id = patientId,
                titel = "Dr.",
                vorname = "Max",
                nachname = "Mustermann",
                strasse = "Musterstraße",
                hausnummer = "1",
                plz = "12345",
                stadt = "Musterstadt",
                telMobil = "0123456789",
                telFestnetz = null,
                email = "max@example.com",
                geburtstag = LocalDate.of(1990, 1, 1),
                behandlungenProRezept = null,
                version = 0,
            )

            every { behandlungenRepository.findByRezeptId(rezeptId) } returns listOf(behandlung)
            every { patientenRepository.findAllByIdIn(setOf(patientId)) } returns listOf(patient)

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.get("/behandlungen/rezept/${rezeptId.id}"))
                .andExpect(MockMvcResultMatchers.status().isOk)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].id").value(behandlungId.id.toString()))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].startZeit").value("2024-01-15T10:00:00"))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].endZeit").value("2024-01-15T11:00:00"))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].patient.name").value("Max Mustermann"))

            verify { behandlungenRepository.findByRezeptId(rezeptId) }
            verify { patientenRepository.findAllByIdIn(setOf(patientId)) }
        }

        @Test
        fun `should return empty list when no behandlungen exist for rezept`() {
            // Arrange
            val rezeptId = RezeptId(UUID.fromString("a1b2c3d4-e5f6-7890-1234-567890abcdef"))

            every { behandlungenRepository.findByRezeptId(rezeptId) } returns emptyList()

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.get("/behandlungen/rezept/${rezeptId.id}"))
                .andExpect(MockMvcResultMatchers.status().isOk)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(0))

            verify { behandlungenRepository.findByRezeptId(rezeptId) }
            verify(exactly = 0) { patientenRepository.findAllByIdIn(any()) }
        }

        @Test
        fun `should handle multiple behandlungen with different patients`() {
            // Arrange
            val patientId1 = PatientId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            val patientId2 = PatientId(UUID.fromString("e8f9a0b1-c2d3-4e5f-6a7b-8c9d0e1f2a3b"))
            val rezeptId = RezeptId(UUID.fromString("a1b2c3d4-e5f6-7890-1234-567890abcdef"))

            val behandlung1 = BehandlungAggregate(
                id = BehandlungId(UUID.fromString("11111111-1111-1111-1111-111111111111")),
                patientId = patientId1,
                startZeit = LocalDateTime.of(2024, 1, 15, 10, 0),
                endZeit = LocalDateTime.of(2024, 1, 15, 11, 0),
                rezeptId = rezeptId,
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            val behandlung2 = BehandlungAggregate(
                id = BehandlungId(UUID.fromString("22222222-2222-2222-2222-222222222222")),
                patientId = patientId2,
                startZeit = LocalDateTime.of(2024, 1, 16, 14, 0),
                endZeit = LocalDateTime.of(2024, 1, 16, 15, 0),
                rezeptId = rezeptId,
                behandlungsartId = null,
                bemerkung = null,
                version = 0,
            )

            val patient1 = PatientAggregate(
                id = patientId1,
                titel = null,
                vorname = "Max",
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
                version = 0,
            )

            val patient2 = PatientAggregate(
                id = patientId2,
                titel = null,
                vorname = "Anna",
                nachname = "Schmidt",
                strasse = null,
                hausnummer = null,
                plz = null,
                stadt = null,
                telMobil = null,
                telFestnetz = null,
                email = null,
                geburtstag = null,
                behandlungenProRezept = null,
                version = 0,
            )

            every { behandlungenRepository.findByRezeptId(rezeptId) } returns listOf(behandlung1, behandlung2)
            every { patientenRepository.findAllByIdIn(setOf(patientId1, patientId2)) } returns listOf(patient1, patient2)

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.get("/behandlungen/rezept/${rezeptId.id}"))
                .andExpect(MockMvcResultMatchers.status().isOk)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(2))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].id").value("11111111-1111-1111-1111-111111111111"))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].patient.name").value("Max Mustermann"))
                .andExpect(MockMvcResultMatchers.jsonPath("$[1].id").value("22222222-2222-2222-2222-222222222222"))
                .andExpect(MockMvcResultMatchers.jsonPath("$[1].patient.name").value("Anna Schmidt"))

            verify { behandlungenRepository.findByRezeptId(rezeptId) }
            verify { patientenRepository.findAllByIdIn(setOf(patientId1, patientId2)) }
        }
    }
}
