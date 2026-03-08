import QtQuick
import Quickshell
import qs.config
pragma Singleton


/*

    This service primarily resolves configs for widgets that are customizable per monitor.

*/


Singleton {

    function bar(displayName) {
        const displays = Config.runtime.monitors;
        const fallback = Config.runtime.bar;
        if (!displays || !displays[displayName] || !displays[displayName].bar || displayName === "")
            return fallback;

        return displays[displayName].bar;
    }

    function getBarConfigurableHandle(displayName) { // returns prefField string
        const displays = Config.runtime.monitors;

        if (!displays || !displays[displayName] || !displays[displayName].bar || displayName === "")
            return "bar";

        return "monitors." + displayName + ".bar";
    }

}
