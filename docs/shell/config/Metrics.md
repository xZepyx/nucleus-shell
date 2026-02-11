# Metrics

## Overview

This QML `Singleton` provides a centralized scaling and token-resolution layer for interface metrics
It standardizes:

* Animation durations
* Margins
* Spacing and padding
* Corner radii
* Font sizes
* Icon sizes
* Font families

All numeric inputs may be passed directly. Named tokens are resolved through `Appearance`.

Note that: This singleton/api can be access in any file by importing: `qs.config`

---


---

## Global Scaling Factors

These values are derived from runtime configuration and automatically applied where relevant.

| Property        | Source                                               | Purpose                        |
| --------------- | ---------------------------------------------------- | ------------------------------ |
| `durationScale` | `Config.runtime.appearance.animations.durationScale` | Multiplies animation durations |
| `roundingScale` | `Config.runtime.appearance.rounding.factor`          | Multiplies radius values       |
| `fontScale`     | `Config.runtime.appearance.font.scale`               | Multiplies font and icon sizes |

---

## API Reference

### spacing(value)

Returns spacing value.

**Behavior**

* If `number` → returned as-is

Currently reserved for future scaling support.

---

### padding(value)

Returns padding value.

**Behavior**

* If `number` → returned as-is

Currently reserved for future scaling support.

---

### chronoDuration(value)

Returns animation duration with scaling applied.

**Behavior**

* If `number` → multiplied by `durationScale`
* If `string` → resolved from `Appearance.animation.durations` and multiplied by `durationScale`

**Named Tokens**

* `"supershort"`
* `"small"`
* `"normal"`
* `"large"`
* `"extraLarge"`
* `"expressiveFastSpatial"`
* `"expressiveDefaultSpatial"`
* `"expressiveEffects"`

**Fallback:** `0`

---

### margin(value)

Returns margin size.

**Behavior**

* If `number` → returned as-is
* If `string` → resolved from `Appearance.margin`

**Named Tokens**

* `"supertiny"`
* `"tinier"`
* `"tiny"`
* `"verysmall"`
* `"small"`
* `"normal"`
* `"large"`
* `"verylarge"`
* `"extraLarge"`

**Fallback:** `0`

---

### radius(value)

Returns corner radius with rounding scale applied.

**Behavior**

* If `number` → multiplied by `roundingScale`
* If `string` → resolved from `Appearance.rounding` and multiplied by `roundingScale`

**Named Tokens**

* `"unsharpen"`
* `"unsharpenmore"`
* `"verysmall"`
* `"small"`
* `"normal"`
* `"large"`
* `"verylarge"`
* `"childish"`
* `"full"`
* `"screenRounding"`
* `"windowRounding"`

**Fallback:** `0`

---

### fontSize(value)

Returns font size scaled by `fontScale`.

**Behavior**

* If `number` → multiplied by `fontScale`
* If `string` → resolved from `Appearance.font.size` and scaled

**Named Tokens**

* `"smallest"`
* `"smaller"`
* `"smallie"`
* `"small"`
* `"normal"`
* `"large"`
* `"larger"`
* `"big"`
* `"huge"`
* `"hugeass"`
* `"wildass"`
* `"title"`

**Fallback:** `Appearance.font.size.normal * fontScale`

---

### iconSize(value)

Returns icon size scaled by `fontScale`.

**Behavior**

* If `number` → multiplied by `fontScale`
* If `string` → resolved from `Appearance.font.size.icon` and scaled

**Named Tokens**

Same token set as `fontSize`.

**Fallback:** `Appearance.font.size.icon.normal * fontScale`

---

### fontFamily(value)

Resolves font family names.

**Behavior**

* If named token → resolved from `Appearance.font.family`
* If custom string → returned directly
* If invalid → returns main font family

**Named Tokens**

* `"main"`
* `"title"`
* `"materialIcons"`
* `"nerdIcons"`
* `"monospace"`
* `"reading"`
* `"expressive"`

**Fallback:** `Appearance.font.family.main`

---

All UI components should reference this layer instead of directly accessing hardcoded values.
