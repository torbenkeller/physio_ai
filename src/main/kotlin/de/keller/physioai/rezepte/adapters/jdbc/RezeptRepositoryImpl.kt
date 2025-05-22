package de.keller.physioai.rezepte.adapters.jdbc

import de.keller.physioai.rezepte.RezeptId
import de.keller.physioai.rezepte.domain.Rezept
import de.keller.physioai.rezepte.ports.RezeptRepository
import org.springframework.data.jdbc.repository.query.Modifying
import org.springframework.stereotype.Repository
import org.springframework.transaction.annotation.Transactional

@Transactional(readOnly = true)
@Repository
interface RezeptRepositoryImpl :
    org.springframework.data.repository.Repository<Rezept, RezeptId>,
    RezeptRepository {
    override fun findAll(): List<Rezept>

    override fun findById(rezeptId: RezeptId): Rezept?

    @Transactional(readOnly = false)
    @Modifying
    override fun deleteById(rezeptId: RezeptId)

    @Transactional(readOnly = false)
    @Modifying
    override fun save(rezept: Rezept): Rezept
}
