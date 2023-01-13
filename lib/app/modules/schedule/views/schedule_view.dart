import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/schedule_controller.dart';

class ScheduleView extends GetView<ScheduleController> {
  ScheduleView({Key? key}) : super(key: key);
  final ScheduleController scheduleController = Get.put(ScheduleController());
  @override
  Widget build(BuildContext context) {
    const Radius radius = Radius.circular(100);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            baseBackground(),
            containerBackgroundRadius(radius),
            Column(
              children: [
                Expanded(flex: 1, child: containerTitle(size, radius, context)),
                Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 70, right: 20, bottom: 100, top: 50),
                          padding: const EdgeInsets.only(right: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.red.withOpacity(0.5),
                          ),
                        ),
                        containerContent(size, context),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container containerContent(Size size, BuildContext context) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.only(left: 20, right: 40, bottom: 90),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.red,
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => scheduleController.status.value == Status.running
                      ? Container(
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              const Divider(color: Colors.white),
                          itemBuilder: (context, index) {
                            SchedulesModel model =
                                scheduleController.listSchedules[index];
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          model.time.toString(),
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .titleLarge,
                                        ),
                                        Text(
                                          model.greeting.toString(),
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .titleSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Switch(
                                          value: model.isactive,
                                          onChanged: (value) {
                                            scheduleController.updateData(
                                                model, value);
                                          },
                                          activeTrackColor:
                                              Colors.white.withOpacity(0.7),
                                          activeColor: Colors.white,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            DatePicker.showTimePicker(context,
                                                showTitleActions: true,
                                                onChanged: (date) {
                                              print(
                                                  'change $date in time zone ' +
                                                      date.timeZoneOffset
                                                          .inHours
                                                          .toString());
                                            }, onConfirm: (date) {
                                              print('confirm $date');
                                              String cdate = DateFormat("HH:mm")
                                                  .format(date);
                                              String greeting = "";
                                              int hours = date.hour;

                                              if (hours >= 1 && hours <= 12) {
                                                greeting = "Pakan Pagi";
                                              } else if (hours >= 12 &&
                                                  hours <= 16) {
                                                greeting = "Pakan Siang";
                                              } else if (hours >= 16 &&
                                                  hours <= 21) {
                                                greeting = "Pakan Sore";
                                              } else if (hours >= 21 &&
                                                  hours <= 24) {
                                                greeting = "Pakan Malam";
                                              }

                                              print(
                                                  'confirm format $cdate hour ${date.hour} greeting $greeting');

                                              scheduleController.updateTimeData(
                                                  model.key, cdate, greeting);
                                            }, currentTime: DateTime.now());
                                          },
                                          child: const Icon(
                                              Icons.edit_calendar_outlined,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () => scheduleController
                                              .deleteData(model.key),
                                          child: const Icon(Icons.close_rounded,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: scheduleController.listSchedules.length,
                        ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () {
                  DatePicker.showTimePicker(context,
                      showTitleActions: true,
                      onChanged: (date) {}, onConfirm: (date) {
                    print('confirm $date');
                    String cdate = DateFormat("HH:mm").format(date);
                    String greeting = "";
                    int hours = date.hour;

                    if (hours >= 1 && hours <= 12) {
                      greeting = "Pakan Pagi";
                    } else if (hours >= 12 && hours <= 16) {
                      greeting = "Pakan Siang";
                    } else if (hours >= 16 && hours <= 21) {
                      greeting = "Pakan Sore";
                    } else if (hours >= 21 && hours <= 24) {
                      greeting = "Pakan Malam";
                    }

                    print(
                        'confirm format $cdate hour ${date.hour} greeting $greeting');

                    scheduleController.store(cdate, greeting);
                  }, currentTime: DateTime.now());
                },
                foregroundColor: Colors.white,
                focusColor: Colors.white,
                backgroundColor: Colors.white,
                child: const Icon(Icons.alarm_add_rounded, color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container containerTitle(Size size, Radius radius, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: radius),
        color: Colors.black,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Text(
            "Jadwal Pemberian\nPakan",
            style: Theme.of(context).primaryTextTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Column containerBackgroundRadius(Radius radius) {
    return Column(
      children: [
        Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: radius),
                color: Colors.black,
              ),
            )),
        Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: radius),
                color: Colors.white,
              ),
            )),
      ],
    );
  }

  Row baseBackground() {
    return Row(
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
    );
  }
}
