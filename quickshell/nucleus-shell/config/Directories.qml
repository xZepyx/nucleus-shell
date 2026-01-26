pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.functions
import QtCore
import QtQuick
import Quickshell

Singleton {
    // XDG Dirs, with "file://"
    readonly property string home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
    readonly property string config: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]
    readonly property string state: StandardPaths.standardLocations(StandardPaths.StateLocation)[0]
    readonly property string cache: StandardPaths.standardLocations(StandardPaths.CacheLocation)[0]
    readonly property string genericCache: StandardPaths.standardLocations(StandardPaths.GenericCacheLocation)[0]
    readonly property string documents: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
    readonly property string downloads: StandardPaths.standardLocations(StandardPaths.DownloadLocation)[0]
    readonly property string pictures: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
    readonly property string music: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
    readonly property string videos: StandardPaths.standardLocations(StandardPaths.MoviesLocation)[0]

    property string shellConfig: FileUtils.trimFileProtocol(`${Directories.config}/nucleus-shell`)
    property string shellConfigName: "configuration.json"
    property string shellConfigPath: `${Directories.shellConfig}/config/${Directories.shellConfigName}`
    property string generatedMaterialThemePath: FileUtils.trimFileProtocol(`${Directories.config}/nucleus-shell/config/colors.json`)
    property string defaultsPath: Quickshell.shellPath("defaults")
    property string scriptsPath: Quickshell.shellPath("scripts")
    property string assetsPath: Quickshell.shellPath("assets")
    // Cleanup on init
    Component.onCompleted: {
        Quickshell.execDetached(["mkdir", "-p", `${shellConfig}`])
        Quickshell.execDetached(["mkdir", "-p", `${shellConfig}/config`])
        Quickshell.execDetached(["mkdir", "-p", `${shellConfig}/plugins`])
    }
}