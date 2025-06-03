package de.keller.physioai.rezepte.adapters.jdbc

import de.keller.physioai.rezepte.domain.Behandlungsart
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

@Component
@Transactional(readOnly = true)
interface BehandlungsartenDAO : org.springframework.data.repository.Repository<Behandlungsart, UUID> {
    fun findAllByNameIn(names: Collection<String>): List<Behandlungsart>

    fun findAllByIdIn(ids: Collection<UUID>): List<Behandlungsart>

    fun findAll(): List<Behandlungsart>
}
