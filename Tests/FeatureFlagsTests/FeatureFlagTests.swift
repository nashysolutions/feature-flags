//
//  FeatureFlagTests.swift
//  feature-flags
//
//  Created by Robert Nash on 29/12/2024.
//

import Foundation
import Testing
import Versioning

@testable import FeatureFlags

@Suite("FeatureFlag Tests")
struct FeatureFlagTests {

    @Test("FeatureFlag initialises correctly with all parameters")
    func testInitialisationWithAllParameters() {
        /// Given
        ///
        /// A name, minimum version, and description for a feature flag.
        let name = "TestFeature"
        let minimumVersion = SemanticVersion(major: 1, minor: 0, patch: 0)
        let description = "This is a test feature."

        /// When
        ///
        /// Initialising the FeatureFlag.
        let featureFlag = FeatureFlag(name: name, minimumVersion: minimumVersion, description: description)

        /// Then
        ///
        /// Validate that all properties are set correctly.
        #expect(featureFlag.name == name)
        #expect(featureFlag.minimumVersion == minimumVersion)
        #expect(featureFlag.description == description)
    }

    @Test("FeatureFlag initialises correctly without a description")
    func testInitialisationWithoutDescription() {
        /// Given
        ///
        /// A name and minimum version for a feature flag.
        let name = "TestFeature"
        let minimumVersion = SemanticVersion(major: 1, minor: 0, patch: 0)

        /// When
        ///
        /// Initialising the FeatureFlag without a description.
        let featureFlag = FeatureFlag(name: name, minimumVersion: minimumVersion)

        /// Then
        ///
        /// Validate that the description is `nil`.
        #expect(featureFlag.name == name)
        #expect(featureFlag.minimumVersion == minimumVersion)
        #expect(featureFlag.description == nil)
    }

    @Test("FeatureFlag initialises with an empty description")
    func testInitialisationWithEmptyDescription() {
        /// Given
        ///
        /// A name, minimum version, and an empty description.
        let name = "TestFeature"
        let minimumVersion = SemanticVersion(major: 1, minor: 0, patch: 0)
        let emptyDescription = ""

        /// When
        ///
        /// Initialising the FeatureFlag with an empty description.
        let featureFlag = FeatureFlag(name: name, minimumVersion: minimumVersion, description: emptyDescription)

        /// Then
        ///
        /// Validate that the description is `nil` when empty.
        #expect(featureFlag.name == name)
        #expect(featureFlag.minimumVersion == minimumVersion)
        #expect(featureFlag.description == nil)
    }

    @Test("FeatureFlag encodes and decodes correctly")
    func testEncodingAndDecoding() {
        /// Given
        ///
        /// A FeatureFlag instance.
        let name = "TestFeature"
        let minimumVersion = SemanticVersion(major: 1, minor: 0, patch: 0)
        let description = "This is a test feature."
        let featureFlag = FeatureFlag(name: name, minimumVersion: minimumVersion, description: description)

        /// When
        ///
        /// Encoding and decoding the FeatureFlag.
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let data = try! encoder.encode(featureFlag)
        let decodedFeatureFlag = try! decoder.decode(FeatureFlag.self, from: data)

        /// Then
        ///
        /// Validate that the decoded object matches the original.
        #expect(decodedFeatureFlag.name == featureFlag.name)
        #expect(decodedFeatureFlag.minimumVersion == featureFlag.minimumVersion)
        #expect(decodedFeatureFlag.description == featureFlag.description)
    }
}
