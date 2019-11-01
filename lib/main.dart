import 'package:car/data_operation.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String recv = '';
  String timeNow = '';
  String _ip = '192.168.4.1';
  String _port = '8000';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future readData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      _ip = preferences.get('ip');
      _port = preferences.get('port');
      print('读取到ip为:$_ip');
      print('读取到port为:$_port');
    });
  }

  @override
  void initState() {
    super.initState();
    recv = '暂无数据';
    timeNow = DateUtil.formatDate(DateTime.now(), format: "HH:mm:ss");
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Controller Test'),
          centerTitle: true,
          actions: <Widget>[_myPopMenu()],
        ),
        key: _scaffoldKey,
        body: SafeArea(
            child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            children: <Widget>[
              Center(
                child: customButton(Icons.keyboard_arrow_up, () {
                  connectServer("forward");
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 80),
                    child: customButton(Icons.keyboard_arrow_left, () {
                      connectServer("turnLeft");
                    }),
                  ),
                  customButton(Icons.keyboard_arrow_right, () {
                    connectServer("turnRight");
                  }),
                ],
              ),
              Center(
                child: customButton(Icons.keyboard_arrow_down, () {
                  connectServer("backward");
                }),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: SizedBox(
                  height: 60,
                  child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(14.0))),
                      child: ListTile(
                          title: Row(
                            children: <Widget>[
                              Text('Data From Server:'),
                              Text('   '),
                              Text(
                                '$recv',
                                style: TextStyle(color: Colors.blue),
                              ),
                              Text('   '),
                              Text(
                                '[$timeNow]',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          leading: Icon(Icons.message, color: Colors.green))),
                ),
              )
            ],
          ),
        )));
  }

  Widget _myPopMenu() {
    return PopupMenuButton<String>(
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                  value: 'addConfig', child: new Text('添加配置')),
              PopupMenuItem<String>(
                  value: 'removeConfig', child: new Text('删除配置')),
            ],
        onSelected: (String value) {
          if (value == 'addConfig') {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => DataOperationPage()));
                readData();
          } else if (value == 'removeConfig') {
            removeData();
            print('remove');
          }
        });
  }

  Future removeData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('userName');
    preferences.remove('password');
    print('删除acount成功');
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('配置已删除'),
      duration: Duration(seconds: 1),
    ));
  }

  Widget customButton(IconData iconData, Function f) {
    return Container(
      child: RaisedButton(
          splashColor: Colors.white,
          color: Colors.green,
          onPressed: f,
          child: Icon(
            iconData,
            size: 70,
            color: Colors.white,
          ),
          shape: CircleBorder(side: BorderSide(color: Colors.green))),
    );
  }

  Future connectServer(String data) async {
    try {
      Socket socket = await Socket.connect('$_ip', int.parse(_port),
          timeout: Duration(seconds: 5));
      print('connected');
      socket.listen((List<int> event) {
        print(utf8.decode(event));
        setState(() {
          recv = utf8.decode(event);
          timeNow = DateUtil.formatDate(DateTime.now(), format: "HH:mm:ss");
          print(timeNow);
        });
      });
      socket.add(utf8.encode('$data'));
      socket.close();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('数据发送成功'),
        duration: Duration(seconds: 1),
      ));
    } on Exception catch (e) {
      print(e);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('数据发送失败,请检查服务端是否开启'),
        duration: Duration(seconds: 1),
      ));
    }
  }
}
