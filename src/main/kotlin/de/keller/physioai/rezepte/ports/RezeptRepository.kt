package de.keller.physioai.rezepte.ports

import de.keller.physioai.rezepte.domain.Rezept
import de.keller.physioai.shared.RezeptId
import org.jmolecules.architecture.hexagonal.SecondaryPort

@SecondaryPort
interface RezeptRepository {
    fun findAll(): List<Rezept>

    fun findById(rezeptId: RezeptId): Rezept?

    fun deleteById(rezeptId: RezeptId)

    fun save(rezept: Rezept): Rezept
}
