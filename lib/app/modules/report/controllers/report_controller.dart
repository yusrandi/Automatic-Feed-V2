import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import "package:collection/collection.dart";
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum Status { none, running, stopped, paused }

class ReportController extends GetxController {
  DatabaseReference ref = FirebaseDatabase.instance.ref("reports");
  Rx<Status> status = Status.none.obs;

  RxList<ReportsModel> listReports = <ReportsModel>[].obs;
  RxList<GroupReportsModel> groupListReports = <GroupReportsModel>[].obs;

  String cdate = DateFormat("dd-MM-yyyy").format(DateTime.now());

  final count = 0.obs;

  RxList<ChartData> listData = <ChartData>[].obs;
  Rx<TooltipBehavior> tooltip = TooltipBehavior(enable: true).obs;

  @override
  void onInit() {
    super.onInit();
    index();
  }

  index() async {
    print('today $cdate');

    status.value = Status.running;
    ref.child(cdate).orderByKey().onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );

      data.forEach((key, value) async {
        print("$key:00 value ${value['time']} ${value['value']}");
        double valuesD = value['value'] == 'Sedikit'
            ? 1.0
            : value['value'] == 'Setengah'
                ? 2.0
                : 3.0;
        listData.add(ChartData("$key:00", valuesD));
      });

      listData.sort((a, b) => b.x.compareTo(a.x));
    });

    status.value = Status.stopped;
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}

class ReportsModel {
  String key, date, time, wadah, status;
  int from;
  ReportsModel(
      this.key, this.date, this.time, this.wadah, this.status, this.from);
}

class GroupReportsModel {
  String key;
  List<ReportsModel> model;

  GroupReportsModel(this.key, this.model);
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}
