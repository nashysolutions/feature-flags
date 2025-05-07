//
//  FeatureRegistry.swift
//  feature-flags
//
//  Created by Robert Nash on 29/12/2024.
//

import Foundation
import Versioning

/// A class responsible for managing the registration and availability of feature flags.
///
/// The `FeatureRegistry` maintains a collection of feature flags and checks their availability based
/// on the current target version.
final class FeatureRegistry {
    
    /// The current version of a target, used to evaluate feature availability.
    private let currentVersion: SemanticVersion
    
    /// A dictionary that stores registered feature flags, where the key is the feature name
    /// and the value is the corresponding `FeatureFlag` object.
    private var featureFlags: [String: FeatureFlag] = [:]
    
    /// Initialises a new instance of `FeatureRegistry`.
    ///
    /// - Parameter currentVersion: The current version of the application.
    init(currentVersion: SemanticVersion) {
        self.currentVersion = currentVersion
    }
    
    /// Registers a new feature flag.
    ///
    /// - Parameter feature: The feature flag to be registered.
    /// - Note: If a feature with the same name is already registered, it will be replaced.
    func registerFeature(_ feature: FeatureFlag) {
        featureFlags[feature.name] = feature
    }
    
    /// Checks if a specific feature is available.
    ///
    /// - Parameter featureName: The name of the feature to check.
    /// - Returns: A Boolean value indicating whether the feature is available.
    /// - Note: A feature is considered available if it exists in the registry and its
    ///         `minimumVersion` is less than or equal to the current application version.
    func isFeatureAvailable(_ featureName: String) -> Bool {
        guard let feature = featureFlags[featureName] else {
            return false
        }
        return currentVersion >= feature.minimumVersion
    }
    
    /// Retrieves all registered feature flags.
    ///
    /// - Returns: An array containing all `FeatureFlag` objects currently in the registry.
    func getAllFeatures() -> [FeatureFlag] {
        Array(featureFlags.values)
    }
}
