package de.keller.physioai.behandlungen.adapters.api

import com.ninjasquad.springmockk.MockkBean
import de.keller.physioai.behandlungen.domain.BehandlungAggregate
import de.keller.physioai.behandlungen.ports.BehandlungRepository
import de.keller.physioai.behandlungen.ports.BehandlungService
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
import java.time.LocalDateTime
import java.util.UUID

@Import(SecurityConfig::class)
@WebMvcTest(BehandlungController::class)
class BehandlungControllerTest {
    @Autowired
    private lateinit var mockMvc: MockMvc

    @MockkBean
    private lateinit var behandlungService: BehandlungService

    @MockkBean
    private lateinit var behandlungRepository: BehandlungRepository

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
                behandlungService.createBehandlung(
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

            verify { behandlungService.createBehandlung(patientId, startZeit, endZeit, rezeptId) }
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
                behandlungService.createBehandlung(
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

            verify { behandlungService.createBehandlung(patientId, startZeit, endZeit, null) }
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

            every { behandlungRepository.findById(behandlungId) } returns behandlung

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

            verify { behandlungRepository.findById(behandlungId) }
        }

        @Test
        fun `should throw AggregateNotFoundException when behandlung does not exist`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba"))

            every { behandlungRepository.findById(behandlungId) } returns null

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.get("/behandlungen/${behandlungId.id}"))
                .andExpect(MockMvcResultMatchers.status().isNotFound)

            verify { behandlungRepository.findById(behandlungId) }
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

            every { behandlungRepository.findAll() } returns listOf(behandlung1, behandlung2)

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.get("/behandlungen"))
                .andExpect(MockMvcResultMatchers.status().isOk)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(2))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].id").value("f1e2d3c4-b5a6-9870-1234-567890fedcba"))
                .andExpect(MockMvcResultMatchers.jsonPath("$[1].id").value("a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5"))

            verify { behandlungRepository.findAll() }
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

            every { behandlungRepository.findAllByPatientId(patientId) } returns listOf(behandlung)

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.get("/behandlungen/patient/${patientId.id}"))
                .andExpect(MockMvcResultMatchers.status().isOk)
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].id").value("f1e2d3c4-b5a6-9870-1234-567890fedcba"))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].patientId").value(patientId.id.toString()))

            verify { behandlungRepository.findAllByPatientId(patientId) }
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
                behandlungService.updateBehandlung(
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
                behandlungService.updateBehandlung(
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
                behandlungService.updateBehandlung(behandlungId, startZeit, endZeit, rezeptId)
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

            verify { behandlungService.updateBehandlung(behandlungId, startZeit, endZeit, rezeptId) }
        }
    }

    @Nested
    inner class DeleteBehandlung {
        @Test
        fun `should call service delete method`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba"))

            every { behandlungService.deleteBehandlung(behandlungId) } returns Unit

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.delete("/behandlungen/${behandlungId.id}"))
                .andExpect(MockMvcResultMatchers.status().isOk)

            verify { behandlungService.deleteBehandlung(behandlungId) }
        }

        @Test
        fun `should throw AggregateNotFoundException when behandlung does not exist`() {
            // Arrange
            val behandlungId = BehandlungId(UUID.fromString("f1e2d3c4-b5a6-9870-1234-567890fedcba"))

            every { behandlungService.deleteBehandlung(behandlungId) } throws AggregateNotFoundException()

            // Act & Assert
            mockMvc
                .perform(MockMvcRequestBuilders.delete("/behandlungen/${behandlungId.id}"))
                .andExpect(MockMvcResultMatchers.status().isNotFound)

            verify { behandlungService.deleteBehandlung(behandlungId) }
        }
    }
}
