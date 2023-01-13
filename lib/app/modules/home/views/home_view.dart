import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:get/get.dart';
import 'package:gradient_progress_indicator/gradient_progress_indicator.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    // homeController.index();
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
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'HomeView is working',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Obx(
                            () => controller.status.value == Status.running
                                ? CircularProgressIndicator()
                                : Text(
                                    '${controller.status.value}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'HomeView is working',
                            style: TextStyle(fontSize: 20),
                          ),
                          Obx(
                            () => controller.status.value == Status.running
                                ? CircularProgressIndicator()
                                : Text(
                                    '${controller.status.value}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                          )
                        ],
                      ),
                    ),
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
                            "Automatic \nChicken Farm",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Manage your feeding storage",
                            style: Theme.of(context).primaryTextTheme.caption,
                          ),
                          Text(
                            "and schedule",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .caption!
                                .copyWith(color: Colors.orange),
                          )
                        ],
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 70, right: 40, bottom: 120, top: 30),
                          padding: const EdgeInsets.only(right: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.red.withOpacity(0.5),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 50, right: 60, bottom: 100),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.red,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Your Storage",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleLarge,
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () async {
                                  final service = FlutterBackgroundService();
                                  var isRunning = await service.isRunning();

                                  print('is Running $isRunning');

                                  if (isRunning) {
                                    service.invoke("stopService");
                                  }

                                  if (!isRunning) {
                                    print('Stop Service');
                                  } else {
                                    print('Start Service');
                                  }
                                },
                                child: GradientProgressIndicator(
                                  radius: 120,
                                  duration: 3,
                                  strokeWidth: 15,
                                  gradientStops: const [
                                    0.2,
                                    0.8,
                                  ],
                                  gradientColors: const [
                                    Colors.white,
                                    Colors.grey,
                                  ],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Obx(
                                            () => Text(
                                              homeController
                                                  .tampunganValue.value
                                                  .toStringAsFixed(2),
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .displaySmall,
                                            ),
                                          ),
                                          Text(
                                            'Kg',
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .caption,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'isi tampungan',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .caption,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Text(
                              //   "- error message",
                              //   style:
                              //       Theme.of(context).primaryTextTheme.caption,
                              // ),
                              // const SizedBox(height: 16),
                              // Obx(
                              //   () => Text(
                              //     homeController.errorTampunganValue.value,
                              //     style: Theme.of(context)
                              //         .primaryTextTheme
                              //         .caption,
                              //   ),
                              // ),
                              // Obx(
                              //   () => Text(
                              //     homeController.errorWadah.value,
                              //     style: Theme.of(context)
                              //         .primaryTextTheme
                              //         .caption,
                              //   ),
                              // )
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
}
