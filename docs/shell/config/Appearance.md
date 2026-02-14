# Appearance Api Documentation

## Overview

This api centralizes:

* Material 3 color tokens
* Semantic UI colors
* Spacing scale
* Motion system (durations + curves)
* Corner rounding scale
* Typography families and sizes
* Syntax highlighting base color

All properties are reactive to `Config.runtime.appearance`.

---

## Top-Level Properties

* **m3colors** — Material 3 token wrapper with optional transparency.
* **colors** — Semantic UI color layer derived from m3colors.
* **rounding** — Corner radius scale derived from runtime rounding factor.
* **font** — Typography families and sizes.
* **margin** — Spacing scale.
* **moduleLayouts** — Reserved for layout presets.
* **animation** — Motion tokens and reusable animation components.
* **syntaxHighlightingTheme** — Base foreground color for syntax themes.

---

## Runtime-Derived Flags

* **darkmode**
  `Config.runtime.appearance.theme === "dark"`

* **transparentize**
  Whether UI transparency mode is enabled.

* **alpha**
  Transparency intensity value.

These influence color generation inside `m3colors`.

---

# m3colors — Material 3 Token Layer

Wraps `MaterialColors.colors` and conditionally applies transparency.

## Helper Functions

* **t(c)**
  Applies `ColorUtils.transparentize(c, alpha)` when transparency is enabled.

* **tH(c)**
  Forces full transparency when enabled.

## Surface Tokens (Examples)

* m3background
* m3surface
* m3surfaceContainerLow
* m3surfaceContainer
* m3surfaceContainerHigh
* m3surfaceVariant
* m3inverseSurface

## Role Tokens

Includes Primary, Secondary, Tertiary, Error, Fixed variants, Outline, Shadow, Scrim, and Surface Tint tokens.

All automatically adapt to transparency mode.

---

# colors — Semantic UI Layer

Converts raw Material tokens into UI-ready semantic roles.

## Structural Layers

* colLayer0
* colLayer0Border
* colLayer1
* colLayer1Hover
* colLayer1Active
* colLayer2
* colLayer2Hover
* colLayer2Active

Hover/active states are generated using `ColorUtils.mix`.

## Interactive Colors

* colPrimary
* colOnPrimary
* colSecondary
* colSecondaryContainer
* colOnSecondaryContainer

## Utility Colors

* colTooltip
* colOnTooltip
* colShadow
* colOutline
* colSubtext

---

# margin — Spacing Scale

Spacing ramp used for padding and layout gaps:

* supertiny = 2
* tinier = 3
* tiny = 6
* verysmall = 8
* small = 12
* normal = 16
* large = 22
* verylarge = 30
* extraLarge = 35

---

# animation — Motion System

Defines global easing defaults and reusable animation components.

## Base Easing

* easing = Easing.OutExpo

## durations

* supershort (100ms)
* small (200ms)
* normal (400ms)
* large (600ms)
* extraLarge (1000ms)
* expressiveFastSpatial
* expressiveDefaultSpatial
* expressiveEffects

## curves

Bezier spline definitions for:

* expressiveFastSpatial
* expressiveDefaultSpatial
* expressiveSlowSpatial
* expressiveEffects
* emphasized
* emphasizedAccel / Decel
* standard
* standardAccel / Decel

Also exposes default duration constants.

## Reusable Animation Objects

### elementMove

Default spatial movement animation.

### elementMoveEnter

Entrance motion (emphasized deceleration).

### elementMoveFast

Short expressive effect motion.

Each exposes a reusable `NumberAnimation` component.

---

# rounding — Corner Radius System

All values scale with:

`Config.runtime.appearance.rounding.factor`

Available sizes:

* unsharpen
* unsharpenmore
* verysmall
* small
* normal
* large
* verylarge
* childish
* full (9999)
* screenRounding
* windowRounding

This allows global rounding adjustments from a single factor.

---

# font — Typography System

## font.family

Bound to runtime configuration:

* main
* title
* materialIcons
* nerdIcons
* monospace
* reading
* expressive

## font.size

Text size scale:

* smallest = 10
* smaller = 12
* smallie = 13
* small = 15
* normal = 16
* large = 17
* larger = 19
* big = 21
* huge = 22
* hugeass = 23
* wildass = 40
* title = huge

### Icon Sizes

Separate scale under `font.size.icon`.

---

# syntaxHighlightingTheme

Computed value:

* Dark mode: '#f1ebeb'
* Light mode: '#141333'

Used as base foreground color for syntax highlighting contexts.

# Notes
* All values like: margin, rounding, spacing, animationDurations/ fontSize/fontFamily/iconSize are supposed to be derived from Metrics.qml instead of this api. This api should only be used for animations creations, animation types, colors etc.

---

# Architectural Summary

Layered system:

1. Material 3 raw tokens
2. Transparency adaptation
3. Semantic UI layer
4. Spacing + rounding scale
5. Motion tokens
6. Typography tokens

All values remain reactive to runtime configuration.

