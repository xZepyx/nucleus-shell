pragma Singleton
import Quickshell

Singleton {
    id: root


    function isVideo(path) {
        if (!path)
            return false

        // Convert QUrl → string if needed
        let p = path.toString ? path.toString() : path

        // Strip file://
        if (p.startsWith("file://"))
            p = p.replace("file://", "")

        const ext = p.split(".").pop().toLowerCase()

        return [
            "mp4",
            "mkv",
            "webm",
            "mov",
            "avi",
            "m4v"
        ].includes(ext)
    }

    
}