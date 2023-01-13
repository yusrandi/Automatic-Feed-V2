import UIKit
import Flutter
import flutter_background_service_ios

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var methodChannel: FlutterMethodChannel!

    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    SwiftFlutterBackgroundServicePlugin.taskIdentifier = "dev.flutter.background.refresh"
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
            methodChannel = FlutterMethodChannel(name: "internet_speed_test",
                                                 binaryMessenger: controller.binaryMessenger)
            
            methodChannel.setMethodCallHandler({
                [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
                // This method is invoked on the UI thread.
                //        guard call.method == "cellinfo" else {
                //          result(FlutterMethodNotImplemented)
                //          return
                //        }
                //        self?.receiveBatteryLevel(result: result)
                
                switch call.method {
                case "tes":
                    // 3
                    result("this is from ios")
                    
                default:
                    // 4
                    result(FlutterMethodNotImplemented)
                }
            })
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
