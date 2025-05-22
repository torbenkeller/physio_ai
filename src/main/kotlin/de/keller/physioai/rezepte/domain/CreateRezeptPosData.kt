package de.keller.physioai.rezepte.domain

import java.util.UUID

data class CreateRezeptPosData(
    val behandlungsartId: BehandlungsartId,
    val behandlungsartName: String,
    val behandlungsartPreis: Double,
    val anzahl: Int,
) {
    fun toPosition(): RezeptPos =
        RezeptPos(
            id = UUID.randomUUID(),
            behandlungsartId = behandlungsartId,
            anzahl = anzahl,
            einzelpreis = behandlungsartPreis,
            preisGesamt = behandlungsartPreis * anzahl,
            behandlungsartName = behandlungsartName,
        )
}
