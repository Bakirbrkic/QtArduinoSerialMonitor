import QtQuick 2.12
import QtQuick.Controls 2.5
import SerialConnection 0.1

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Super Serial Monitor")

    property string portName: ""
    property int baudRate: 6900


    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            text: stackView.depth > 1 ? "\u25C0" : "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop()
                } else {
                    drawer.open()
                }
            }
        }

        Label {
            text: stackView.currentItem.title
            anchors.centerIn: parent
        }
    }

    Drawer {
        id: drawer
        width: window.width * 0.66
        height: window.height

        Column {
            anchors.fill: parent

            ItemDelegate {
                text: qsTr("Terminal Page")
                width: parent.width
                onClicked: {
                    stackView.push("Page1Form.qml", {"portName": portName});
                    drawer.close()
                }
            }
        }
    }

    StackView {
        id: stackView
        initialItem: homeForm
        anchors.fill: parent

    }

    //home form
    Page {
        id: homeForm
        title: qsTr("Select Port")

        Serial{
            id: serial
        }

        Column{
            id: column
            anchors.fill: parent
            spacing: 2

            Label{
                x: column.width*0.5 - width/2
                text: "Available ports:"
            }

            ComboBox{
                id: portDropDown
                x: column.width*0.25
                width: parent.width*0.5

                onCurrentIndexChanged: {
                    //console.log(portDropDown.currentIndex + " " + portDropDown.model[portDropDown.currentIndex]);
                }
            }

            Label{
                x: column.width*0.5 - width/2
                text: "Baud rates:"
            }

            ComboBox{
                id: baudDropDown
                x: column.width*0.25
                width: parent.width*0.5

                onCurrentIndexChanged: {
                    //console.log(baudDropDown.currentIndex + " " + baudDropDown.model[baudDropDown.currentIndex]);
                }
            }

            Button{
                id: connectBtn
                x: column.width*0.25
                width: column.width*0.5
                text: "Connect"

                onPressed: {
                    serial.portName = portDropDown.model[portDropDown.currentIndex];
                    window.portName = portDropDown.model[portDropDown.currentIndex];

                    serial.baudRate = baudDropDown.model[baudDropDown.currentIndex];
                    window.baudRate = baudDropDown.model[baudDropDown.currentIndex];


                    //console.log("Serial.portName is: " + serial.portName + " and baud rate is: " + serial.baudRate);
                    stackView.push("Page1Form.qml", {"portName": portName, "baudRate": baudRate});
                    drawer.close();
                }
            }

            Component.onCompleted: {
                var ports = JSON.parse(serial.AllPortsJSON)
                portDropDown.model = ports.portNames;
                baudDropDown.model = [9600, 115200];
            }
        }
    }
}
