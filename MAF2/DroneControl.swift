    //
//  ProductCommunicationManager.swift
//  DjiMobileSdkTest
//
//  Created by Tobias Wissmüller on 19.11.20.
//

import DJISDK
import Foundation
import os.log

class DroneControl : NSObject, ObservableObject {
//    private let logger = Logger(subsystem: "bundleId", category: "classname")
    
    @Published var connectionState = ConnectionState.DISCONNECTED
    
    @Published var sdkVersion: String = "n/a"
    @Published var aircraftModel: String = "n/a"
    @Published var aircraftFirmwareVersion: String = "n/a"
    
    
    private static var droneSetUp:DroneControl? = nil
    public var aircraft: DJIAircraft?
    private var completion:(Bool) -> Void
    
    public static var instance: DroneControl? {
        return DroneControl.droneSetUp
    }
    
    static func setupDrone(completion:@escaping (Bool)-> Void) {
        DroneControl.droneSetUp = DroneControl(completion:completion)
    }
//    private var componentPublisher: ComponentPublisher
    
    private init(completion:@escaping (Bool)-> Void) {
        self.completion = completion
        self.sdkVersion = DJISDKManager.sdkVersion()
        super.init()
        registerWithSDK()
    }
    
    func registerWithSDK() {
        let appKey = Bundle.main.object(forInfoDictionaryKey: SDK_APP_KEY_INFO_PLIST_KEY) as? String
        
        guard appKey != nil && appKey!.isEmpty == false else {
            NSLog("Please enter your app key in the info.plist")
            return
        }
        DJISDKManager.registerApp(with: self)
    }
    
    func stop() {
        DJISDKManager.stopConnectionToProduct()
    }
}

extension DroneControl : DJISDKManagerDelegate {
    func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
//        logger.info("SDK downloading db file \(progress.completedUnitCount / progress.totalUnitCount)")
    }
    
    func appRegisteredWithError(_ error: Error?) {
        if (error != nil) {
            NSLog("SDK Registered with error \(String(describing: error))")
            return
        }
        
        if (DJISDKManager.startConnectionToProduct()) {
            NSLog("Connection has been started.")
        } else {
            NSLog("There was a problem starting the connection.")
        }
    }
    
    func productConnected(_ product: DJIBaseProduct?) {
        NSLog("Product connected.")
        
        connectionState = .CONNECTED
        completion(true)
        assignProduct(product)
    }
    
    func productChanged(_ product: DJIBaseProduct?) {
        NSLog("Product changed")
        completion(true)
        assignProduct(product)
    }
    
    func productDisconnected() {
        NSLog("Product disconnected")
        completion(false)
        reset()
    }
    
    func assignProduct(_ product: DJIBaseProduct?) {
        guard let aircraft = product as? DJIAircraft else { return }
        
        self.aircraft = aircraft
        
        self.aircraftModel = aircraft.model ?? ""
        aircraft.getFirmwarePackageVersion { version, error in
            self.aircraftFirmwareVersion = version ?? "Unknown"
            if let error = error {
                NSLog("\(error.localizedDescription)")
            }
        }
    }
    
    func reset() {
        connectionState = .DISCONNECTED
        aircraftModel = "n/a"
        aircraftFirmwareVersion = "n/a"
        aircraft = nil
    }
    
//    func componentConnected(withKey key: String?, andIndex index: Int) {
//        componentPublisher.componentConnected(withKey: key, andIndex: index)
//    }
//
//    func componentDisconnected(withKey key: String?, andIndex index: Int) {
//        componentPublisher.componentDisconnected(withKey: key, andIndex: index)
//    }
}
