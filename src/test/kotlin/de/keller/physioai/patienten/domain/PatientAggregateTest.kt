package de.keller.physioai.patienten.domain

import org.junit.jupiter.api.Test
import java.time.LocalDate
import kotlin.test.assertEquals
import kotlin.test.assertNotNull

class PatientAggregateTest {
    @Test
    fun `should create patient with all data`() {
        // Given - patient data
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

        // Then - patient should be created with all data
        assertNotNull(patient.id)
        assertEquals("Dr.", patient.titel)
        assertEquals("Max", patient.vorname)
        assertEquals("Mustermann", patient.nachname)
        assertEquals("Musterstraße", patient.strasse)
        assertEquals("1", patient.hausnummer)
        assertEquals("12345", patient.plz)
        assertEquals("Musterstadt", patient.stadt)
        assertEquals("0123456789", patient.telMobil)
        assertEquals("0987654321", patient.telFestnetz)
        assertEquals("max@example.com", patient.email)
        assertEquals(LocalDate.of(1990, 1, 1), patient.geburtstag)
    }

    @Test
    fun `should update patient data`() {
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

        // When - updating patient data
        val updatedPatient = patient.update(
            titel = "Dr.",
            vorname = "Max",
            nachname = "Mustermann",
            strasse = "Neue Straße",
            hausnummer = "42",
            plz = "54321",
            stadt = "Neue Stadt",
            telMobil = "9876543210",
            telFestnetz = "1234567890",
            email = "new@example.com",
            geburtstag = LocalDate.of(1985, 5, 15),
        )

        // Then - patient data should be updated
        assertEquals(patient.id, updatedPatient.id) // ID should remain the same
        assertEquals("Dr.", updatedPatient.titel)
        assertEquals("Max", updatedPatient.vorname)
        assertEquals("Mustermann", updatedPatient.nachname)
        assertEquals("Neue Straße", updatedPatient.strasse)
        assertEquals("42", updatedPatient.hausnummer)
        assertEquals("54321", updatedPatient.plz)
        assertEquals("Neue Stadt", updatedPatient.stadt)
        assertEquals("9876543210", updatedPatient.telMobil)
        assertEquals("1234567890", updatedPatient.telFestnetz)
        assertEquals("new@example.com", updatedPatient.email)
        assertEquals(LocalDate.of(1985, 5, 15), updatedPatient.geburtstag)
    }
}
