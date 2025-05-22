package de.keller.physioai.rezepte.ports

import de.keller.physioai.rezepte.domain.Behandlungsart
import de.keller.physioai.rezepte.domain.BehandlungsartId

interface BehandlungsartenRepository {
    fun findAllByNameIn(names: Collection<String>): List<Behandlungsart>

    fun findAllByIdIn(ids: Collection<BehandlungsartId>): List<Behandlungsart>

    fun findAll(): List<Behandlungsart>
}
