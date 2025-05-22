package de.keller.physioai.rezepte.adapters.jdbc

import de.keller.physioai.rezepte.domain.Behandlungsart
import de.keller.physioai.rezepte.domain.BehandlungsartId
import de.keller.physioai.rezepte.ports.BehandlungsartenRepository
import org.springframework.stereotype.Repository
import org.springframework.transaction.annotation.Transactional

@Transactional(readOnly = true)
@Repository
interface BehandlungsartenRepositoryImpl :
    org.springframework.data.repository.Repository<Behandlungsart, BehandlungsartId>,
    BehandlungsartenRepository
