package de.keller.physioai.rezepte.adapters.rest

import de.keller.physioai.rezepte.ports.EingelesenerPatientDto
import de.keller.physioai.rezepte.ports.EingelesenesRezeptDto

data class EingelesenesRezeptDto(
    val existingPatient: PatientDto?,
    val patient: EingelesenerPatientDto,
    val rezept: EingelesenesRezeptDto,
)
