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
    
    //
    public static var instance: DroneControl? {
        return DroneControl.droneSetUp
    }
    
    
    private init(completion:@escaping (Bool)-> Void) {
        
        self.completion = completion
        super.init()
        registerApp()
    }
    
    static func setup(completion:@escaping (Bool)-> Void) {
        DroneControl.droneSetUp = DroneControl(completion:completion)
    }
    
    
    func productConnected(_ product:DJIBaseProduct?) {
        print("PRODUCTED CONNECTED");
        self.product = product
        if product != nil {
            completion(true)
            
        } else {
            print("error connecting to product");
            completion(false)
        }
    }
    
    
    func productDisconnected() {
        completion(false)
    }
    
    //spicy
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
        NSLog(message)
    }
    
    
    func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
        // don't care
    }
}
