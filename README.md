# FeatureFlags

**FeatureFlags** is a lightweight, version-aware feature flag system for Swift applications.  
It enables you to define, register, and conditionally activate features based on semantic app versioning — with support for user overrides, Combine observation, and testability.

---

## Features

- ✅ Register and manage feature flags using `FeatureFlag` models
- 🧠 Evaluate feature availability using `SemanticVersion` from the [`Versioning`](https://github.com/nashysolutions/versioning) library.
- 🕹️ Support user-controlled overrides (enable/disable) for pre-release builds.

## 📦 Installation

Add this package via Swift Package Manager:

```swift
.product(name: "FeatureFlags", package: "feature-flags")
```

# Usage

1. Initialise the FeatureFlags Manager

```swift
let currentAppVersion = SemanticVersion(major: 1, minor: 0)
let flags = FeatureFlags(currentVersion: currentAppVersion)
```

2. Register Features

```swift
let onboarding = FeatureFlag(
    name: "OnboardingFlow",
    minimumVersion: "1.0.0",
    description: "Enables the new onboarding experience."
)

flags.registerFeature(onboarding)
```

3. Check Feature Availability

```swift
if flags.isFeatureEnabled("OnboardingFlow") {
    showNewOnboarding()
}
```

5. Observe Changes (e.g. via SwiftUI)

```swift
@ObservedObject var featureFlags: FeatureFlags

var body: some View {
    if featureFlags.enabledFeatures.contains(where: { $0.name == "SomeFeature" }) {
        NewUI()
    } else {
        OldUI()
    }
}
```
