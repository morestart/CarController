import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car/widgets/common_textfiled.dart';
import 'package:flutter/material.dart';

class BtnDataChangePage extends StatefulWidget {
  @override
  _BtnDataChangePageState createState() => _BtnDataChangePageState();
}

class _BtnDataChangePageState extends State<BtnDataChangePage> {
  TextEditingController top = TextEditingController();
  TextEditingController down = TextEditingController();
  TextEditingController left = TextEditingController();
  TextEditingController right = TextEditingController();

  String _topBtn;
  String _downBtn;
  String _leftBtn;
  String _rightBtn;

  Future readData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      _topBtn = preferences.get('topData');
      _downBtn = preferences.get('downData');
      _leftBtn = preferences.get('leftData');
      _rightBtn = preferences.get('rightData');

      top.value = _topBtn != null
          ? TextEditingValue(text: '$_topBtn')
          : TextEditingValue(text: '');

      down.value = _downBtn != null
          ? TextEditingValue(text: '$_downBtn')
          : TextEditingValue(text: '');

      left.value = _leftBtn != null
          ? TextEditingValue(text: '$_leftBtn')
          : TextEditingValue(text: '');

      right.value = _rightBtn != null
          ? TextEditingValue(text: '$_rightBtn')
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
          title: Text('修改按钮默认数据'),
        ),
        body: _body());
  }

  Widget _body() {
    return Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                CommonTextFiled(
                    labelText: 'Top',
                    controller: top,
                    icon: Icon(Icons.arrow_upward)),
                CommonTextFiled(
                    labelText: 'Down',
                    controller: down,
                    icon: Icon(Icons.arrow_downward)),
                CommonTextFiled(
                    labelText: 'Left',
                    controller: left,
                    icon: Icon(Icons.arrow_back)),
                CommonTextFiled(
                    labelText: 'Right',
                    controller: right,
                    icon: Icon(Icons.arrow_forward)),
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

    preferences.setString('topData', top.text);
    preferences.setString('downData', down.text);
    preferences.setString('leftData', left.text);
    preferences.setString('rightData', right.text);
  }
}
