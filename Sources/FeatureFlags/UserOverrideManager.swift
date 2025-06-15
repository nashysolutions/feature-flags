//
//  UserOverrideManager.swift
//  feature-flags
//
//  Created by Robert Nash on 29/12/2024.
//

import Foundation

/// A manager responsible for handling user-controlled overrides of feature availability.
///
/// `UserOverrideManager` allows developers, testers, or end users to explicitly enable or disable
/// specific feature flags, overriding the default activation rules based on versioning.
@MainActor
final class UserOverrideManager {
    
    /// A dictionary that stores feature overrides by name.
    ///
    /// Each entry represents the user's explicit preference for whether a feature should be enabled (`true`)
    /// or disabled (`false`), regardless of its default availability.
    private(set) var overrides: [String: Bool] = [:]
    
    /// Sets a user override for a specific feature's availability.
    ///
    /// - Parameters:
    ///   - featureName: The unique name of the feature to override.
    ///   - isEnabled: A Boolean value indicating whether the feature should be explicitly enabled (`true`)
    ///     or disabled (`false`).
    func setOverride(for featureName: String, isEnabled: Bool) {
        overrides[featureName] = isEnabled
    }
    
    /// Clears any user-defined override for the specified feature.
    ///
    /// - Parameter featureName: The name of the feature whose override should be removed.
    /// If no override exists, this operation has no effect.
    func clearOverride(for featureName: String) {
        overrides.removeValue(forKey: featureName)
    }
    
    /// Retrieves the override status for a given feature, if one exists.
    ///
    /// - Parameter featureName: The name of the feature to query.
    /// - Returns: An optional Boolean indicating the override state:
    ///   - `true`: The feature has been explicitly enabled.
    ///   - `false`: The feature has been explicitly disabled.
    ///   - `nil`: No override is currently set for this feature.
    func getOverride(for featureName: String) -> Bool? {
        overrides[featureName]
    }
}
