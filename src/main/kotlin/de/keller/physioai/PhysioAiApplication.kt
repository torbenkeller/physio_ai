package de.keller.physioai

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.modulith.Modulithic

@Modulithic
@SpringBootApplication
class PhysioAiApplication

fun main(args: Array<String>) {
    runApplication<PhysioAiApplication>(*args)
}
