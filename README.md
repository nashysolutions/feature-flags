# FeatureFlags

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fnashysolutions%2Ffeature-flags%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/nashysolutions/feature-flags)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fnashysolutions%2Ffeature-flags%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/nashysolutions/feature-flags)

A lightweight Swift library for **managing feature flags** based on semantic versioning or explicit overrides.

Designed for real applications where feature rollouts, version-gating, and conditional behaviour need to be expressed **clearly and predictably** in code.

[Documentation](https://swiftpackageindex.com/nashysolutions/feature-flags/1.2.2/documentation/featureflags)

---

## Why this exists

This library exists to provide a **focused, deterministic feature flag system** that:

- clearly associates flag definitions with version or override policies,
- makes flag evaluation explicit at the call site,
- keeps decision logic separate from business logic,
- and scales from small internal tools to larger Swift projects.

Feature flags are a common mechanism in production systems to:
- enable or disable behaviour without shipping new binaries,
- gate features behind version boundaries,
- perform controlled rollouts across environments,
- support experimental work and A/B style workflows.

In practice, feature flag logic often ends up:
- scattered throughout application code,
- encoded as scattered booleans or ad hoc conditionals,
- hard to reason about when the flag conditions become complex,
- mixed with version or build-config checks that are not centralised.

---

## What it is

- A lightweight abstraction for defining and evaluating feature flags
- Version-aware gating based on semantic version semantics
- Support for manual overrides
- Minimal dependencies and safe for use in production Swift apps
- Suitable for server, command-line tools, and client apps

---

## What it deliberately avoids

- Heavy remote flag management or server integrations
- Network-driven evaluation or polling logic
- UI tooling or dashboards
- Magic behaviour or implicit state

If you need a full remote feature flag platform, there are other tools for that — this package focuses on the *local evaluation* layer.

---

## Quick example

```swift
// 1. declare you features
enum Feature: String {
    
    case betaFeature
    
    var minimumVersion: SemanticVersion {
        switch self {
        case .betaFeature:
            return "1.1.0" // 2. state when this feature is available
        }
    }
}

// 3. register your feature
let flags = FeatureFlags(currentVersion:"1.4.0") // extract version from plist
flags.registerFeature(.betaFeature)

// 4. wrap your feature specifc code

if flags.isFeatureEnabled(.betaFeature) {
    // execute new behaviour
}

// force an override if needed - useful for QA teams
// flags.setFeatureOverride(.betaFeatures, isEnabled: false)
```

This API makes the intent clear:
you evaluate flags based on a defined version and optional overrides.

## Design principles

* Explicit evaluation — flags are checked intentionally at call sites.
* Version semantics first — version-gating is a central concern.
* Clear behaviour — there are no hidden rules or magic defaults.
* Production-safe — suitable for mission-critical deployments.

## When to use this

Use this library when:
* you want to gate features by version or explicit state,
* you need predictable evaluations,
* you want to centralise flag definitions and avoid scattered booleans,
* you value clarity over convention-over-configuration.

This is not a server-controlled remote flag solution — it’s about local, deterministic feature gating.
