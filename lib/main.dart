import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main(arg) {
  var argumentList = ["com.test.battery"];
  if (!arg.isEmpty) {
    argumentList = arg;
  }
  runApp(MyApp(argument: argumentList));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.argument});
  final List<String> argument;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(msgID: argument[0]),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.msgID = ''});

  final String msgID;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var navtiveRes;
  var a = "asd";
  Future<void> getInitConfig() async {
    MethodChannel platfom = MethodChannel(widget.msgID);
    try {
      //method_key是插件TestPlugin中onMethodCall回调匹配的key
      String invokeMethodRes = await platfom.invokeMethod('getInitConfig');
      setState(() {
        navtiveRes = invokeMethodRes;
      });
    } on PlatformException catch (e) {
      print(e.toString());
      navtiveRes = '123';
    }
  }

  void outFlutter() {
    if (Platform.isAndroid) {
      // SystemNavigator.pop();
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    } else {
      exit(0);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                constraints: const BoxConstraints.tightFor(
                    width: 270.0, height: 200.0), //卡片大小
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(2.0, 2.0),
                      blurRadius: 4.0,
                    )
                  ],
                ),
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        constraints: const BoxConstraints(
                            minWidth: 270.0, minHeight: 14.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(widget.msgID),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              color: Color.fromARGB(255, 155, 155, 155),
                              onPressed: () {
                                outFlutter();
                              },
                            )
                          ],
                        )),
                    Container(
                      constraints: const BoxConstraints(
                          minWidth: 270.0, minHeight: 14.0),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(17.0),
                      child: Text(navtiveRes == null ? '' : navtiveRes),
                    ),
                    Container(
                      constraints: const BoxConstraints(
                          minWidth: 270.0, minHeight: 45.0),
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(0, 17, 0, 17),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints.tightFor(
                                width: 135.0, height: 45.0),
                            child: TextButton(
                              child: Text("取消"),
                              onPressed: () {
                                outFlutter();
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            constraints: const BoxConstraints(
                                maxWidth: 135.0, minHeight: 45.0),
                            child: TextButton(
                              child: Text("获取uts信息"),
                              onPressed: () {
                                getInitConfig();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
