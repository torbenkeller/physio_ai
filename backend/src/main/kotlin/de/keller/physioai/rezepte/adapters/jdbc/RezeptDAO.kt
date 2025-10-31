package de.keller.physioai.rezepte.adapters.jdbc

import de.keller.physioai.rezepte.domain.Rezept
import org.springframework.data.jdbc.repository.query.Modifying
import org.springframework.stereotype.Repository
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

@Transactional(readOnly = true)
@Repository
interface RezeptDAO : org.springframework.data.repository.Repository<Rezept, UUID> {
    fun findAll(): List<Rezept>

    fun findById(rezeptId: UUID): Rezept?

    @Transactional(readOnly = false)
    @Modifying
    fun deleteById(rezeptId: UUID)

    @Transactional(readOnly = false)
    @Modifying
    fun save(rezept: Rezept): Rezept
}
