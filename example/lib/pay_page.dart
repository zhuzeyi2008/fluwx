import 'dart:convert';
import 'dart:io' as H;

import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

class PayPage extends StatefulWidget {
  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  String _url = "https://wxpay.wxutil.com/pub_v2/app/app_pay.php";
  Fluwx _fluwx;
  String _result = "无";

  @override
  void initState() {
    super.initState();
    _fluwx = new Fluwx();
    _fluwx.response.listen((data) {
      setState(() {
        _result = data.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("pay"),
      ),
      body: Column(
        children: <Widget>[
          OutlineButton(
            onPressed: () async {
              var h = H.HttpClient();
              h.badCertificateCallback = (cert, String host, int port) {
                return true;
              };
              var request = await h.getUrl(Uri.parse(_url));
              var response = await request.close();
              var data = await response.transform(Utf8Decoder()).join();
              Map<String, dynamic> result = json.decode(data);
              print(result['appid']);
              _fluwx.pay(
                WeChatPayModel(
                  appId: result['appid'].toString(),
                  partnerId: result['partnerid'].toString(),
                  prepayId: result['prepayid'].toString(),
                  packageValue: result['package'].toString(),
                  nonceStr: result['noncestr'].toString(),
                  timeStamp: result['timestamp'].toString(),
                  sign: result['sign'].toString(),
                ),
              ).then((data){
                print("---》$data");
              });
            },
            child: const Text("pay"),
          ),
          const Text("响应结果;"),
          Text(_result)
        ],
      ),
    );
  }
}