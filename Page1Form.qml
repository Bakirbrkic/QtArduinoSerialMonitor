import QtQuick 2.12
import QtQuick.Controls 2.5
import SerialConnection 0.1

Page {
    title: qsTr("Termianl Page")
    property string portName: ""
    property int baudRate: 6900

    Column{
        id: column
        anchors.fill: parent
        spacing: 2

        Row{
            id: controlRow
            height: 50
            width: parent.width

            TextField{
                id: tf
                width: parent.width*0.5
                placeholderText: qsTr("Input Message")
                leftPadding: 5
                selectByMouse: enabled
            }

            Button{
                id: send
                width: parent.width*0.25
                text: qsTr("SEND")

                onPressed: {
                    tarea.text += "> " + tf.text + "\n";
                    flickable.contentY = flickable.contentHeight - flickable.height;
                    serial.newMessage = tf.text;
                    tf.text = "";
                }
            }

            Button{
                id: clear
                width: parent.width*0.25
                text: qsTr("Clear Terminal")

                onPressed: {
                    tarea.text = "";
                    flickable.contentY = flickable.contentHeight - flickable.height;
                    //tf.text = "";
                }
            }
        }

        Flickable {
            id: flickable
            width: parent.width
            height: parent.height - controlRow.height



            TextArea.flickable: TextArea {
                id: tarea
                wrapMode: TextArea.Wrap
                selectByMouse: enabled
                padding: 5
            }

            ScrollBar.vertical: ScrollBar { }
        }
    }

    Serial{
        id: serial
    }

    Component.onCompleted: {
        //console.log("passed portname: " + portName);
        serial.AllPortsJSON;
        serial.portName = portName;
        serial.baudRate = baudRate;
        serial.beginSerial;
        //console.log("Serial.portName is: " + serial.portName + " and baud rate is: " + serial.baudRate);
        msgTimer.start();
    }

    Timer{
        id: msgTimer
        interval: 1000
        repeat: true
        running: false

        onTriggered: {
            var m = serial.lastMessage;
            tarea.text += m;
            flickable.contentY = flickable.contentHeight - flickable.height;
        }
    }
}

