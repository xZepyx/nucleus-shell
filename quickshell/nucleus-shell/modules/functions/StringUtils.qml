pragma Singleton
import Quickshell

Singleton {
    id: root

    function shortText(str, len = 25) {
        if (!str)
            return ""
        return str.length > len ? str.slice(0, len) + "..." : str
    }

    function verticalize(text) {
        return text.split("").join("\n")
    }

    function markdownToHtml(md) {
        if (!md) return "";

        let html = md
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/\*\*(.*?)\*\*/g, "<b>$1</b>")           // bold
            .replace(/\*(.*?)\*/g, "<i>$1</i>")               // italic
            .replace(/`([^`]+)`/g, "<code>$1</code>")         // inline code
            .replace(/^### (.*)$/gm, "<h3>$1</h3>")           // headers
            .replace(/```([\s\S]+?)```/g, '<pre style="font-family:monospace">$1</pre>') // code blocks
            .replace(/^## (.*)$/gm, "<h2>$1</h2>")
            .replace(/^# (.*)$/gm, "<h1>$1</h1>")
            .replace(/^- (.*)$/gm, "<li>$1</li>");            // simple lists

        // Wrap list items in <ul> without `s` flag
        html = html.replace(/(<li>[\s\S]*?<\/li>)/g, "<ul>$1</ul>");

        // Replace newlines with <br> for normal text
        html = html.replace(/\n/g, "<br>");

        return html;
    }

}