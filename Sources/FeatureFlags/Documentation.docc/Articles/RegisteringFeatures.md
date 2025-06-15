# Registering Features

## Overview

Feature flags must be registered before they can be evaluated for availability.

Each feature is represented by a `FeatureFlag` struct, which includes a name, an optional description, and a `minimumVersion` that determines when the feature becomes available.

The `FeatureFlags` manager evaluates registered features against the current app version and any active user overrides.

---

## Example

```swift
let flags = FeatureFlags(currentVersion: "1.0.0")

let darkMode = FeatureFlag(
    name: "DarkMode",
    minimumVersion: "1.0.0",
    description: "Enables dark theme support"
)

flags.registerFeature(darkMode)

if flags.isFeatureEnabled("DarkMode") {
    enableDarkModeUI()
}
```

---

## Notes

- You can register features at launch or lazily during runtime.
- If a feature with the same name is registered more than once, the latest registration will replace the previous one.
- Features should be registered **before** checking availability using `isFeatureEnabled`.
