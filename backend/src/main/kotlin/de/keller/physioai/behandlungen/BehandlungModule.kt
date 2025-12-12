package de.keller.physioai.behandlungen

import org.springframework.modulith.ApplicationModule
import org.springframework.modulith.PackageInfo

/**
 * Behandlung module for managing treatment sessions.
 * Exposes the domain package for event listeners in other modules.
 */
@ApplicationModule(
    allowedDependencies = ["shared", "patienten"],
)
@PackageInfo
class BehandlungModule
