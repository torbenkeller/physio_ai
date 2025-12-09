package de.keller.physioai.behandlungen.domain

import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.RezeptId
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import java.time.LocalDateTime
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertNotNull
import kotlin.test.assertNull

class BehandlungAggregateTest {
    @Test
    fun `should create behandlung without rezeptId`() {
        // Given - behandlung data without rezeptId
        val patientId = PatientId(UUID.randomUUID())
        val startZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
        val endZeit = LocalDateTime.of(2024, 1, 15, 11, 0)

        // When - creating behandlung
        val behandlung = BehandlungAggregate.create(
            patientId = patientId,
            startZeit = startZeit,
            endZeit = endZeit,
            rezeptId = null,
            behandlungsartId = null,
        )

        // Then - behandlung should be created with null rezeptId
        assertNotNull(behandlung.id)
        assertEquals(patientId, behandlung.patientId)
        assertEquals(startZeit, behandlung.startZeit)
        assertEquals(endZeit, behandlung.endZeit)
        assertNull(behandlung.rezeptId)
    }

    @Test
    fun `should create behandlung with rezeptId`() {
        // Given - behandlung data with rezeptId
        val patientId = PatientId(UUID.randomUUID())
        val rezeptId = RezeptId(UUID.randomUUID())
        val startZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
        val endZeit = LocalDateTime.of(2024, 1, 15, 11, 0)

        // When - creating behandlung
        val behandlung = BehandlungAggregate.Companion.create(
            patientId = patientId,
            startZeit = startZeit,
            endZeit = endZeit,
            rezeptId = rezeptId,
            behandlungsartId = null,
        )

        // Then - behandlung should be created with rezeptId
        assertNotNull(behandlung.id)
        assertEquals(patientId, behandlung.patientId)
        assertEquals(startZeit, behandlung.startZeit)
        assertEquals(endZeit, behandlung.endZeit)
        assertEquals(rezeptId, behandlung.rezeptId)
    }

    @Test
    fun `should throw exception when start time is after end time`() {
        // Given - invalid time range
        val patientId = PatientId(UUID.randomUUID())
        val startZeit = LocalDateTime.of(2024, 1, 15, 11, 0)
        val endZeit = LocalDateTime.of(2024, 1, 15, 10, 0) // before start time

        // When/Then - creating behandlung should throw exception
        assertThrows<IllegalArgumentException> {
            BehandlungAggregate.create(
                patientId = patientId,
                startZeit = startZeit,
                endZeit = endZeit,
                rezeptId = null,
                behandlungsartId = null,
            )
        }
    }

    @Test
    fun `should update behandlung successfully`() {
        // Given - existing behandlung
        val patientId = PatientId(UUID.randomUUID())
        val originalStartZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
        val originalEndZeit = LocalDateTime.of(2024, 1, 15, 11, 0)
        val behandlung = BehandlungAggregate.create(
            patientId = patientId,
            startZeit = originalStartZeit,
            endZeit = originalEndZeit,
            rezeptId = null,
            behandlungsartId = null,
        )

        // When - updating behandlung
        val newStartZeit = LocalDateTime.of(2024, 1, 15, 14, 0)
        val newEndZeit = LocalDateTime.of(2024, 1, 15, 15, 0)
        val newRezeptId = RezeptId(UUID.randomUUID())
        val newBemerkung = "Test Bemerkung"
        val updatedBehandlung = behandlung.update(
            startZeit = newStartZeit,
            endZeit = newEndZeit,
            rezeptId = newRezeptId,
            behandlungsartId = null,
            bemerkung = newBemerkung,
        )

        // Then - behandlung should be updated
        assertEquals(behandlung.id, updatedBehandlung.id)
        assertEquals(patientId, updatedBehandlung.patientId)
        assertEquals(newStartZeit, updatedBehandlung.startZeit)
        assertEquals(newEndZeit, updatedBehandlung.endZeit)
        assertEquals(newRezeptId, updatedBehandlung.rezeptId)
        assertEquals(newBemerkung, updatedBehandlung.bemerkung)
    }

