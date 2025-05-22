package de.keller.physioai.patienten

import org.springframework.modulith.ApplicationModule
import org.springframework.modulith.NamedInterface
import org.springframework.modulith.PackageInfo

@ApplicationModule(allowedDependencies = ["rezepte", "shared"])
@PackageInfo
@NamedInterface("patienten")
class PatientenModule
