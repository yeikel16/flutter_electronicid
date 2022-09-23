import Flutter
import UIKit
import VideoID

public class SwiftFlutterElectronicidPlugin: NSObject, FlutterPlugin {
    
public static var registrar: FlutterPluginRegistrar?
public var result: FlutterResult?
public static var instance: SwiftFlutterElectronicidPlugin?
public typealias EIDDict = Dictionary<String, Any>

    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_electronicid", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterElectronicidPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    SwiftFlutterElectronicidPlugin.registrar = registrar
    SwiftFlutterElectronicidPlugin.instance = instance
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let arguments = call.arguments as? EIDDict else { return }

    
    if self.result != nil {
                self.result?(FlutterError(code: "multiple_requests", message: "Cancelled due to multiple requests.", details: nil))
                self.result = nil
            }
    if call.method == "openVideoID" {
        let configuration = arguments["configuration"]
        let environment = VideoID.Environment(url: "", autorization: "")
        var videoViewController: VideoIDViewController?

        videoViewController = VideoIDViewController(environment: environment, language: "de", docType: 52)
        videoViewController?.modalPresentationStyle = .fullScreen
        
        if let controller = videoViewController {
            UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)
        } else {
            self.result?(FlutterError(code: "Editor could not be initialized.", message: nil, details: nil))
        }
    }
      
  }
}
