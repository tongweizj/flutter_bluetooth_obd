import 'package:bluetooth_obd_example/widget_card.dart';
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
  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('OBD READER'),
              actions: [
                IconButton(
                  tooltip: 'connect OBD',
                  icon: const Icon(
                    Icons.bluetooth,
                  ),
                  onPressed: () => context.read<Counter>().startOBD(),
                ),
                IconButton(
                  tooltip: 'Refresh OBD Data',
                  icon: const Icon(
                    Icons.refresh,
                  ),
                  onPressed: () => context.read<Counter>().increment(),
                ),
                IconButton(
                  tooltip: 'starterAppTooltipSearch',
                  icon: const Icon(
                    Icons.bluetooth_disabled,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            body: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 2,
              children: List.generate(6, (index) {
                return buildCard(context.watch<Counter>().obdData['$index'][0],
                    context.watch<Counter>().obdData['$index'][1]);
              }),
            )));
  }
}

class Count extends StatelessWidget {
  const Count({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(

        /// Calls `context.watch` to make [Count] rebuild when [Counter] changes.
        '${context.watch<Counter>().count}',
        key: const Key('counterState'),
        style: Theme.of(context).textTheme.headline4);
  }
}
