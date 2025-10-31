package de.keller.physioai.rezepte.adapters.jdbc

import de.keller.physioai.rezepte.domain.Arzt
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

@Component
@Transactional(readOnly = true)
interface AerzteDAO : org.springframework.data.repository.Repository<Arzt, UUID> {
    fun findById(id: UUID): Arzt?

    fun findAllByIdIn(ids: Collection<UUID>): List<Arzt>
}
