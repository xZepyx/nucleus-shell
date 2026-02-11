import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config
import qs.modules.components
import qs.services

ContentMenu {
    title: "Launcher"
    description: "Adjust launcher's settings."

    ContentCard {
        StyledText {
            text: "Filters & Search"
            font.pixelSize: Metrics.pixelSize(20)
            font.bold: true
        }

        StyledSwitchOption {
            title: "Fuzzy Search"
            description: "Enable or disable fuzzy search."
            prefField: "launcher.fuzzySearchEnabled"
        }

        RowLayout {
            id: webEngineSelector

            property string title: "Web Search Engine"
            property string description: "Choose the web search engine for web searches."
            property string prefField: ''

            ColumnLayout {
                StyledText {
                    text: webEngineSelector.title
                    font.pixelSize: Metrics.pixelSize(16)
                }

                StyledText {
                    text: webEngineSelector.description
                    font.pixelSize: Metrics.pixelSize(12)
                }

            }

            Item {
                Layout.fillWidth: true
            }

            StyledDropDown {
                label: "Engine"
                model: ["Google", "Brave", "DuckDuckGo", "Bing"]
                // Set the initial index based on the lowercase value in Config
                currentIndex: {
                    switch (Config.runtime.launcher.webSearchEngine.toLowerCase()) {
                    case "google":
                        return 0;
                    case "brave":
                        return 1;
                    case "duckduckgo":
                        return 2;
                    case "bing":
                        return 3;
                    default:
                        return 0;
                    }
                }
                onSelectedIndexChanged: (index) => {
                    // Update Config with lowercase version of selected model
                    Config.updateKey("launcher.webSearchEngine", model[index].toLowerCase());
                }
            }

        }

    }

}
