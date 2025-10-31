package de.keller.physioai.rezepte.domain

import org.jmolecules.ddd.annotation.Entity
import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table
import java.util.UUID

@Entity
@Table("rezept_pos")
data class RezeptPos(
    @Id
    val id: UUID,
    val behandlungsartId: BehandlungsartId,
    val anzahl: Int,
    val einzelpreis: Double,
    val preisGesamt: Double,
    val behandlungsartName: String,
)
