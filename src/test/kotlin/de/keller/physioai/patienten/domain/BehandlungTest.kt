package de.keller.physioai.patienten.domain

import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.RezeptId
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import java.time.LocalDateTime
import kotlin.test.assertEquals
import kotlin.test.assertNotNull
import kotlin.test.assertNull

class BehandlungTest {
    @Test
    fun `should create behandlung without rezeptId`() {
        // Given - behandlung data without rezeptId
        val patientId = PatientId.generate()
        val startZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
        val endZeit = LocalDateTime.of(2024, 1, 15, 11, 0)

        // When - creating behandlung
        // This will fail because Behandlung class doesn't exist in patienten.domain yet
        val behandlung = Behandlung.createNew(
            patientId = patientId,
            startZeit = startZeit,
            endZeit = endZeit,
            rezeptId = null,
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
        val patientId = PatientId.generate()
        val rezeptId = RezeptId.generate()
        val startZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
        val endZeit = LocalDateTime.of(2024, 1, 15, 11, 0)

        // When - creating behandlung
        // This will fail because Behandlung class doesn't exist in patienten.domain yet
        val behandlung = Behandlung.createNew(
            patientId = patientId,
            startZeit = startZeit,
            endZeit = endZeit,
            rezeptId = rezeptId,
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
        val patientId = PatientId.generate()
        val startZeit = LocalDateTime.of(2024, 1, 15, 11, 0)
        val endZeit = LocalDateTime.of(2024, 1, 15, 10, 0) // before start time

        // When/Then - creating behandlung should throw exception
        // This will fail because Behandlung class doesn't exist and validation doesn't exist yet
        assertThrows<IllegalArgumentException> {
            Behandlung.createNew(
                patientId = patientId,
                startZeit = startZeit,
                endZeit = endZeit,
                rezeptId = null,
            )
        }
    }
}
