import 'package:automatic_feed/app/modules/home/views/home_view.dart';
import 'package:automatic_feed/app/modules/report/views/report_view.dart';
import 'package:automatic_feed/app/modules/schedule/views/schedule_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/base_controller.dart';

class BaseView extends GetView<BaseController> {
  const BaseView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Obx(() => controller.count.value == 0
                ? HomeView()
                : controller.count.value == 1
                    ? ReportView()
                    : controller.count.value == 2
                        ? ScheduleView()
                        : HomeView()),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(height: 70, child: _tabItem()),
          )
        ],
      ),
    );
  }

  _tabItem() {
    return Obx((() => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _listItem(Icons.home_max_rounded, 0)),
            Expanded(child: _listItem(Icons.list_rounded, 1)),
            Expanded(child: _listItem(Icons.settings, 2)),
          ],
        )));
  }

  _listItem(IconData icon, int index) {
    return GestureDetector(
        onTap: () => controller.count.value = index,
        child: Container(
            child: Icon(
          icon,
          size: 30,
          color: controller.count.value == index ? Colors.black : Colors.grey,
        )));
  }
}
