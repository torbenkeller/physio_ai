package de.keller.physio_ai.rezepte

import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table
import java.util.*


@Table("rezept_pos")
data class RezeptPos(
    @Id
    val id: UUID,
    val index: Long,
    // In Spring Data JDBC, the parent reference should not be included in child entities
    // Spring JDBC handles this mapping internally
    val rezeptId: RezeptId,
    val behandlungsartId: BehandlungsartId,
    val anzahl: Long,
) {
}
