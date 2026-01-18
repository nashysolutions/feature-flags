# Example Implementation

How consumers of the library are expected to model features and derive higher-level behaviour.

This document walks through a **complete, real-world feature model** built on top of
the `FeatureFlags` library.

The goal is to show:
- how features are explicitly modelled
- how scope is declared
- how local vs remote control is enforced
- how higher-level helpers are derived safely

This is intentional boilerplate and forms part of the library’s philosophy.

---

## Feature definition

```swift
enum Feature: String, CaseIterable, CustomStringConvertible {
    
    case ai
    case paywall
    case quota
    
    /// In what version the feature becomes available (and all versions that follow, unless overriden)
    var minimumVersion: SemanticVersion {
        switch self {
        case .ai, .paywall, .quota:
            return "0.0.0"
        }
    }
    
    var description: String {
        switch self {
        case .ai: "Apple Intelligence."
        case .paywall: "The paywall."
        case .quota: "Report limit quota."
        }
    }
    
    var flag: FeatureFlag {
        FeatureFlag(
            feature: self,
            minimumVersion: minimumVersion,
            description: description
        )
    }
}
```

### Why this exists

Each feature is:
- named once
- version-gated once
- described once

If a feature changes meaning, the compiler forces you to revisit it.

---

## Feature scope

```swift
enum FeatureScope {
    
    // Can be disabled locally only, via debug menu.
    case localControlled
    // Can be disabled locally and remotely.
    case remoteControlled
    // Feature is disabled.
    case hardDisable
    
    var isLocallyToggleable: Bool {
        switch self {
        case .localControlled, .remoteControlled:
            return true
        case .hardDisable:
            return false
        }
    }
    
    var isRemotelyToggleable: Bool {
        switch self {
        case .localControlled, .hardDisable:
            return false
        case .remoteControlled:
            return true
        }
    }
}
```

### Intent

This enum answers one question:

> *Who is allowed to control this feature?*

Not:
- whether the feature is enabled
- not whether it is experimental

Only authority.

---

## Assigning scope to features

```swift
extension Feature {
    
    var scope: FeatureScope {
        switch self {
        case .ai: .localControlled
        case .quota: .localControlled
        case .paywall: .localControlled
        }
    }
}
```

This mapping is deliberate.

These features:
- exist in release builds
- may be toggled locally for QA
- are not eligible for remote control

If this policy changes, the compiler will force an update.

---

## Bridging your logic to `FeatureFlag`

```swift
private extension FeatureFlag {

    init(
        feature: Feature, // your logic
        minimumVersion: SemanticVersion,
        description: String?
    ) {
        self.init(
            name: feature.rawValue,
            minimumVersion: minimumVersion,
            description: description
        )
    }
}
```

This keeps the public API clean while preserving type safety.

---

## Automatic registration

```swift
import Versioning

extension FeatureFlags {

    convenience init?() {
        /// Extract version from plist
        guard let version: SemanticVersion = try? BundleLocator.bundleVersion() else {
            return nil
        }
        self.init(currentVersion: version)
        Feature.allCases.forEach { registerFeature($0.flag) }
    }
}
```

This ensures:
- all features are registered consistently
- versioning is applied uniformly

---

## Remote configuration

If we decided to make the above remotely configurable, then the following is an example of how that might look (as advice only).

```json
{
  "schema": 1,
  "generatedAt": "2026-01-18T09:30:00Z",
  "ttlSeconds": 86400,
  "features": {
    "paywall": {
      "enabled": true,
      "reason": "Default monetisation gate"
    },
    "quota": {
      "enabled": true,
      "reason": "Report limit enforcement"
    },
    "ai": {
      "enabled": false,
      "reason": "Local-only feature"
    }
  }
}
```

The JSON payload shown above represents an authoritative suggestion, not an instruction that must always be followed.

### What remote configuration is responsible for

A remote system may decide:

- whether a remotely-controlled feature should be enabled
- how long that decision should be trusted (TTL)
- why a decision exists (for diagnostics, analytics, or audits)

It does not decide:

- how features are modelled
- who is allowed to toggle them
- how the app behaves when offline

Those decisions remain local and explicit.

---

### Resolution order (recommended)

When integrating remote configuration, a common resolution order is:

1. **Hard build policy**  
   Features that are hard-disabled for a given build or distribution channel  
   (for example, paywall disabled in TestFlight).

2. **Local override**  
   QA or debug overrides that explicitly force a feature on or off.

3. **Remote decision**  
   Applied only if the feature is marked as `remoteControlled`.

4. **Local default**  
   The behaviour encoded in the app itself.

This order ensures predictable behaviour even when remote data is missing, stale, or incorrect.

### Scope enforcement

Remote decisions must respect feature scope.

```swift
func applyRemoteDecision(_ enabled: Bool, to feature: Feature) {
    guard feature.scope.isRemotelyToggleable else {
        assertionFailure("Remote decision received for local-only feature: \(feature)")
        return
    }

    // Apply remote decision in your own infrastructure layer
}
```

This prevents backend misconfiguration from silently altering features that were never intended to be remotely controlled.

### TTL is policy, not mechanism

The presence of ttlSeconds in the payload does not imply that FeatureFlags enforces TTL.

TTL answers a business question:

How long can we tolerate being wrong if the user is offline?

Example
- <doc:TTLPolicyExamples>

Because this varies by product, TTL handling belongs in your remote configuration layer, not in FeatureFlags.

### Offline behaviour is intentional

When a remote decision expires or cannot be refreshed, the app should fall back to safe local behaviour.

These choices are business-specific and should be made explicitly.
