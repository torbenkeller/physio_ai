package de.keller.physio_ai.rezepte

import org.springframework.data.relational.core.mapping.Table
import java.util.*


@Table("rezept_pos")
data class RezeptPos(
    val id: UUID,
    val index: Long,
    val rezeptId: RezeptId,
    val behandlungsartId: BehandlungsartId,
    val anzahl: Long,
) {
}
