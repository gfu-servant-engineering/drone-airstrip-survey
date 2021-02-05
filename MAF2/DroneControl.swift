import Foundation
import UIKit
import DJISDK

/*
 A singleton class that gets the drone set up.
 */
class DroneControl : NSObject, DJISDKManagerDelegate {
    private static var droneSetUp:DroneControl? = nil
    public var product:DJIBaseProduct? = nil
    private var completion:(Bool) -> Void
    // delete when no longer needing viewController
    private var viewController: UIViewController? = nil
    
    
    public static var instance: DroneControl? {
        return DroneControl.droneSetUp
    }
    
    // update when no longer needing viewController
    private init(_ viewController: UIViewController, completion:@escaping (Bool)-> Void) {
        // update when no longer needing viewController
        self.viewController = viewController
        self.completion = completion
        super.init()
        registerApp()
    }
    
    // update when no longer needing viewController
    static func setup(_ viewController: UIViewController, completion:@escaping (Bool)-> Void) {
        // update here too
        DroneControl.droneSetUp = DroneControl(viewController, completion:completion)
    }
    
    
    func productConnected(_ product:DJIBaseProduct?) {
        showAlertViewWithTitle(title: "DEBUGGER", withMessage: "Made It!")
        var message:String = "Product Connected!"
        self.product = product
        if product != nil {
            showAlertViewWithTitle(title: "DEBUGGER", withMessage: message)
            completion(true)
            
        } else {
            message = "Product Not Connected!"
            showAlertViewWithTitle(title: "DEBUGGER", withMessage: message)
            completion(false)
        }
    }
    
    
    func productDisconnected() {
        completion(false)
    }
    
    
    func registerApp() {
        DJISDKManager.registerApp(with: self)
    }

    
    public func appRegisteredWithError(_ error: Error?) {
        var message:String = "Register App Successed!"
        if (error != nil) {
            message = "Register App Failed! Please enter your App Key and check the network."
        }
        else {
            
            let result = DJISDKManager.startConnectionToProduct()
            if result {
                NSLog("registerAppSuccess")
            } else {
                message = "Register app succeeded, connection start failed!"
                completion(false)
            }
        }
        showAlertViewWithTitle(title: "DEBUGGER", withMessage: message)
    }
    
    
    func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
        // don't care
    }
    
    // this needs to be deleted later on (DEBUGGING)
    func showAlertViewWithTitle(title:String, withMessage message:String ) {
        guard let viewController = viewController else { return }
        let alert:UIAlertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertController.Style.alert)
        let okAction:UIAlertAction = UIAlertAction(title:"Ok", style:UIAlertAction.Style.`default`, handler:nil)
        alert.addAction(okAction)
        viewController.present(alert, animated:true, completion:nil)
    }
}
