import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gantt_chart/gantt_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double dayWidth = 30;
  bool showDaysRow = true;
  bool showStickyArea = true;
  void onZoomIn() {
    setState(() {
      dayWidth += 5;
    });
  }

  void onZoomOut() {
    if (dayWidth <= 10) return;
    setState(() {
      dayWidth -= 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff304869),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 100),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          GanttChartView(
                            // maxDuration: const Duration(days: 30 * 2),
                            maxDuration: const Duration(days: 30),
                            startDate: DateTime(2022, 7, 2),
                            dayWidth: 43,
                            eventHeight: 40,
                            stickyAreaWidth: 200,
                            showStickyArea: showStickyArea,
                            showDays: showDaysRow,
                            events: [
                              GanttRelativeEvent(
                                relativeToStart: const Duration(days: 0),
                                duration: const Duration(days: 0),
                                displayName: 'Fake Event',
                              ),
                              GanttRelativeEvent(
                                relativeToStart: const Duration(days: 0),
                                duration: const Duration(days: 5),
                                displayName:
                                    '1) This is a very long event name',
                              ),
                              GanttRelativeEvent(
                                relativeToStart: const Duration(days: 1),
                                duration: const Duration(days: 6),
                                displayName: '2',
                              ),
                              GanttRelativeEvent(
                                relativeToStart: const Duration(days: 2),
                                duration: const Duration(days: 7),
                                displayName: '3',
                              ),
                              GanttRelativeEvent(
                                relativeToStart: const Duration(days: 3),
                                duration: const Duration(days: 8),
                                displayName: '4',
                              ),
                              GanttRelativeEvent(
                                relativeToStart: const Duration(days: 4),
                                duration: const Duration(days: 9),
                                displayName: '5',
                              ),
                              GanttRelativeEvent(
                                relativeToStart: const Duration(days: 5),
                                duration: const Duration(days: 10),
                                displayName: '6',
                              ),
                              GanttRelativeEvent(
                                relativeToStart: const Duration(days: 6),
                                duration: const Duration(days: 11),
                                displayName: '7',
                              ),
                              GanttRelativeEvent(
                                relativeToStart: const Duration(days: 7),
                                duration: const Duration(days: 12),
                                displayName: '8',
                              ),
                              GanttAbsoluteEvent(
                                displayName: 'Absoulte Date event',
                                startDate: DateTime(2022, 6, 7),
                                endDate: DateTime(2022, 6, 20),
                              )
                            ],
                          ),
                        ],
                      ),
                    ])))
        // floatingActionButton: FloatingActionButton(
        //   onPressed: onZoomIn,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
