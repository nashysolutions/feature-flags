//
//  UserOverrideManager.swift
//  feature-flags
//
//  Created by Robert Nash on 29/12/2024.
//

import Foundation

@MainActor
final class UserOverrideManager {
    
    /// A dictionary that stores feature overrides, where the key is the feature name and the value is a Boolean
    /// indicating whether the feature is enabled (`true`) or disabled (`false`).
    private(set) var overrides: [String: Bool] = [:]
    
    /// Sets an override for a specific feature's availability.
    ///
    /// - Parameters:
    ///   - featureName: The name of the feature to override.
    ///   - isEnabled: A Boolean value indicating whether the feature should be enabled (`true`) or disabled (`false`).
    func setOverride(for featureName: String, isEnabled: Bool) {
        overrides[featureName] = isEnabled
    }
    
    /// Clears the override for a specific feature.
    ///
    /// - Parameter featureName: The name of the feature whose override should be removed.
    func clearOverride(for featureName: String) {
        overrides.removeValue(forKey: featureName)
    }
    
    /// Retrieves the override status for a specific feature, if it exists.
    ///
    /// - Parameter featureName: The name of the feature to query.
    /// - Returns: An optional Boolean value indicating the override status:
    ///   - `true`: The feature is explicitly enabled.
    ///   - `false`: The feature is explicitly disabled.
    ///   - `nil`: No override exists for the feature.
    func getOverride(for featureName: String) -> Bool? {
        overrides[featureName]
    }
}
