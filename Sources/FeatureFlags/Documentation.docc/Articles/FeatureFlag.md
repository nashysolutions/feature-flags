# ``FeatureFlags/FeatureFlag``

## Overview

A lightweight value type representing a single feature flag.  
Each feature can be conditionally activated based on the app's semantic version.

You can use `FeatureFlag` to define features that should only become available after a certain version of your app, making it easy to manage rollouts or experimental functionality.

---

## Topics

### Initialisation

- ``FeatureFlags/FeatureFlag/init(name:minimumVersion:description:)``

### Properties

- ``FeatureFlags/FeatureFlag/name``
- ``FeatureFlags/FeatureFlag/description``

---

## Example

```swift
let onboarding = FeatureFlag(
    name: "OnboardingFlow",
    minimumVersion: "1.2.0",
    description: "Enables the new onboarding experience"
)
```

---

## Conforms To

- `Codable`
- `Hashable`
- `Sendable`

---

## See Also

- ``FeatureFlags/FeatureFlags``
- ``FeatureFlags/FeatureRegistry``
- ``Versioning/SemanticVersion``
