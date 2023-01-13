import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum Status { none, running, stopped, paused }

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  List<ChartData> listData = <ChartData>[];
  TooltipBehavior tooltip = TooltipBehavior(enable: true);

  String cdate = DateFormat("dd-MM-yyyy").format(DateTime.now());

  Status status = Status.none;

  DatabaseReference ref = FirebaseDatabase.instance.ref("reports");

  String cdateLabel =
      DateFormat("EEEE, dd-MM-yyyy", "id_ID").format(DateTime.now());

  index(String date) async {
    print('today $date');

    status = Status.running;
    listData.clear();
    ref.child(cdate).orderByKey().onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );

      data.forEach((key, value) async {
        print("${key} value ${value['time']} ${value['value']}");
        double valuesD = value['value'] == 'Sedikit'
            ? 1.0
            : value['value'] == 'Setengah'
                ? 2.0
                : 3.0;
        listData.add(ChartData("$key:00", valuesD));
      });

      listData.sort((a, b) => b.x.compareTo(a.x));
      setState(() {});
    });

    status = Status.stopped;
  }

  @override
  void initState() {
    index(cdate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const Radius radius = Radius.circular(100);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Center(),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: radius),
                        color: Colors.black,
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: radius),
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
            Column(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      width: size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: radius),
                        color: Colors.black,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 50),
                          Text(
                            "Laporan Harian",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headlineMedium,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 5,
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 70, right: 20, bottom: 100, top: 20),
                          padding: const EdgeInsets.only(right: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.red.withOpacity(0.5),
                          ),
                        ),
                        Container(
                          width: size.width,
                          margin: const EdgeInsets.only(
                              left: 20, right: 40, bottom: 90),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.red,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        onChanged: (date) {
                                      if (kDebugMode) {
                                        print(
                                            'change $date in time zone ${date.timeZoneOffset.inHours}');
                                      }
                                    }, onConfirm: (date) {
                                      print('confirm $date');

                                      setState(() {
                                        cdate =
                                            DateFormat("dd-MM-yyyy", "id_ID")
                                                .format(date);
                                        cdateLabel = DateFormat(
                                                "EEEE, dd-MM-yyyy", "id_ID")
                                            .format(date);

                                        print(
                                            'confirm format $cdateLabel and $cdate');
                                      });

                                      index(cdate);
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.id);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        cdateLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.edit_calendar_outlined,
                                          color: Colors.white),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: status == Status.running
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : bodyGrafik(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "1: Sedikit",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .titleSmall,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "2: Setengah",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .titleSmall,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "3: Penuh",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .titleSmall,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bodyGrafik() {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(minimum: 0, maximum: 4, interval: 1),
      tooltipBehavior: tooltip,
      series: <ChartSeries<ChartData, String>>[
        BarSeries<ChartData, String>(
            dataLabelSettings:
                const DataLabelSettings(isVisible: true, color: Colors.yellow),
            dataSource: listData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            name: 'Laporan',
            color: Colors.yellow)
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}
