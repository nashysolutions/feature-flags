# ``FeatureFlags/FeatureRegistry``

## Overview

`FeatureRegistry` is an internal type responsible for storing registered feature flags and determining their availability based on the current semantic version of the app.

It acts as the central storage and evaluation engine for the `FeatureFlags` interface and ensures that features are only enabled when appropriate.

---

## Topics

### Initialisation

- ``FeatureFlags/FeatureRegistry/init(currentVersion:)``

### Methods

- ``FeatureFlags/FeatureRegistry/registerFeature(_:)``
- ``FeatureFlags/FeatureRegistry/isFeatureAvailable(_:)``
- ``FeatureFlags/FeatureRegistry/getAllFeatures()``

---

## Usage

```swift
let registry = FeatureRegistry(currentVersion: "2.0.0")

registry.registerFeature(
    FeatureFlag(name: "DarkMode", minimumVersion: "2.0.0")
)

let isAvailable = registry.isFeatureAvailable("DarkMode") // true
```

---

## See Also

- ``FeatureFlags/FeatureFlag``
- ``FeatureFlags/FeatureFlags``
