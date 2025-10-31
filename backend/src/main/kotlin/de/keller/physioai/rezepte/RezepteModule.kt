package de.keller.physioai.rezepte

import org.springframework.modulith.ApplicationModule
import org.springframework.modulith.PackageInfo

/**
 * Rezepte module for managing prescriptions.
 */
@ApplicationModule(allowedDependencies = ["patienten"])
@PackageInfo
class RezepteModule
