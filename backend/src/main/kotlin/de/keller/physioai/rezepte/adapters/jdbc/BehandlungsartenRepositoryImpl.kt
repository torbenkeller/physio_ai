package de.keller.physioai.rezepte.adapters.jdbc

import de.keller.physioai.rezepte.domain.Behandlungsart
import de.keller.physioai.rezepte.ports.BehandlungsartenRepository
import de.keller.physioai.shared.BehandlungsartId
import org.jmolecules.architecture.hexagonal.SecondaryAdapter

@SecondaryAdapter
@org.springframework.stereotype.Repository
@org.jmolecules.ddd.annotation.Repository
class BehandlungsartenRepositoryImpl(
    val dao: BehandlungsartenDAO,
) : BehandlungsartenRepository {
    override fun findAllByNameIn(names: Collection<String>): List<Behandlungsart> = dao.findAllByNameIn(names)

    override fun findAllByIdIn(ids: Collection<BehandlungsartId>): List<Behandlungsart> = dao.findAllByIdIn(ids = ids.map { it.id })

    override fun findAll(): List<Behandlungsart> = dao.findAll()
}
