import Flutter
import UIKit
import VideoIDSDK

public class SwiftFlutterElectronicIdPlugin: NSObject, FlutterPlugin, VideoIDDelegate {

  public static var registrar: FlutterPluginRegistrar?
  public var result: FlutterResult?
  public static var instance: SwiftFlutterElectronicIdPlugin?
  public typealias EIDDict = Dictionary<String, Any>

    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_electronicid", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterElectronicIdPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    SwiftFlutterElectronicIdPlugin.registrar = registrar
    SwiftFlutterElectronicIdPlugin.instance = instance
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let arguments = call.arguments as? EIDDict else { return }

    
    if self.result != nil {
        self.result?(FlutterError(code: "multiple_requests", message: "Cancelled due to multiple requests.", details: nil))
        self.result = nil
    } else {
        self.result = result
    }
    if call.method == "openVideoID" {
        let config = arguments["configuration"] as! Dictionary<String, Any>
        let authorization = config["authorization"] as! String
        let endpoint = config["endpoint"] as! String
        let language = config["language"] as! String
        let document = config["document"] as! NSNumber?
        let environment = VideoIDSDK.SDKEnvironment(url: endpoint, authorization: authorization)

        let viewController = UIApplication.shared.keyWindow?.rootViewController

        DispatchQueue.main.async {
          let view = VideoIDSDK.VideoIDSDKViewController(environment: environment,
            docType: document,
            language: language)
          view.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            view.delegate = self
            viewController?.present(view, animated: true, completion: nil)
        }
    } else if call.method == "checkRequirements" {
        let endpoint = arguments["endpoint"] as! String
        VideoIDSDK.CheckRequirements().check(url: endpoint, service: .videoID) {
            (checkResult:CheckResult) in
                DispatchQueue.main.async {
                    self.result?(checkResult.passed)
                }
            }
    } else {
        self.result?(FlutterMethodNotImplemented)
    }
  }

  public func onComplete(videoID: String) {
    print("flutter_electronicid::videoId complete: " + videoID)
    self.result?(videoID)
    if self.result == nil {
      print("flutter_electronicid::videoId self.result is null")
    }
  }
  public func onError(code: String, message: String?) {
    print("flutter_electronicid::videoId error: ")
    print(message ?? "")
    self.result?(FlutterError(code: code, message: message, details: nil))
  }
}
