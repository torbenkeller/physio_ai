package de.keller.physioai.patienten.domain

import de.keller.physioai.shared.RezeptId
import org.junit.jupiter.api.Test
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class PatientAggregateTest {
    @Test
    fun `should create patient with empty behandlungen list`() {
        // Given - patient data without behandlungen
        val patient = PatientAggregate.create(
            titel = "Dr.",
            vorname = "Max",
            nachname = "Mustermann",
            strasse = "Musterstraße",
            hausnummer = "1",
            plz = "12345",
            stadt = "Musterstadt",
            telMobil = "0123456789",
            telFestnetz = "0987654321",
            email = "max@example.com",
            geburtstag = LocalDate.of(1990, 1, 1),
        )

        // Then - patient should have empty behandlungen list
        // This will fail because PatientAggregate doesn't have behandlungen property yet
        assertTrue(patient.behandlungen.isEmpty())
    }

    @Test
    fun `should add behandlung to patient`() {
        // Given - existing patient
        val patient = PatientAggregate.create(
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
        )

        val startZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
        val endZeit = LocalDateTime.of(2024, 1, 15, 11, 0)
        val rezeptId = RezeptId.generate()

        // When - adding a behandlung
        // This will fail because addBehandlung method doesn't exist yet
        val updatedPatient = patient.addBehandlung(
            startZeit = startZeit,
            endZeit = endZeit,
            rezeptId = rezeptId,
        )

        // Then - patient should have one behandlung
        assertEquals(1, updatedPatient.behandlungen.size)
        val behandlung = updatedPatient.behandlungen.first()
        assertEquals(startZeit, behandlung.startZeit)
        assertEquals(endZeit, behandlung.endZeit)
        assertEquals(rezeptId, behandlung.rezeptId)
    }

    @Test
    fun `should add behandlung without rezeptId to patient`() {
        // Given - existing patient
        val patient = PatientAggregate.create(
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
        )

        val startZeit = LocalDateTime.of(2024, 1, 15, 10, 0)
        val endZeit = LocalDateTime.of(2024, 1, 15, 11, 0)

        // When - adding a behandlung without rezeptId
        // This will fail because addBehandlung method doesn't exist yet
        val updatedPatient = patient.addBehandlung(
            startZeit = startZeit,
            endZeit = endZeit,
            rezeptId = null,
        )

        // Then - patient should have one behandlung with null rezeptId
        assertEquals(1, updatedPatient.behandlungen.size)
        val behandlung = updatedPatient.behandlungen.first()
        assertEquals(startZeit, behandlung.startZeit)
        assertEquals(endZeit, behandlung.endZeit)
        assertEquals(null, behandlung.rezeptId)
    }

    @Test
    fun `should update behandlung in patient`() {
        // Given - patient with existing behandlung
        val patient = PatientAggregate
            .create(
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
            ).addBehandlung(
                startZeit = LocalDateTime.of(2024, 1, 15, 10, 0),
                endZeit = LocalDateTime.of(2024, 1, 15, 11, 0),
                rezeptId = null,
            )

        val behandlungId = patient.behandlungen.first().id
        val newStartZeit = LocalDateTime.of(2024, 1, 15, 14, 0)
        val newEndZeit = LocalDateTime.of(2024, 1, 15, 15, 0)
        val newRezeptId = RezeptId.generate()

        // When - updating the behandlung
        // This will fail because updateBehandlung method doesn't exist yet
        val updatedPatient = patient.updateBehandlung(
            behandlungId = behandlungId,
            startZeit = newStartZeit,
            endZeit = newEndZeit,
            rezeptId = newRezeptId,
        )

        // Then - behandlung should be updated
        assertEquals(1, updatedPatient.behandlungen.size)
        val behandlung = updatedPatient.behandlungen.first()
        assertEquals(newStartZeit, behandlung.startZeit)
        assertEquals(newEndZeit, behandlung.endZeit)
        assertEquals(newRezeptId, behandlung.rezeptId)
    }

    @Test
    fun `should remove behandlung from patient`() {
        // Given - patient with existing behandlung
        val patient = PatientAggregate
            .create(
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
            ).addBehandlung(
                startZeit = LocalDateTime.of(2024, 1, 15, 10, 0),
                endZeit = LocalDateTime.of(2024, 1, 15, 11, 0),
                rezeptId = null,
            )

        val behandlungId = patient.behandlungen.first().id

        // When - removing the behandlung
        // This will fail because removeBehandlung method doesn't exist yet
        val updatedPatient = patient.removeBehandlung(behandlungId)

        // Then - patient should have no behandlungen
        assertTrue(updatedPatient.behandlungen.isEmpty())
    }
}
