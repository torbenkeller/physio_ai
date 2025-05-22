package de.keller.physioai.profile

import org.springframework.modulith.ApplicationModule
import org.springframework.modulith.NamedInterface
import org.springframework.modulith.PackageInfo

@ApplicationModule(allowedDependencies = ["shared"])
@PackageInfo
@NamedInterface("profile")
class ProfileModule
