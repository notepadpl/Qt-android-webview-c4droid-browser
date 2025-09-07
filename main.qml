import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebView 1.1

ApplicationWindow {
    visible: true
    width: 360
    height: 640
    title: qsTr("Mini Przeglądarka Qt")

    Rectangle {
        anchors.fill: parent
        color: "white"

        Column {
            anchors.fill: parent
            spacing: 0

            // Pasek nawigacji z przyciskami i adresem
            Row {
                id: navBar
                width: parent.width
                height: 56   // zwiększona wysokość
                spacing: 4
                padding: 4

                Button {
                    text: "<"
                    width: 40
                    onClicked: webView.goBack()
                    enabled: webView.canGoBack
                }

                Button {
                    text: ">"
                    width: 40
                    onClicked: webView.goForward()
                    enabled: webView.canGoForward
                }

                Button {
                    text: "⟳"
                    width: 40
                    onClicked: webView.reload()
                }

                Button {
                    text: "</>"
                    width: 50
                    onClicked: {
                        webView.evaluateJavaScript("document.documentElement.outerHTML", function(result) {
                            sourceText.text = result
                            sourceDialog.open()
                        })
                    }
                }

                TextField {
                    id: addressBar
                    text: webView.url.toString()
                    width: parent.width - (40 + 40 + 40 + 50 + 32) // szerokość przycisków + spacing/padding
                    height: parent.height - 8
                    font.pixelSize: 14
                    placeholderText: "Adres strony"

                    onAccepted: {
                        var url = text.trim()
                        if (!url.startsWith("http"))
                            url = "http://" + url
                        webView.url = url
                    }
                }
            }

            // WebView
            WebView {
                id: webView
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top: navBar.bottom

                url: "https://go.hifun.chat/main/party"

                onUrlChanged: {
                    addressBar.text = url.toString()
                }
            }
        }

        // Dialog ze źródłem strony
        Dialog {
            id: sourceDialog
            width: parent.width * 0.95
            height: parent.height * 0.8
            modal: true
            title: "Źródło strony"
            standardButtons: Dialog.Ok

            ScrollView {
                anchors.fill: parent

                TextArea {
                    id: sourceText
                    text: "Ładowanie..."
                    readOnly: true
                    wrapMode: TextArea.NoWrap
                    font.family: "monospace"
                    font.pixelSize: 12
                }
            }
        }
    }
}
