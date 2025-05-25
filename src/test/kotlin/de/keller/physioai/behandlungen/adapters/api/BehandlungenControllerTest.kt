package de.keller.physioai.behandlungen.adapters.api

import com.ninjasquad.springmockk.MockkBean
import de.keller.physioai.behandlungen.domain.BehandlungAggregate
import de.keller.physioai.behandlungen.ports.BehandlungenRepository
import de.keller.physioai.behandlungen.ports.BehandlungenService
import de.keller.physioai.behandlungen.ports.GetWeeklyCalendarBehandlungResponse
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
                version = 0,
            )

            every {
                behandlungenService.createBehandlung(
                    patientId,
                    startZeit,
                    endZeit,
                    rezeptId,
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

            verify { behandlungenService.createBehandlung(patientId, startZeit, endZeit, rezeptId) }
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
                version = 0,
            )

            every {
                behandlungenService.createBehandlung(
                    patientId,
                    startZeit,
                    endZeit,
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

            verify { behandlungenService.createBehandlung(patientId, startZeit, endZeit, null) }
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
                version = 0,
            )

            val behandlung2 = BehandlungAggregate(
                id = BehandlungId(UUID.fromString("a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5")),
                patientId = PatientId(UUID.fromString("b2b2b2b2-c3c3-d4d4-e5e5-f6f6f6f6f6f6")),
                startZeit = LocalDateTime.of(2024, 1, 16, 14, 0),
                endZeit = LocalDateTime.of(2024, 1, 16, 15, 0),
                rezeptId = null,
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
                version = 1,
            )

            every {
                behandlungenService.updateBehandlung(
                    behandlungId,
                    startZeit,
                    endZeit,
                    rezeptId,
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
                behandlungenService.updateBehandlung(behandlungId, startZeit, endZeit, rezeptId)
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

            verify { behandlungenService.updateBehandlung(behandlungId, startZeit, endZeit, rezeptId) }
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
                version = 0,
            )

            val wednesdayTreatment = BehandlungAggregate(
                id = BehandlungId(UUID.fromString("22222222-2222-2222-2222-222222222222")),
                patientId = PatientId(UUID.fromString("a1b2c3d4-e5f6-7890-1234-567890abcdef")),
                startZeit = LocalDateTime.of(2024, 1, 17, 14, 0), // Wednesday
                endZeit = LocalDateTime.of(2024, 1, 17, 15, 0),
                rezeptId = null,
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
}
