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
        backgroundColor: const Color(0xff736879),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 100),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          GanttChartView(
                            maxDuration: const Duration(days: 30 * 30),
                            // maxDuration: const Duration(days: 30),
                            startDate: DateTime(2022, 6, 1),

                            eventHeight: 40,
                            stickyAreaWidth: 200,
                            showStickyArea: showStickyArea,
                            showDays: showDaysRow,
                            events: [
                              GanttAbsoluteEvent(
                                displayName: 'first',
                                startDate: DateTime(2022, 6, 2),
                                endDate: DateTime(2022, 6, 20),
                              ),
                              GanttAbsoluteEvent(
                                displayName: 'second',
                                startDate: DateTime(2022, 6, 2),
                                endDate: DateTime(2022, 6, 20),
                              ),
                              GanttAbsoluteEvent(
                                displayName: 'third',
                                startDate: DateTime(2022, 9, 5),
                                endDate: DateTime(2022, 12, 20),
                              ),
                              GanttAbsoluteEvent(
                                displayName: 'fourth',
                                startDate: DateTime(2022, 6, 2),
                                endDate: DateTime(2022, 10, 20),
                              ),
                              GanttAbsoluteEvent(
                                displayName: 'fifth',
                                startDate: DateTime(2022, 6, 2),
                                endDate: DateTime(2023, 2, 20),
                              ),
                              GanttAbsoluteEvent(
                                displayName: 'sixth',
                                startDate: DateTime(2022, 6, 2),
                                endDate: DateTime(2022, 6, 20),
                              ),
                              GanttAbsoluteEvent(
                                displayName: 'sdsd',
                                startDate: DateTime(2022, 6, 2),
                                endDate: DateTime(2022, 6, 20),
                              ),
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
