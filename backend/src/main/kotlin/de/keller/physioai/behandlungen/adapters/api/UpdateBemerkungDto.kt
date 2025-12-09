package de.keller.physioai.behandlungen.adapters.api

import jakarta.validation.constraints.Size

data class UpdateBemerkungDto(
    @field:Size(max = 5000, message = "Bemerkung darf maximal 5000 Zeichen enthalten")
    val bemerkung: String?,
)
