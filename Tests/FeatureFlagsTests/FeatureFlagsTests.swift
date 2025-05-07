//
//  FeatureFlagsTests.swift
//  feature-flags
//
//  Created by Robert Nash on 29/12/2024.
//

import Foundation
import Testing
import Versioning

@testable import FeatureFlags

@MainActor
@Suite("FeatureFlags Tests")
struct FeatureFlagsTests {

    @Test("Register a feature and check if it's available")
    func testFeatureRegistration() {
        /// Given
        ///
        /// A FeatureFlags instance and a new feature flag.
        let currentVersion = SemanticVersion(major: 1, minor: 0, patch: 0)
        let featureFlags = FeatureFlags(currentVersion: currentVersion)
        let newFeature = FeatureFlag(name: "TestFeature", minimumVersion: currentVersion)

        /// When
        ///
        /// Registering the feature.
        featureFlags.registerFeature(newFeature)

        /// Then
        ///
        /// The feature should be enabled.
        let isEnabled = featureFlags.isFeatureEnabled("TestFeature")
        #expect(isEnabled, "Feature should be enabled after registration.")
    }

    @Test("Check feature override behavior")
    func testFeatureOverride() {
        /// Given
        ///
        /// A FeatureFlags instance and an existing feature.
        let currentVersion = SemanticVersion(major: 1, minor: 0, patch: 0)
        let featureFlags = FeatureFlags(currentVersion: currentVersion)
        let feature = FeatureFlag(name: "OverrideFeature", minimumVersion: currentVersion)
        featureFlags.registerFeature(feature)

        /// When
        ///
        /// Overriding the feature to be disabled.
        featureFlags.setFeatureOverride("OverrideFeature", isEnabled: false)

        /// Then
        ///
        /// The feature should be disabled.
        let isEnabled = featureFlags.isFeatureEnabled("OverrideFeature")
        #expect(!isEnabled, "Feature override should disable the feature.")
    }

    @Test("Clear feature override")
    func testClearFeatureOverride() {
        /// Given
        ///
        /// A FeatureFlags instance with an overridden feature.
        let currentVersion = SemanticVersion(major: 1, minor: 0, patch: 0)
        let featureFlags = FeatureFlags(currentVersion: currentVersion)
        let feature = FeatureFlag(name: "ClearOverrideFeature", minimumVersion: currentVersion)
        featureFlags.registerFeature(feature)
        featureFlags.setFeatureOverride("ClearOverrideFeature", isEnabled: false)

        /// When
        ///
        /// Clearing the override for the feature.
        featureFlags.clearFeatureOverride("ClearOverrideFeature")

        /// Then
        ///
        /// The feature should return to its default enabled state.
        let isEnabled = featureFlags.isFeatureEnabled("ClearOverrideFeature")
        #expect(isEnabled, "Feature should be enabled after clearing override.")
    }

    @Test("Get all enabled features")
    func testEnabledFeatures() {
        /// Given
        ///
        /// A FeatureFlags instance with multiple features.
        let currentVersion = SemanticVersion(major: 1, minor: 0, patch: 0)
        let featureFlags = FeatureFlags(currentVersion: currentVersion)
        let feature1 = FeatureFlag(name: "Feature1", minimumVersion: currentVersion)
        let feature2 = FeatureFlag(name: "Feature2", minimumVersion: currentVersion)
        featureFlags.registerFeature(feature1)
        featureFlags.registerFeature(feature2)
        featureFlags.setFeatureOverride("Feature2", isEnabled: false)

        /// When
        ///
        /// Fetching all enabled features.
        let enabledFeatures = featureFlags.enabledFeatures

        /// Then
        ///
        /// Only the enabled features should be returned.
        let featureNames = enabledFeatures.map { $0.name }
        #expect(featureNames.contains("Feature1"), "Feature1 should be enabled.")
        #expect(!featureNames.contains("Feature2"), "Feature2 should be disabled.")
    }
}
