package de.keller.physioai.rezepte

import org.springframework.modulith.ApplicationModule
import org.springframework.modulith.NamedInterface
import org.springframework.modulith.PackageInfo

@ApplicationModule(allowedDependencies = ["patienten", "shared"])
@PackageInfo
@NamedInterface("rezepte")
class RezepteModule
