# TTL Policy Examples

This document provides **concrete, business-driven examples** of when a Time-To-Live (TTL)
for remote feature flags **should** and **should not** matter.

TTL is not a technical optimisation.  
It is a statement of **how long the business is willing to tolerate being wrong** when the app
cannot contact the server.

---

## Features where TTL **should matter** (fail closed or degrade)

These are features where continuing to operate incorrectly creates **risk**, **cost**, or **liability**.

---

### 1. Paid entitlements / subscriptions

**Example**
- Pro export
- Premium templates
- Cloud sync

**Risk**
- Users retain paid access after cancellation
- Revenue leakage while offline

**Business intent**
- Access should eventually stop everywhere

**TTL policy**
- Short TTL (hours–days)
- Stale-while-revalidate briefly
- Hard fallback after expiry (lock feature)

---

### 2. Usage-based quotas

**Example**
- AI token usage
- API credits
- Report generation limits

**Risk**
- Offline users consume costly resources
- Backend cannot enforce limits

**Business intent**
- Prevent uncontrolled cost

**TTL policy**
- Short TTL
- Disable or heavily restrict on expiry
- Local safety caps recommended

---

### 3. Legal or regulatory gating

**Example**
- Age-restricted content
- Region-restricted features

**Risk**
- Compliance violations
- Legal exposure

**Business intent**
- Must not operate outside policy

**TTL policy**
- Strict TTL
- Immediate fallback on expiry
- No long-lived stale behaviour

---

### 4. Security-sensitive kill switches

**Example**
- Feature with a known exploit
- Data corruption bug
- Crash-on-launch regression

**Risk**
- Harm to users or systems
- Reputational damage

**Business intent**
- Turn off everywhere, eventually

**TTL policy**
- Very short TTL
- Hard fallback on expiry
- Push refresh if possible

---

## Features where TTL **should not matter** (fail open)

These are cases where **disabling the feature harms UX more than leaving it on**.

---

### 5. UI experiments

**Example**
- Layout changes
- Button placement
- Animations

**Risk**
- Minimal
- Old behaviour lingering is acceptable

**Business intent**
- UX experimentation only

**TTL policy**
- Long TTL or no TTL
- Cache indefinitely acceptable

---

### 6. Purely local functionality

**Example**
- Local export formats
- Keyboard shortcuts
- Offline tools

**Risk**
- None (no backend dependency)

**Business intent**
- Feature should always work

**TTL policy**
- TTL unnecessary

---

### 7. Nice-to-have enhancements

**Example**
- AI assistance with manual fallback
- Convenience features

**Risk**
- Feature persists longer than intended

**Business intent**
- Improve experience, not enforce policy

**TTL policy**
- Optional TTL
- Fail open on expiry

---

## Mixed cases (nuance required)

---

### 8. A/B tests used only for measurement

**Example**
- UX experiments without safety implications

**Risk**
- Analytics contamination if cohorts persist

**Business intent**
- Data correctness

**TTL policy**
- TTL matters for analytics
- UX may tolerate stale behaviour

---

### 9. Paywall visibility

**Example**
- Showing or hiding a paywall

**Risk**
- Blocking users unfairly when offline
- Revenue loss if hidden forever

**Business intent**
- Never block legitimate users due to uncertainty

**TTL policy**
- TTL exists
- Expiry fails open (hide paywall)
- Entitlement checks may be stricter

---

## Avoiding gaps around TTL expiry (advisory)

If you adopt TTL for remote decisions, you will also need to decide what happens at the moment a cached decision expires.

A strict interpretation of TTL (“expired means unusable”) can create short-lived gaps where the app falls back to defaults until the next successful fetch. This is especially noticeable when you fetch on a fixed cadence (for example, every 5 minutes).

The `FeatureFlags` library does not implement TTL, caching, or remote fetch. The strategies below are guidance for your own remote configuration layer.

### Strategy 1: Refresh proactively (refresh-ahead)

Rather than waiting for expiry, refresh shortly before the TTL boundary.

- Choose a refresh window (for example, 5–10% of TTL, or a fixed duration such as 15 minutes).
- If the cached decision will expire within that window, trigger a refresh immediately.
- On success, extend the expiry without ever hitting the TTL boundary.

This approach is simple and avoids “default gaps” when the device is online.

### Strategy 2: Stale-while-revalidate (recommended)

Instead of dropping to defaults immediately at expiry:

- Continue using the last known decision after TTL, but mark it as **stale**.
- Attempt to refresh in the background (and retry with backoff).
- Only fall back to defaults if the stale decision cannot be refreshed for a longer grace period.

This avoids UI flicker and “five-minute gaps”, while still ensuring that decisions do not live forever.

A common pattern is:

- **fresh**: use cached decision normally
- **stale**: continue using cached decision while refreshing
- **expired**: fall back to defaults after a grace window

### Strategy 3: Opportunistic refresh triggers

Fetch cadence does not need to be purely time-based. Many apps also refresh when:

- the app enters the foreground
- the user reaches a screen that depends on the decision (e.g. paywall or export flow)
- network connectivity is restored
- a significant time has passed since last successful fetch

This reduces the likelihood of expiry occurring while the app is actively in use.

## Summary

TTL answers one question:

> **How long can we tolerate being wrong?**

- If being wrong costs money → short TTL
- If being wrong breaks law or trust → strict TTL
- If being wrong only affects UX → long or no TTL
- If being wrong blocks users unfairly → fail open

TTL is a **policy decision**, not an implementation detail.
