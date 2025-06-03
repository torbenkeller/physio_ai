package de.keller.physioai.rezepte.adapters.jdbc

import de.keller.physioai.rezepte.domain.Arzt
import de.keller.physioai.rezepte.domain.ArztId
import de.keller.physioai.rezepte.ports.AerzteRepository
import org.jmolecules.architecture.hexagonal.SecondaryAdapter

@SecondaryAdapter
@org.springframework.stereotype.Repository
@org.jmolecules.ddd.annotation.Repository
class AerzteRepositoryImpl(
    val dao: AerzteDAO,
) : AerzteRepository {
    override fun findById(id: ArztId): Arzt? = dao.findById(id.id)

    override fun findAllByIdIn(ids: Collection<ArztId>): List<Arzt> = dao.findAllByIdIn(ids.map { it.id })
}
