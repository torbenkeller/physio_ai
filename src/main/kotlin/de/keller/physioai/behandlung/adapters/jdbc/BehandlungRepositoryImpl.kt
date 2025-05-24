package de.keller.physioai.behandlung.adapters.jdbc

import de.keller.physioai.behandlung.domain.BehandlungAggregate
import de.keller.physioai.behandlung.ports.BehandlungRepository
import de.keller.physioai.shared.BehandlungId
import org.jmolecules.architecture.hexagonal.SecondaryAdapter
import org.springframework.data.jdbc.repository.query.Modifying
import org.springframework.data.repository.Repository
import org.springframework.transaction.annotation.Transactional

@SecondaryAdapter
@org.springframework.stereotype.Repository
@org.jmolecules.ddd.annotation.Repository
@Transactional(readOnly = true)
interface BehandlungRepositoryImpl :
    BehandlungRepository,
    Repository<BehandlungAggregate, BehandlungId> {
    @Modifying
    @Transactional
    override fun delete(behandlung: BehandlungAggregate)

    @Modifying
    @Transactional
    override fun save(behandlung: BehandlungAggregate): BehandlungAggregate
}