    @Test
    fun `should throw exception when updating with invalid time range`() {
        // Given - existing behandlung
        val patientId = PatientId(UUID.randomUUID())
        val behandlung = BehandlungAggregate.create(
            patientId = patientId,
            startZeit = LocalDateTime.of(2024, 1, 15, 10, 0),
            endZeit = LocalDateTime.of(2024, 1, 15, 11, 0),
            rezeptId = null,
            behandlungsartId = null,
        )

        // When/Then - updating with invalid time range should throw exception
        val invalidStartZeit = LocalDateTime.of(2024, 1, 15, 15, 0)
        val invalidEndZeit = LocalDateTime.of(2024, 1, 15, 14, 0) // before start time

        assertThrows<IllegalArgumentException> {
            behandlung.update(
                startZeit = invalidStartZeit,
                endZeit = invalidEndZeit,
                rezeptId = null,
                behandlungsartId = null,
                bemerkung = null,
            )
        }
    }

    @Test
    fun `should update bemerkung only`() {
        // Given - existing behandlung without bemerkung
        val patientId = PatientId(UUID.randomUUID())
        val behandlung = BehandlungAggregate.create(
            patientId = patientId,
            startZeit = LocalDateTime.of(2024, 1, 15, 10, 0),
            endZeit = LocalDateTime.of(2024, 1, 15, 11, 0),
            rezeptId = null,
            behandlungsartId = null,
        )

        // When - updating only bemerkung
        val newBemerkung = "Neue Bemerkung"
        val updatedBehandlung = behandlung.updateBemerkung(newBemerkung)

        // Then - only bemerkung should be changed
        assertEquals(behandlung.id, updatedBehandlung.id)
        assertEquals(behandlung.startZeit, updatedBehandlung.startZeit)
        assertEquals(behandlung.endZeit, updatedBehandlung.endZeit)
        assertEquals(newBemerkung, updatedBehandlung.bemerkung)
    }

    @Test
    fun `should create behandlung with bemerkung`() {
        // Given - behandlung data with bemerkung
        val patientId = PatientId(UUID.randomUUID())
        val startZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
        val endZeit = LocalDateTime.of(2024, 1, 15, 11, 0)
        val bemerkung = "Test Bemerkung"

        // When - creating behandlung with bemerkung
        val behandlung = BehandlungAggregate.create(
            patientId = patientId,
            startZeit = startZeit,
            endZeit = endZeit,
            rezeptId = null,
            behandlungsartId = null,
            bemerkung = bemerkung,
        )

        // Then - behandlung should have bemerkung
        assertEquals(bemerkung, behandlung.bemerkung)
    }

    @Test
    fun `should move behandlung to new time keeping duration`() {
        // Given - existing behandlung with 1 hour duration (10:00-11:00)
        val patientId = PatientId(UUID.randomUUID())
        val behandlung = BehandlungAggregate.create(
            patientId = patientId,
            startZeit = LocalDateTime.of(2024, 1, 15, 10, 0),
            endZeit = LocalDateTime.of(2024, 1, 15, 11, 0),
            rezeptId = null,
            behandlungsartId = null,
        )

        // When - moving behandlung to 14:00
        val neueStartZeit = LocalDateTime.of(2024, 1, 15, 14, 0)
        val verschobeneBehandlung = behandlung.verschiebe(neueStartZeit)

        // Then - behandlung should be moved with same duration (14:00-15:00)
        assertEquals(behandlung.id, verschobeneBehandlung.id)
        assertEquals(patientId, verschobeneBehandlung.patientId)
        assertEquals(neueStartZeit, verschobeneBehandlung.startZeit)
        assertEquals(LocalDateTime.of(2024, 1, 15, 15, 0), verschobeneBehandlung.endZeit)
        assertEquals(behandlung.rezeptId, verschobeneBehandlung.rezeptId)
    }
}
