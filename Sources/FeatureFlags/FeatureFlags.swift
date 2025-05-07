//
//  FeatureFlags.swift
//  feature-flags
//
//  Created by Robert Nash on 28/12/2024.
//

import Foundation
import Combine
import Versioning

/// A class that manages the lifecycle and availability of feature flags of a target.
///
/// `FeatureFlags` is an observable class that integrates with Combine to notify subscribers of changes
/// to the list of enabled features. It provides functionality for:
/// - Registering feature flags.
/// - Determining the availability of features based on the app version.
/// - Allowing users to override feature availability.
///
/// ### User Overrides
/// User overrides enable explicit control over feature availability. For example:
/// - A feature that is normally disabled can be explicitly enabled by a user.
/// - Similarly, a feature that is enabled by default can be explicitly disabled.
/// Overrides are managed using the `setFeatureOverride` and `clearFeatureOverride` methods, and take precedence
/// over default availability rules defined in the registry.
@MainActor
public final class FeatureFlags: ObservableObject {
    
    /// A published property containing the list of currently enabled feature flags.
    /// Observers can use this property to react to changes in feature availability.
    @Published public private(set) var enabledFeatures: [FeatureFlag] = []

    /// The registry responsible for managing the lifecycle and availability of feature flags.
    private let registry: FeatureRegistry

    /// The manager responsible for handling user overrides of feature availability.
    private let userOverrideManager: UserOverrideManager

    /// Initializes a new instance of `FeatureFlags`.
    ///
    /// - Parameter currentVersion: The current version of the application, used to evaluate feature availability.
    public init(currentVersion: SemanticVersion) {
        self.registry = FeatureRegistry(currentVersion: currentVersion)
        self.userOverrideManager = UserOverrideManager()
        self.enabledFeatures = computeEnabledFeatures()
    }

    /// Registers a new feature flag with the registry.
    ///
    /// - Parameter feature: The feature flag to be registered.
    public func registerFeature(_ feature: FeatureFlag) {
        registry.registerFeature(feature)
        refreshEnabledFeatures()
    }

    /// Determines whether a specific feature is enabled, considering both the registry
    /// data and user overrides.
    ///
    /// - Parameter featureName: The name of the feature to check.
    /// - Returns: A Boolean value indicating whether the feature is enabled.
    public func isFeatureEnabled(_ featureName: String) -> Bool {
        if let override = userOverrideManager.getOverride(for: featureName) {
            return override
        }
        return registry.isFeatureAvailable(featureName)
    }

    /// Sets a user override for a specific feature's availability.
    ///
    /// - Parameters:
    ///   - featureName: The name of the feature to override.
    ///   - isEnabled: A Boolean value indicating whether the feature should be enabled.
    public func setFeatureOverride(_ featureName: String, isEnabled: Bool) {
        userOverrideManager.setOverride(for: featureName, isEnabled: isEnabled)
        refreshEnabledFeatures()
    }

    /// Clears a user override for a specific feature.
    ///
    /// - Parameter featureName: The name of the feature whose override should be removed.
    public func clearFeatureOverride(_ featureName: String) {
        userOverrideManager.clearOverride(for: featureName)
        refreshEnabledFeatures()
    }

    /// Computes the list of enabled features based on their availability and user overrides.
    ///
    /// - Returns: An array of `FeatureFlag` objects that are currently enabled.
    private func computeEnabledFeatures() -> [FeatureFlag] {
        registry.getAllFeatures().filter { isFeatureEnabled($0.name) }
    }

    /// Refreshes the list of enabled features by recomputing their availability
    /// and updating the published `enabledFeatures` property.
    private func refreshEnabledFeatures() {
        enabledFeatures = computeEnabledFeatures()
    }
    
    /// Retrieves all registered feature flags from the registry.
    ///
    /// - Returns: An array of all `FeatureFlag` objects currently in the registry.
    public func getAllFeatures() -> [FeatureFlag] {
        registry.getAllFeatures()
    }
}
