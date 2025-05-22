package de.keller.physioai

import org.junit.jupiter.api.Test
import org.springframework.modulith.core.ApplicationModules
import org.springframework.modulith.docs.Documenter

class PhysioAiApplicationTest {
    @Test
    fun `document architecture`() {
        val modules = ApplicationModules.of(PhysioAiApplication::class.java)

        modules.forEach { println(it) }

        // Generate documentation for the modules
        Documenter(modules)
            .writeDocumentation()

        modules.verify()
    }
}
