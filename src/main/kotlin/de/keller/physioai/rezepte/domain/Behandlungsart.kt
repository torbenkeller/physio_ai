package de.keller.physioai.rezepte.domain

import org.springframework.data.annotation.Id
import org.springframework.data.annotation.Version
import org.springframework.data.relational.core.mapping.Table

@Table("behandlungsarten")
data class Behandlungsart(
    @Id
    val id: BehandlungsartId,
    val name: String,
    val preis: Double,
    @Version
    val version: Int = 0,
)
