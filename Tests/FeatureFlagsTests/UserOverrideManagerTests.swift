//
//  UserOverrideManagerTests.swift
//  feature-flags
//
//  Created by Robert Nash on 29/12/2024.
//

import Foundation
import Testing

@testable import FeatureFlags

@MainActor
@Suite("UserOverrideManager Tests")
struct UserOverrideManagerTests {

    @Test("Retrieve All Overrides")
    func testAllOverrides() {
        /// Given
        ///
        /// An instance of UserOverrideManager.
        let manager = UserOverrideManager()
        
        /// And
        ///
        /// Some predefined overrides set.
        manager.setOverride(for: "FeatureA", isEnabled: true)
        manager.setOverride(for: "FeatureB", isEnabled: false)

        /// When
        ///
        /// Retrieving all overrides.
        let allOverrides = manager.overrides

        /// Then
        ///
        /// Validate the number of retrieved overrides.
        #expect(allOverrides.count == 2)
        
        /// And
        ///
        /// Validate the specific override values.
        #expect(allOverrides["FeatureA"] == true)
        #expect(allOverrides["FeatureB"] == false)
    }

    @Test("Empty Overrides Retrieval")
    func testEmptyAllOverrides() {
        /// Given
        ///
        /// An instance of UserOverrideManager with no overrides set.
        let manager = UserOverrideManager()

        /// When
        ///
        /// Retrieving all overrides.
        let allOverrides = manager.overrides

        /// Then
        ///
        /// Validate that the overrides dictionary is empty.
        #expect(allOverrides.count == 0)
    }

    @Test("Updates Reflected in All Overrides")
    func testUpdatesReflectedInAllOverrides() {
        /// Given
        ///
        /// An instance of UserOverrideManager.
        let manager = UserOverrideManager()
        
        /// And
        ///
        /// An override set for "FeatureA".
        manager.setOverride(for: "FeatureA", isEnabled: true)

        /// When
        ///
        /// Updating the override for "FeatureA".
        manager.setOverride(for: "FeatureA", isEnabled: false)
        
        /// And
        ///
        /// Retrieving all overrides.
        let allOverrides = manager.overrides

        /// Then
        ///
        /// Validate that the updated value is reflected.
        #expect(allOverrides.count == 1)
        #expect(allOverrides["FeatureA"] == false)
    }

    @Test("Cleared Overrides Reflected in All Overrides")
    func testClearedOverridesReflectedInAllOverrides() {
        /// Given
        ///
        /// An instance of UserOverrideManager.
        let manager = UserOverrideManager()
        
        /// And
        ///
        /// Overrides set for "FeatureA" and "FeatureB".
        manager.setOverride(for: "FeatureA", isEnabled: true)
        manager.setOverride(for: "FeatureB", isEnabled: false)

        /// When
        ///
        /// Clearing the override for "FeatureA".
        manager.clearOverride(for: "FeatureA")
        
        /// And
        ///
        /// Retrieving all overrides.
        let allOverrides = manager.overrides

        /// Then
        ///
        /// Validate that "FeatureA" is removed.
        #expect(allOverrides["FeatureA"] == nil)
        
        /// And
        ///
        /// Validate that "FeatureB" remains.
        #expect(allOverrides.count == 1)
        #expect(allOverrides["FeatureB"] == false)
    }
}
