package de.keller.physioai.shared

import org.springframework.modulith.ApplicationModule
import org.springframework.modulith.NamedInterface
import org.springframework.modulith.PackageInfo

@ApplicationModule(allowedDependencies = ["patienten", "profile", "rezepte"], type = ApplicationModule.Type.OPEN)
@PackageInfo
@NamedInterface("shared")
class SharedModule
