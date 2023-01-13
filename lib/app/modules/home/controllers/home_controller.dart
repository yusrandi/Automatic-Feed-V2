import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum Status { none, running, stopped, paused }

class HomeController extends GetxController {
  Rx<Status> status = Status.none.obs;
  DatabaseReference ref = FirebaseDatabase.instance.ref("Data_tampungan");

  DatabaseReference refWadah = FirebaseDatabase.instance.ref("Data_wadah");

  RxDouble tampunganValue = 0.0.obs;
  RxString errorTampunganValue = "...".obs;

  RxString errorWadah = "".obs;

  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    index();
    indexWadah();
  }

  index() async {
    status.value = Status.running;
    ref.onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );
      print(data['isi_tampungan']);
      tampunganValue.value = data['isi_tampungan'];
      errorTampunganValue.value = data['Pesan_error'].toString();
    });
    status.value = Status.stopped;
  }

  indexWadah() async {
    status.value = Status.running;
    errorWadah.value = "";
    refWadah.onValue.listen((event) {
      if (event.snapshot.exists) {
        final data = Map<String, dynamic>.from(
          event.snapshot.value as Map,
        );

        errorWadah.value = "";

        print('data[Atas_wadah_1] ${data['Bawah_wadah_1']}');
        if (!data['Bawah_wadah_1']) {
          errorWadah.value += "Wadah 1 kosong atau sensor sedang bermasalah";
          Get.snackbar(
            "Automatic Feed",
            errorWadah.value,
            icon: const Icon(Icons.person, color: Colors.white),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.white,
          );
        }
        // if (!data['Bawah_wadah_2']) {
        //   errorWadah.value += "\nWadah 2 kosong atau sensor sedang bermasalah";
        // }
        // if (!data['Bawah_wadah_3']) {
        //   errorWadah.value += "\nWadah 3 kosong atau sensor sedang bermasalah";
        // }
      }
    });
    status.value = Status.stopped;
  }

  store() async {
    status.value = Status.running;
    // await ref.push().set(model.toJson());
    await ref.push().set({
      "name": "John IOS ",
      "age": 18,
      "address": {"line1": "100 Mountain View"}
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
