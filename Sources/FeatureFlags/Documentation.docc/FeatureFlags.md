# ``FeatureFlags``

`FeatureFlags` is a Swift package for managing feature flags.  
It helps you conditionally enable features in your app based on the current version, with built-in support for user overrides and observable state.

This library is designed for teams who want to:

- Gradually roll out new functionality via [semantic versioning](https://semver.org/).
- Enable experimental features in pre-release builds
- Provide user-controlled feature toggles (e.g. via a debug menu)

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

## Related Symbols

- ``FeatureFlag``
- ``FeatureFlags``

## Related Packages

- [Versioning](https://github.com/nashysolutions/versioning)
