package de.keller.physioai.patienten

import de.keller.physioai.shared.PatientId
import java.time.LocalDate

interface PatientenRepository {
    fun findAllByIdIn(ids: Collection<PatientId>): List<Patient>

    fun findById(id: PatientId): Patient?

    fun findPatientByGeburtstag(geburtstag: LocalDate): List<Patient>
}
