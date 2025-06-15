# ``FeatureFlags/UserOverrideManager``

## Overview

`UserOverrideManager` is a utility class that stores and manages manual user overrides for feature availability.

Overrides are used to explicitly enable or disable features regardless of their default availability based on semantic version rules.

This allows users, testers, or developers to toggle features for experimentation or preview purposes.

---

## Topics

### Methods

- ``FeatureFlags/UserOverrideManager/setOverride(for:isEnabled:)``
- ``FeatureFlags/UserOverrideManager/clearOverride(for:)``
- ``FeatureFlags/UserOverrideManager/getOverride(for:)``

### Properties

- ``FeatureFlags/UserOverrideManager/overrides``

---

## Usage

```swift
let manager = UserOverrideManager()

manager.setOverride(for: "ExperimentalFeature", isEnabled: true)

if let isEnabled = manager.getOverride(for: "ExperimentalFeature") {
    print("Feature override is \(isEnabled ? "enabled" : "disabled")")
}

manager.clearOverride(for: "ExperimentalFeature")
```

---

## See Also

- ``FeatureFlags/FeatureFlags``
- ``FeatureFlags/FeatureFlag``
- ``FeatureFlags/FeatureRegistry``
