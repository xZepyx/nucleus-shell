# MaterialColors Api Documentation

## Overview

This api is responsible only for loading and exposing the generated Material color scheme JSON file.

It does not define semantic UI colors.
It does not implement theme logic.
It does not apply transparency.

Its sole responsibility is:

* Reading `colors.json`
* Exposing raw Material 3 color tokens
* Reactively updating when the file changes

---

# How It Is Used

The singleton loads the file located at:

```
Directories.generatedMaterialThemePath
```

When the file is successfully loaded:

* `ready` becomes `true`
* All color properties become available

If the file does not exist:

* Default values are written automatically

The file is watched for changes and reloads automatically.

---

# Access Pattern

You typically do NOT consume this singleton directly in UI components.

Instead, you access colors through:

```
Appearance.m3colors
```

or through semantic colors:

```
Appearance.colors
```

This layer only provides raw Material 3 tokens.

All transparency logic, semantic mapping, hover states, and UI role abstraction are handled in the Appearance singleton.

---

# What This Api Exposes

* Raw Material 3 token strings (background, surface, primary, error, etc.)
* Inverse tokens
* Fixed variants
* Surface container variants
* Outline, scrim, shadow

These are direct string values loaded from JSON.

No transformations occur here.

---

# Lifecycle Behavior

* Watches the JSON file for changes
* Reloads automatically on modification
* Writes defaults if file is missing
* Provides `reload()` function for manual refresh

---

# Architectural Role

This singleton acts as:

1. Material theme file loader
2. Reactive token provider
3. Source for raw color data

All UI systems ultimately consume these tokens through the Appearance system.

It is intentionally low-level and minimal.

