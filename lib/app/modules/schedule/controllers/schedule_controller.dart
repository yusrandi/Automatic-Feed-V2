import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

enum Status { none, running, stopped, paused }

class ScheduleController extends GetxController {
  DatabaseReference refSchedule = FirebaseDatabase.instance.ref("schedules");
  Rx<Status> status = Status.none.obs;

  RxList<SchedulesModel> listSchedules = <SchedulesModel>[].obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    index();
  }

  index() async {
    status.value = Status.running;
    refSchedule.onValue.listen((event) {
      if (event.snapshot.exists) {
        final data = Map<String, dynamic>.from(
          event.snapshot.value as Map,
        );
        if (data.isNotEmpty) {
          listSchedules.clear();

          data.forEach((key, value) async {
            print("${key} value ${value['greeting']}");
            listSchedules.add(SchedulesModel(
                key, value['time'], value['greeting'], value['isactive']));
          });

          listSchedules.sort((a, b) => a.time.compareTo(b.time));
        }
      }
    });
    status.value = Status.stopped;
  }

  store(String time, String greeting) async {
    status.value = Status.running;

    await refSchedule.push().set({
      "time": time,
      "greeting": greeting,
      "isactive": false,
    });

    status.value = Status.stopped;
  }

  updateData(SchedulesModel model, bool isactive) async {
    status.value = Status.running;

    await refSchedule.child(model.key).update({
      "isactive": isactive,
    });

    status.value = Status.stopped;
  }

  deleteData(String key) async {
    status.value = Status.running;

    await refSchedule.child(key).remove();

    status.value = Status.stopped;
  }

  updateTimeData(String key, String time, String greeting) async {
    status.value = Status.running;

    await refSchedule.child(key).update({
      "time": time,
      "greeting": greeting,
    });

    status.value = Status.stopped;
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

class SchedulesModel {
  String key, time, greeting;
  bool isactive;

  SchedulesModel(this.key, this.time, this.greeting, this.isactive);
}
