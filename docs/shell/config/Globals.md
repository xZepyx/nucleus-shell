# Globals Api Documentation

## Overview

This api acts as a centralized runtime state container for UI visibility and window states.

It does not persist data.
It does not read or write files.
It does not contain business logic.

It only exposes reactive boolean flags used to control overlays and panels.

---

# How It Is Used

Anywhere in QML:

```
Globals.visiblility.launcher = true
Globals.visiblility.powermenu = false
```

Components bind to these flags:

```
visible: Globals.visiblility.sidebarLeft
```

This ensures a single source of truth for UI overlay visibility.

---

# visiblility

Controls whether major overlays or panels are shown.

Stored properties:

* powermenu
* launcher
* sidebarRight
* sidebarLeft

Used for:

* Opening and closing global panels
* Preventing conflicting overlays
* Centralizing UI toggles

---

# states

Stores non-visual logical states tied to windows.

Available flags:

* settingsOpen
* intelligenceWindowOpen

Used for:

* Tracking window lifecycle
* Conditional rendering
* Preventing duplicate instances

---

# Architectural Role

This singleton acts as:

1. Central UI visibility registry
2. Overlay state controller
3. Cross-component coordination layer

All components read from and write to this object to avoid scattered state management.

