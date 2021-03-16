import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:bluetooth_obd/bluetooth_obd.dart';

import 'model.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  // 定义一个 int 型变量，用于保存计算结果
  int _calculateResult;
  String _tripRecords = 'Unknown';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String tripRecords;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await BluetoothObd.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    try {
      tripRecords = await BluetoothObd.tripRecord;
    } on PlatformException {
      tripRecords = 'Failed to get tripRecords.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // init 的时候，计算一下 10 + 10 的结果
    _calculateResult = await BluetoothObd.calculate(10, 10);
    setState(() {
      _platformVersion = platformVersion;
      _tripRecords = tripRecords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(context.watch<Counter>().platformVersion),
                // 输出该结果
                Text(context.watch<Counter>().calculateResult.toString()),
                // Text(context.watch<Counter>().tripRecords),
                Text('tripRecords Result: $_tripRecords\n'),
                Count(),
                FlatButton(
                  child: Text("启动obd连接"),
                  onPressed: () => context.read<Counter>().startOBD(),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          key: const Key('increment_floatingActionButton'),

          /// Calls `context.read` instead of `context.watch` so that it does not rebuild
          /// when [Counter] changes.
          onPressed: () => context.read<Counter>().increment(),
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class Count extends StatelessWidget {
  const Count({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(

        /// Calls `context.watch` to make [Count] rebuild when [Counter] changes.
        '${context.watch<Counter>().count}',
        key: const Key('counterState'),
        style: Theme.of(context).textTheme.headline4);
  }
}
