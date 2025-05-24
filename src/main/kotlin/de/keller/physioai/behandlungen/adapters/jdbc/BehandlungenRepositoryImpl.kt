package de.keller.physioai.behandlungen.adapters.jdbc

import de.keller.physioai.behandlungen.domain.BehandlungAggregate
import de.keller.physioai.behandlungen.ports.BehandlungenRepository
import de.keller.physioai.shared.BehandlungId
import org.jmolecules.architecture.hexagonal.SecondaryAdapter
import org.springframework.data.jdbc.repository.query.Modifying
import org.springframework.data.repository.Repository
import org.springframework.transaction.annotation.Transactional

@SecondaryAdapter
@org.springframework.stereotype.Repository
@org.jmolecules.ddd.annotation.Repository
@Transactional(readOnly = true)
interface BehandlungenRepositoryImpl :
    BehandlungenRepository,
    Repository<BehandlungAggregate, BehandlungId> {
    @Modifying
    @Transactional
    override fun delete(behandlung: BehandlungAggregate)

    @Modifying
    @Transactional
    override fun save(behandlung: BehandlungAggregate): BehandlungAggregate
}
