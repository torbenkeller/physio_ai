package de.keller.physioai.patientenakte

import org.springframework.modulith.ApplicationModule
import org.springframework.modulith.PackageInfo

/**
 * Patientenakte module for managing the chronological treatment history.
 * This module listens to BehandlungAggregate events and maintains its own
 * copy of treatment data for the patient's medical record.
 */
@ApplicationModule(
    allowedDependencies = ["shared", "behandlungen"],
)
@PackageInfo
class PatientenakteModule
