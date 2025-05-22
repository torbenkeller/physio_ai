package de.keller.physioai.patienten

import java.time.LocalDate

interface PatientenRepository {
    fun findById(id: PatientId): Patient?

    fun findPatientByGeburtstag(geburtstag: LocalDate): List<Patient>
}
