# User Overrides

How to register features and override them locally.

## Overview

The `FeatureFlags` system supports user-controlled overrides that take precedence over version-based logic.

This allows features to be explicitly enabled or disabled, regardless of whether the app version would normally activate them.

This is particularly useful for:

- QA testing or internal builds
- Debug menus for previewing features
- Temporary feature rollbacks

---

## Example

```swift
let flags = FeatureFlags(currentVersion: "1.0.0")

let experimental = FeatureFlag(
    name: "ExperimentalFeature",
    minimumVersion: "2.0.0"
)

flags.registerFeature(experimental)

// Override to force-enable the feature, even though version is too low
flags.setFeatureOverride("ExperimentalFeature", isEnabled: true)

assert(flags.isFeatureEnabled("ExperimentalFeature")) // true
```

---

## Recommendation

Overrides are not persisted by default.

When shipping production apps, ensure override access is hidden or restricted to internal builds only.
