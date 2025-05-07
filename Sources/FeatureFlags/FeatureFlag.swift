//
//  FeatureFlag.swift
//  feature-flags
//
//  Created by Robert Nash on 28/12/2024.
//

import Foundation
import Versioning

/// Represents a feature flag that can be conditionally enabled based on the app's semantic version.
///
/// This struct supports encoding, decoding, and hashing, making it suitable for use in various
/// persistence and comparison contexts.
public struct FeatureFlag: Codable, Hashable, Sendable {

    /// The unique name of the feature flag.
    ///
    /// This serves as an identifier for the feature and is used for referencing it in the codebase.
    public let name: String

    /// An optional description of the feature flag.
    ///
    /// Provides additional context or documentation about the purpose of the feature flag.
    /// If `description` is empty or not provided, it defaults to `nil`.
    public let description: String?

    /// The minimum semantic version required to enable this feature.
    ///
    /// This ensures that a feature is only available in app versions equal to or greater than this version.
    let minimumVersion: SemanticVersion

    /// Initialises a new `FeatureFlag` instance.
    ///
    /// - Parameters:
    ///   - name: The unique name of the feature flag.
    ///   - minimumVersion: The minimum semantic version required to enable the feature.
    ///   - description: An optional description of the feature flag. Defaults to `nil` if not provided or empty.
    public init(name: String, minimumVersion: SemanticVersion, description: String? = nil) {
        self.name = name
        self.minimumVersion = minimumVersion
        if let description, description.isEmpty == false {
            self.description = description
        } else {
            self.description = nil
        }
    }
}
