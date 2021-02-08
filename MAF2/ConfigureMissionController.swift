//
//  ConfigureMissionController.swift
//  MAF2
//
//  Created by Admin on 1/20/21.
//  Copyright © 2021 Admin. All rights reserved.
//
import UIKit
import DJISDK
import DJIWidget
import MapKit
import CoreLocation
import DJIUXSDK

class ConfigureMissionController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, MKMapViewDelegate {
    
    // the states based on the raw values
    let operatorStateNames = [
        "Disconnected",
        "Recovering",
        "Not Supported",
        "Ready to Upload",
        "Uploading",
        "Ready to Execute",
        "Executing",
        "Execution Paused"
    ]
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var operatorStateLabel: UILabel!
    @IBOutlet weak var logTextView: UITextView!
    
    @IBOutlet weak var longitudeDisp: UILabel!
    @IBOutlet weak var latitudeDisp: UILabel!
    @IBOutlet weak var missionType: UIPickerView!
    @IBOutlet weak var centerOnLocation: RoundButton!
    @IBOutlet weak var saveMissionDetails: RoundButton!
    
    
    var pickerData: [String] = [String]()
    
    // lat and log variables
    var currentLat = 45.307067  // newberg ore
    var currentLong = -122.96015
    // the region of the map that's it automatically zoomed into.
    let regionRadius: CLLocationDistance = 200
    
    // to zoom in on user location
    var locationManager = CLLocationManager()

    // print out info to a text box inside the app
    func debugPrint(_ text: String) {
        DispatchQueue.main.async {
            //logTextField.text += text + "\n"
            self.logTextView.text = (self.logTextView.text ?? "") + text + "\n"
        }
    }
    
    @IBAction func centerOnLocation(_ sender: Any)
    {
        zoomUserLocation(locationManager)
        let initialLocation = CLLocation(latitude: currentLat, longitude: currentLong)
        centerMapOnLocation(location: initialLocation)
    }
    
    /** files are located at: /Users/admin/Library/Developer/CoreSimulator/Devices/03294EA3-FF7E-4D14-8BF5-1B3B282DDDD6/data/Containers/Data/Application/A2879762-8397-4CF8-8E9F-8490E539A22D/Documents
     */
    @IBAction func saveMissionDetails(_ sender: Any) {
        //writes data to a json file
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: "myFile", relativeTo: directoryURL).appendingPathExtension("json")
        let myString = "spicy"
        let data = myString.data(using: .utf8)
        print(directoryURL)
        do
        {
            try data!.write(to: fileURL)
        }
        catch
        {
            //pop up an alert
            self.showAlertViewWithTitle(title: "Error", withMessage: "Failed to Save Mission.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        let initialLocation = CLLocation(latitude: currentLat, longitude: currentLong)
        centerMapOnLocation(location: initialLocation)
        
        self.missionType.delegate = self
        self.missionType.dataSource = self
            
        pickerData = ["Altitude: 50ft", "Altitude: 100ft", "Altitude: 200ft"]
        
        latitudeDisp.text = String(currentLat)
        longitudeDisp.text = String(currentLong)
    }
    
    // show the message as a pop up window in the app
    func showAlertViewWithTitle(title:String, withMessage message:String ) {
        print("Starting showAlertViewWithTitle()...")
        
        let alert:UIAlertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertController.Style.alert)
        let okAction:UIAlertAction = UIAlertAction(title:"Ok", style:UIAlertAction.Style.`default`, handler:nil)
        alert.addAction(okAction)
        self.present(alert, animated:true, completion:nil)
        print("...Finished showAlertWithTitle()")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location: CLLocationCoordinate2D = manager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 45.307067, longitude: -122.96015)
        currentLat = location.latitude
        currentLong = location.longitude
    }
    
    // zoom the map in to the location that we choose. Right now it is hard coded for newberg OR
    func centerMapOnLocation(location: CLLocation) {
        print("spicy2")
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        print("spicy2")
        mapView.setRegion(coordinateRegion, animated: true)
        print("spicy2")

        // make that map satellite view
        mapView.mapType = MKMapType.satellite
    }

    
    func zoomUserLocation(_ manager: CLLocationManager) {
        print("spicy3")
        guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        print("spicy3")
        currentLat = currentLocation.latitude
        currentLong = currentLocation.longitude
        print("spicy3")
        print(currentLat)

        mapView.setCenter(currentLocation, animated: true)
    }
    
    
}
