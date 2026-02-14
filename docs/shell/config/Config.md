# Config Api Documentation

## Overview

This api is the central configuration manager for the shell.

It is responsible for:

* Loading and writing the main JSON configuration file
* Providing a reactive runtime config object
* Injecting plugin configuration defaults
* Watching file changes and synchronizing updates

All UI systems (Appearance, Bar, Launcher, etc.) read values from `Config.runtime`.

---

# How It Is Used

## Accessing Configuration

Anywhere in QML:

```
Config.runtime.appearance.theme
Config.runtime.bar.position
Config.runtime.notifications.enabled
```

`runtime` acts as the live configuration object backed by a JSON file.

Changes made through `updateKey()` or direct adapter updates are persisted automatically.

Example usage of the `updateKey` function:

```
Config.updateKey("bar.enabled", true)
```

---

# File Handling Behavior

The singleton:

* Watches the config file for changes
* Reloads when the file changes externally
* Writes changes with a short debounce delay
* Auto-creates the file if it does not exist

This ensures safe two-way synchronization between:

* Runtime QML state
* Disk JSON config

---

# Plugin Configuration Usage

Plugins provide a `PluginConfigData.qml` file containing default values.

At startup:

* The singleton loads each plugin
* Merges missing defaults into `runtime.plugins`
* Writes updated config only if changes occurred

Usage pattern inside plugins:

```
Config.runtime.plugins.<pluginName>.<property> 
```

This guarantees:

* Safe defaults
* Backward-compatible upgrades
* No config loss

---

# Lifecycle Notes

* `initialized` becomes true once config is successfully loaded.
* Writes are debounced.
* External edits trigger automatic reload.
* Plugin defaults are merged only when missing.

---

# Architectural Role

This api acts as:

1. Persistent configuration storage
2. Reactive runtime state provider
3. Plugin config injector
4. File synchronization manager

All UI layers depend on it as the single source

