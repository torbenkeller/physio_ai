package de.keller.physioai.rezepte.adapters.jdbc

import de.keller.physioai.rezepte.domain.Arzt
import de.keller.physioai.rezepte.domain.ArztId
import de.keller.physioai.rezepte.ports.AerzteRepository
import org.springframework.stereotype.Repository

@Repository
interface AerzteRepositoryImpl :
    org.springframework.data.repository.Repository<Arzt, ArztId>,
    AerzteRepository {
    override fun findById(id: ArztId): Arzt?

    override fun findAllByIdIn(ids: Collection<ArztId>): List<Arzt>
}
