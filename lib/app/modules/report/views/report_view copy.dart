import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/report_controller.dart';

class ReportView extends GetView<ReportController> {
  ReportView({Key? key}) : super(key: key);
  final ReportController reportController = Get.put(ReportController());

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
                            "Laporan Harian ",
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
                              Expanded(
                                  child: Obx(
                                () => reportController.status.value ==
                                        Status.running
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : bodyGrafik(),
                              )),
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
      tooltipBehavior: reportController.tooltip.value,
      series: <ChartSeries<ChartData, String>>[
        BarSeries<ChartData, String>(
            dataSource: reportController.listData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            name: 'Laporan',
            color: Colors.white)
      ],
    );
  }

  ListView bodyOld() {
    return ListView.builder(
      itemBuilder: (context, index) {
        GroupReportsModel model = reportController.groupListReports[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.folder_open_rounded,
                color: Colors.white,
                size: 50,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.key.toString(),
                      style: Theme.of(context).primaryTextTheme.titleSmall,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: model.model.length,
                      itemBuilder: (context, index) {
                        ReportsModel listModel = model.model[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                listModel.status,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleSmall,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: Text(
                                ": ${listModel.time}",
                                style:
                                    Theme.of(context).primaryTextTheme.caption,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      itemCount: reportController.groupListReports.length,
    );
  }
}
