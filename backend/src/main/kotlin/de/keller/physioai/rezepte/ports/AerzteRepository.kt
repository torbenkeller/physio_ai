package de.keller.physioai.rezepte.ports

import de.keller.physioai.rezepte.domain.Arzt
import de.keller.physioai.rezepte.domain.ArztId
import org.jmolecules.architecture.hexagonal.SecondaryPort

@SecondaryPort
interface AerzteRepository {
    fun findById(id: ArztId): Arzt?

    fun findAllByIdIn(ids: Collection<ArztId>): List<Arzt>
}
