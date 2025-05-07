# Versioning

A lightweight and modern Swift library for handling semantic versioning and feature flags. `FeatureFlags` makes it simple to define and compare semantic versions, as well as conditionally enable features based on version requirements.

## Features

- **Semantic Versioning**: Easily create and compare versions using the Semantic Versioning (SemVer) specification.
- **Feature Flags**: Define feature flags that can be enabled or disabled based on app versions or user overrides.
- **Lightweight**: Minimal dependencies and written in pure Swift for seamless integration.

## Installation

### Swift Package Manager

To add `FeatureFlags` to your project:

1. Open your project in Xcode.
2. Go to **File > Add Packages**.
3. Enter the repository URL: `https://github.com/nashysolutions/feature-flags`.
4. Choose the version or branch and integrate the package.

Alternatively, add the dependency directly to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/nashysolutions/versioning", from: "1.0.0")
]# versioning
```

# Usage

### SemanticVersion

```swift
let version1 = SemanticVersion(major: 1, minor: 0, patch: 0)
let version2: SemanticVersion = "1.2.3"

if version1 < version2 {
    print("\(version1) is older than \(version2)")
}
```

### FeatureFlag

```swift
let flag = FeatureFlag(name: "New Feature", minimumVersion: SemanticVersion(major: 2, minor: 0))

let currentVersion: SemanticVersion = "2.1.0"

if currentVersion >= flag.minimumVersion {
    print("Feature '\(flag.name)' is enabled")
} else {
    print("Feature '\(flag.name)' is not available")
}
```

### FeatureFlags

```swift
// Define the current app version
let currentVersion = SemanticVersion(major: 2, minor: 1, patch: 0)

// Create an instance of FeatureFlags
let featureFlags = FeatureFlags(currentVersion: currentVersion)

// Register some feature flags
featureFlags.registerFeature(FeatureFlag(name: "Dark Mode", minimumVersion: SemanticVersion(major: 2, minor: 0)))
featureFlags.registerFeature(FeatureFlag(name: "Advanced Search", minimumVersion: SemanticVersion(major: 3, minor: 0)))

// Check if a feature is enabled
if featureFlags.isFeatureEnabled("Dark Mode") {
    print("Dark Mode is enabled!")
} else {
    print("Dark Mode is not available.")
}

// Override a feature flag
featureFlags.setFeatureOverride("Advanced Search", isEnabled: true)

if featureFlags.isFeatureEnabled("Advanced Search") {
    print("Advanced Search is explicitly enabled via override!")
}

// Clear the override for Advanced Search
featureFlags.clearFeatureOverride("Advanced Search")

if !featureFlags.isFeatureEnabled("Advanced Search") {
    print("Advanced Search is now unavailable after clearing the override.")
}

// Get all registered features
let allFeatures = featureFlags.getAllFeatures()
print("All Registered Features: \(allFeatures.map { $0.name })")
```
