package de.keller.physioai.rezepte.domain

import org.jmolecules.ddd.annotation.AggregateRoot
import org.springframework.data.annotation.Id
import org.springframework.data.annotation.Version
import org.springframework.data.relational.core.mapping.Table

@AggregateRoot
@Table("aerzte")
data class Arzt(
    @Id
    val id: ArztId,
    val name: String,
    @Version
    val version: Int = 0,
)
