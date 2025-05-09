package de.keller.physioai

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class PhysioAiApplication

fun main(args: Array<String>) {
    runApplication<PhysioAiApplication>(*args)
}
