import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import cn.qiditu 1.0

ApplicationWindow {
    visible: true
    width: 600
    height: 280
    title: qsTr("Hello World")

    Item {
        id: root;
        state: "unconnect";
        anchors.fill: parent;

        Column {
            id: column;
            anchors.left: parent.left;
            anchors.top: parent.top;
            anchors.leftMargin: 20;
            anchors.topMargin: 20;

            RowLayout {
                Text {
                    text: qsTr("IP：");
                    font.pixelSize: 30;
                }

                ComboBox {
                    id: network;
                    textRole: "IPV4";
                    model: ListModel {
                        id: networkModel;
                    }
                    Component.onCompleted: {
                        var array = CPPHelper.networkList();
                        if(array.length > 0) {
                            networkModel.append(array);
                            currentIndex = 0;
                        }
                    }
                }

                Text {
                    text: qsTr("运营商：");
                    font.pixelSize: 30;
                    Layout.leftMargin: 5;
                }

                ComboBox {
                    id: serviceProvider;
                    currentIndex: 0;
                    textRole: "name";
                    model: ListModel {
                        id: serviceProviderModel;

                        ListElement {
                            name: qsTr("联通");
                            value: 0x01;
                        }
                        ListElement {
                            name: qsTr("电信");
                            value: 0x02;
                        }
                        ListElement {
                            name: qsTr("移动");
                            value: 0x03;
                        }
                    }
                }
            }

            RowLayout {
                Text {
                    text: qsTr("用户名：");
                    font.pixelSize: 30;
                }

                TextField {
                    id: username;
                    width: 240;
                    Layout.fillWidth: true;
                }
            }

            RowLayout {
                Text {
                    text: qsTr("密   码：");
                    font.pixelSize: 30;
                }

                TextField {
                    id: password;
                    width: 240;
                    echoMode: TextInput.Password;
                }
            }

            Row {
                spacing: 20
                enabled: false;
                CheckBox {
                    text: qsTr("记住用户名");
                }

                CheckBox {
                    text: qsTr("记住密码");
                }

                CheckBox {
                    text: qsTr("自动登录");
                }

                CheckBox {
                    text: qsTr("开机自启");
                }
            }

            Row {
                id: rowBtns;

                Button {
                    text: qsTr("连接");
                    highlighted: true;
                    visible: root.state == "unconnect";
                    readonly property int value: 0x00;
                    onClicked: {
                        rowBtns.connect(value);
                    }
                }

                Button {
                    text: qsTr("断开");
                    highlighted: true;
                    visible: root.state == "connected";
                    readonly property int value: 0x01;
                    onClicked: {
                        rowBtns.connect(value);
                    }
                }

                function connect(i) {
                    var index = network.model.get(network.currentIndex);
                    var index2 = serviceProvider.model.get(serviceProvider.currentIndex);
                    var data = {"ip": index.IPV4, "mac": index.MAC, "service": index2.value, "connect": i};
                    server.connect(data);
                }
            }
        }

        Server {
            id: server;
        }
    }

}
