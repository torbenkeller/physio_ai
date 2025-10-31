package de.keller.physioai.rezepte.adapters.api

import de.keller.physioai.rezepte.ports.RezeptService

data class EingelesenesRezeptDto(
    val existingPatient: PatientDto?,
    val patient: RezeptService.EingelesenerPatientDto,
    val rezept: RezeptService.EingelesenesRezeptDto,
)
