package de.keller.physioai.rezepte.adapters.jdbc

import de.keller.physioai.rezepte.domain.Rezept
import de.keller.physioai.rezepte.ports.RezeptRepository
import de.keller.physioai.shared.RezeptId
import org.jmolecules.architecture.hexagonal.SecondaryAdapter

@SecondaryAdapter
@org.springframework.stereotype.Repository
@org.jmolecules.ddd.annotation.Repository
class RezeptRepositoryImpl(
    val dao: RezeptDAO,
) : RezeptRepository {
    override fun findAll(): List<Rezept> = dao.findAll()

    override fun findById(rezeptId: RezeptId): Rezept? = dao.findById(rezeptId.id)

    override fun deleteById(rezeptId: RezeptId) = dao.deleteById(rezeptId.id)

    override fun save(rezept: Rezept): Rezept = dao.save(rezept)
}
