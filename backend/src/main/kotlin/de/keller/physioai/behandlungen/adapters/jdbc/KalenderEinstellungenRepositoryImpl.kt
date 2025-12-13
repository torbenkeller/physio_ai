package de.keller.physioai.behandlungen.adapters.jdbc

import de.keller.physioai.behandlungen.domain.KalenderEinstellungen
import de.keller.physioai.behandlungen.ports.KalenderEinstellungenRepository
import de.keller.physioai.shared.KalenderEinstellungenId
import org.jmolecules.architecture.hexagonal.SecondaryAdapter
import org.springframework.data.jdbc.repository.query.Modifying
import org.springframework.data.jdbc.repository.query.Query
import org.springframework.data.repository.Repository
import org.springframework.transaction.annotation.Transactional

@SecondaryAdapter
@org.springframework.stereotype.Repository
@org.jmolecules.ddd.annotation.Repository
@Transactional(readOnly = true)
interface KalenderEinstellungenRepositoryImpl :
    KalenderEinstellungenRepository,
    Repository<KalenderEinstellungen, KalenderEinstellungenId> {
    @Transactional(readOnly = false)
    @Modifying
    override fun save(kalenderEinstellungen: KalenderEinstellungen): KalenderEinstellungen

    override fun findById(id: KalenderEinstellungenId): KalenderEinstellungen?

    @Query("SELECT * FROM kalender_einstellungen LIMIT 1")
    override fun findFirst(): KalenderEinstellungen?
}
