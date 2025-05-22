package de.keller.physioai

import org.junit.jupiter.api.Test
import org.springframework.modulith.core.ApplicationModules

class PhysioAiApplicationTest {
    @Test
    fun `verify architecture`() {
        val modules = ApplicationModules.of(PhysioAiApplication::class.java)

        modules.forEach { println(it) }

        modules.verify()
    }
}
