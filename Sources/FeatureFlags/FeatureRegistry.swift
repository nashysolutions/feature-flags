//
//  FeatureRegistry.swift
//  feature-flags
//
//  Created by Robert Nash on 29/12/2024.
//

import Foundation
import Versioning

/// A registry responsible for managing the registration and availability of feature flags.
///
/// `FeatureRegistry` stores all registered `FeatureFlag` instances and determines
/// their availability based on the current semantic version of the application.
/// It is used internally by `FeatureFlags` to evaluate which features should be enabled.
final class FeatureRegistry {
    
    /// The current version of the application or target.
    ///
    /// This value is compared against each feature's `minimumVersion` to determine availability.
    private let currentVersion: SemanticVersion
    
    /// A dictionary of registered feature flags, keyed by their unique names.
    ///
    /// If multiple flags are registered with the same name, the most recent one will overwrite the previous.
    private var featureFlags: [String: FeatureFlag] = [:]
    
    /// Creates a new `FeatureRegistry` instance.
    ///
    /// - Parameter currentVersion: The current semantic version of the app or runtime environment.
    init(currentVersion: SemanticVersion) {
        self.currentVersion = currentVersion
    }
    
    /// Registers a feature flag for availability tracking.
    ///
    /// - Parameter feature: The `FeatureFlag` to register.
    ///
    /// If a flag with the same name already exists, it will be overwritten.
    func registerFeature(_ feature: FeatureFlag) {
        featureFlags[feature.name] = feature
    }
    
    /// Checks whether a feature is available based on the current version.
    ///
    /// - Parameter featureName: The name of the feature to check.
    /// - Returns: `true` if the feature is registered and its `minimumVersion` is
    ///            less than or equal to the current version; otherwise, `false`.
    func isFeatureAvailable(_ featureName: String) -> Bool {
        guard let feature = featureFlags[featureName] else {
            return false
        }
        return currentVersion >= feature.minimumVersion
    }
    
    /// Returns all registered feature flags.
    ///
    /// - Returns: An array of all `FeatureFlag` instances currently in the registry.
    func getAllFeatures() -> [FeatureFlag] {
        Array(featureFlags.values)
    }
}
