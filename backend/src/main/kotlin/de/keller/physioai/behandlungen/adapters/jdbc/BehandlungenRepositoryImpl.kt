package de.keller.physioai.behandlungen.adapters.jdbc

import de.keller.physioai.behandlungen.domain.BehandlungAggregate
import de.keller.physioai.behandlungen.ports.BehandlungenRepository
import de.keller.physioai.shared.BehandlungId
import org.jmolecules.architecture.hexagonal.SecondaryAdapter
import org.springframework.data.jdbc.repository.query.Modifying
import org.springframework.data.jdbc.repository.query.Query
import org.springframework.data.repository.Repository
import org.springframework.data.repository.query.Param
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime

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

    @Query("SELECT * FROM behandlungen WHERE start_zeit >= :startDateTime AND start_zeit <= :endDateTime ORDER BY start_zeit")
    override fun findAllByDateRange(
        @Param("startDateTime") startDateTime: LocalDateTime,
        @Param("endDateTime") endDateTime: LocalDateTime,
    ): List<BehandlungAggregate>
}
