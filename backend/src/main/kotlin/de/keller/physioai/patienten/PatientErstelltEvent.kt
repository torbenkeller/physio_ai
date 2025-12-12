package de.keller.physioai.patienten

import de.keller.physioai.shared.PatientId

data class PatientErstelltEvent(
    val patientId: PatientId,
)
