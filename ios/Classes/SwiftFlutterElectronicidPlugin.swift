import Flutter
import UIKit
import VideoIDSDK

public class SwiftFlutterElectronicIdPlugin: NSObject, FlutterPlugin {

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
            }
    if call.method == "openVideoID" {
        let config = arguments["configuration"] as Dictionary<String, Any>
        let authorization = config["authorization"] as String
        let endpoint = config["endpoint"] as String
        let language = config["language"] as String
        let document = config["document"] as Int?
        let environment = VideoIDSDK.Environment(url: endpoint, authorization: authorization)
        var videoViewController: VideoIDSDKViewController?

        videoViewController = VideoIDSDKViewController(environment: environment, language: language, docType: document)
        videoViewController?.modalPresentationStyle = .fullScreen
        
        if let controller = videoViewController {
            UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)
        } else {
            self.result?(FlutterError(code: "Editor could not be initialized.", message: nil, details: nil))
        }
    }
      
  }
}
