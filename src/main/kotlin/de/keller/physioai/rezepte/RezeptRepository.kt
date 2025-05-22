package de.keller.physioai.rezepte

import de.keller.physioai.rezepte.domain.Rezept

interface RezeptRepository {
    fun findAll(): List<Rezept>

    fun findById(rezeptId: RezeptId): Rezept?

    fun deleteById(rezeptId: RezeptId)

    fun save(rezept: Rezept): Rezept
}
