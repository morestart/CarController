import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import './widgets/common_textfiled.dart';
import 'package:flutter/material.dart';

class DataOperationPage extends StatefulWidget {
  @override
  _DataOperationPageState createState() => _DataOperationPageState();
}

class _DataOperationPageState extends State<DataOperationPage> {
  TextEditingController address = TextEditingController();
  TextEditingController port = TextEditingController();

  String _ip;
  String _port;

  Future readData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      _ip = preferences.get('ip');
      _port = preferences.get('port');
      address.value = _ip != null
          ? TextEditingValue(text: '$_ip')
          : TextEditingValue(text: '');
      port.value = _port != null
          ? TextEditingValue(text: '$_port')
          : TextEditingValue(text: '');
    });
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('服务端配置'),
        ),
        body: _body());
  }

  Widget _body() {
    return Container(
        margin: EdgeInsets.all(10),
        // decoration: BoxDecoration(
        //   color: Colors.grey[100],
        // ),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                CommonTextFiled(
                    labelText: 'HOST',
                    controller: address,
                    icon: Icon(Icons.supervised_user_circle)),
                CommonTextFiled(
                    labelText: '端口',
                    controller: port,
                    icon: Icon(Icons.portrait)),
                Container(
                  width: window.physicalSize.width,
                  child: RaisedButton(
                    onPressed: () {
                      saveData();
                      Navigator.of(context).pop();
                    },
                    child: Text('完成'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                )
              ],
            )
          ],
        ));
  }

  Future saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String _ip = address.text;
    preferences.setString('ip', _ip);
    print('存储ip为:$_ip');

    String _port = port.text;
    preferences.setString('port', _port);
    print('存储_port为:$_port');
  }
}
