import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: global

    // Handle Global Ipc's
    IpcHandler {
        function toggleTheme() {
            // Get the current theme
            const currentTheme = Config.runtime.appearance.theme;
            // Determine the new theme
            const newTheme = currentTheme === "light" ? "dark" : "light";
            // Set the new theme
            Config.updateKey("appearance.theme", newTheme);
            genThemeColors.running = true;
        }

        function regenColors() {
            genThemeColors.running = true;
        }

        target: "global"
    }

    Process {
        id: genThemeColors

        command: ["bash", Directories.scriptsPath + "/interface/gencolors.sh", Config.runtime.appearance.background.path, Config.runtime.appearance.colors.scheme, Config.runtime.appearance.theme, Quickshell.shellPath("extras/matugen/config.toml")]
    }

}
