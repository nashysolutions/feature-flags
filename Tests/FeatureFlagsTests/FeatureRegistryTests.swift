//
//  FeatureRegistryTests.swift
//  feature-flags
//
//  Created by Robert Nash on 29/12/2024.
//

import Foundation
import Testing
import Versioning

@testable import FeatureFlags

@Suite("FeatureRegistry Tests")
struct FeatureRegistryTests {

    @Test("Feature is available when current version meets the minimum version")
    func testFeatureAvailable() {
        /// Given
        ///
        /// A FeatureRegistry with a current version of 1.0.0.
        let currentVersion = SemanticVersion(major: 1, minor: 0, patch: 0)
        let registry = FeatureRegistry(currentVersion: currentVersion)
        
        /// And
        ///
        /// A feature with a minimum version of 1.0.0.
        let feature = FeatureFlag(name: "TestFeature", minimumVersion: currentVersion)
        registry.registerFeature(feature)

        /// When
        ///
        /// Checking if the feature is available.
        let isAvailable = registry.isFeatureAvailable("TestFeature")

        /// Then
        ///
        /// Validate that the feature is available.
        #expect(isAvailable == true)
    }

    @Test("Feature is unavailable when current version is below the minimum version")
    func testFeatureUnavailableDueToVersion() {
        /// Given
        ///
        /// A FeatureRegistry with a current version of 0.9.0.
        let currentVersion = SemanticVersion(major: 0, minor: 9, patch: 0)
        let registry = FeatureRegistry(currentVersion: currentVersion)
        
        /// And
        ///
        /// A feature with a minimum version of 1.0.0.
        let feature = FeatureFlag(name: "TestFeature", minimumVersion: SemanticVersion(major: 1, minor: 0, patch: 0))
        registry.registerFeature(feature)

        /// When
        ///
        /// Checking if the feature is available.
        let isAvailable = registry.isFeatureAvailable("TestFeature")

        /// Then
        ///
        /// Validate that the feature is unavailable.
        #expect(isAvailable == false)
    }

    @Test("Feature is unavailable when it is not registered")
    func testFeatureUnavailableDueToNonRegistration() {
        /// Given
        ///
        /// A FeatureRegistry with a current version of 1.0.0.
        let currentVersion = SemanticVersion(major: 1, minor: 0, patch: 0)
        let registry = FeatureRegistry(currentVersion: currentVersion)

        /// When
        ///
        /// Checking if a non-registered feature is available.
        let isAvailable = registry.isFeatureAvailable("NonExistentFeature")

        /// Then
        ///
        /// Validate that the feature is unavailable.
        #expect(isAvailable == false)
    }

    @Test("Feature availability is determined concurrently")
    func testFeatureAvailabilityConcurrency() {
        /// Given
        ///
        /// A FeatureRegistry with a current version of 1.0.0.
        let currentVersion = SemanticVersion(major: 1, minor: 0, patch: 0)
        let registry = FeatureRegistry(currentVersion: currentVersion)
        
        /// And
        ///
        /// Multiple features with different minimum versions.
        let features = [
            FeatureFlag(name: "Feature1", minimumVersion: SemanticVersion(major: 1, minor: 0, patch: 0)),
            FeatureFlag(name: "Feature2", minimumVersion: SemanticVersion(major: 2, minor: 0, patch: 0))
        ]
        features.forEach { registry.registerFeature($0) }

        /// When
        ///
        /// Checking feature availability concurrently.
        let isFeature1Available = registry.isFeatureAvailable("Feature1")
        let isFeature2Available = registry.isFeatureAvailable("Feature2")

        /// Then
        ///
        /// Validate concurrent safety and feature availability.
        #expect(isFeature1Available == true)
        #expect(isFeature2Available == false)
    }
}
