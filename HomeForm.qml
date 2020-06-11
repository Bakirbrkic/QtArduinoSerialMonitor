import QtQuick 2.12
import QtQuick.Controls 2.5
import SerialConnection 0.1

Page {
    title: qsTr("Select Port")
    property string testproperty: "value"

    Serial{
        id: serial
    }

    Column{
        id: column
        anchors.fill: parent
        spacing: 2

        ComboBox{
            id: portDropDown
            x: column.width*0.25
            width: parent.width*0.5

            onCurrentIndexChanged: {
                console.log(portDropDown.currentIndex + " " + portDropDown.model[portDropDown.currentIndex]);
            }
        }

        Button{
            id: connectBtn
            x: column.width*0.25
            width: column.width*0.5
            text: "Connect"

            onPressed: {
                serial.portName = portDropDown.model[portDropDown.currentIndex];

                console.log("Serial.portName is: " + serial.portName + " and baud rate is: " + serial.baudRate);
            }
        }

        Component.onCompleted: {
            var ports = JSON.parse(serial.AllPortsJSON)
            portDropDown.model = ports.portNames;
        }
    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
