import UIKit
import DJISDK
import DJIWidget
import MapKit
import CoreLocation
import DJIUXSDK

class RunMissionViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    @IBOutlet weak var clearTheWaypoints: RoundButton!
    @IBOutlet weak var loadTheMission: RoundButton!
    @IBOutlet weak var startTheMission: RoundButton!
    @IBOutlet weak var missionType: UIPickerView!
    @IBOutlet weak var centerOnCurrentLocation: RoundButton!
    @IBOutlet weak var saveMissionDetails: RoundButton!
    
    var uiUpdateTimer: Timer!
    
    //default values
    var currentLat = 45.307067  // newberg ore
    var currentLong = -122.96015
    var altitude:Float = 50
    
    // the region of the map that's it automatically zoomed into.
    let regionRadius: CLLocationDistance = 200
    // the mission for the to add the waypoints to
    let mission:DJIMutableWaypointMission = DJIMutableWaypointMission.init()
    var flightLine: MKPolyline = MKPolyline()
    
    
    var locationManager = CLLocationManager()
    var pickerData: [String] = [String]()
    
    //the following 8 variables are for loading in a mission from the
    //load mission screen
    var fromHome = true
    var selectedMission: Mission!
    
    var x0: Double = 0
    var y0: Double = 0
    var x1: Double = 0
    var y1: Double = 0
    var x2: Double = 0
    var y2: Double = 0

    // print out info to a text box inside the app
    func debugPrint(_ text: String) {
        DispatchQueue.main.async {
            //logTextField.text += text + "\n"
            self.logTextView.text = (self.logTextView.text ?? "") + text + "\n"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        //Hide the start button until the mission has loaded
        self.startTheMission.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Output the state to the app updating it every second
        uiUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            guard let missionControl = DJISDKManager.missionControl() else { return }
            let missionOperator:DJIWaypointMissionOperator = missionControl.waypointMissionOperator()
            
            DispatchQueue.main.async
            {
                self.operatorStateLabel.text = String(format: "Operator State: %@", self.operatorStateNames[missionOperator.currentState.rawValue])
            }
        })
        
        //initializing altitude picker
        self.missionType.delegate = self
        self.missionType.dataSource = self
        pickerData = ["Altitude: 50ft", "Altitude: 100ft", "Altitude: 200ft"]
        
        if (fromHome) //seguing in from home screen
        {
            // Inform the user how to add a waypoint
            self.showAlertViewWithTitle(title: "Add waypoint", withMessage: "Long press the map where you want to add a waypoint.")
            
            centerOnCurrentLocation(self)
        }
        else //segueing in from load mission screen
        {
            //simulate the user selecting an altitude and pressing waypoints
            let wayPoint1:DJIWaypoint = DJIWaypoint.init(coordinate: CLLocationCoordinate2D(latitude: selectedMission.coord1lat, longitude: selectedMission.coord1lon))
            
            let wayPoint2:DJIWaypoint = DJIWaypoint.init(coordinate: CLLocationCoordinate2D(latitude: selectedMission.coord2lat, longitude: selectedMission.coord2lon))
            
            let wayPoint3:DJIWaypoint = DJIWaypoint.init(coordinate: CLLocationCoordinate2D(latitude: selectedMission.coord3lat, longitude: selectedMission.coord3lon))
            
            wayPoint1.altitude = selectedMission.altitude
            wayPoint2.altitude = selectedMission.altitude
            wayPoint3.altitude = selectedMission.altitude
            mission.add(wayPoint1)
            mission.add(wayPoint2)
            mission.add(wayPoint3)
            
            loadTheMission(self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        uiUpdateTimer.invalidate()
    }
    
    func mapView(_ mapview: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.red
        polylineRenderer.lineWidth = 5
        return polylineRenderer
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
    
    //Adjusts the altitude for the mission based on what the user picked
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        altitude = 50
        if (row == 1)
        {
            altitude = 100
        }
        else if (row == 2)
        {
            altitude = 200
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location: CLLocationCoordinate2D = locations[locations.endIndex-1].coordinate
        currentLat = location.latitude
        currentLong = location.longitude
    }
    
    // centers the map to the current location
    @IBAction func centerOnCurrentLocation(_ sender: Any)
    {
        zoomUserLocation(locationManager)
        let newLocation = CLLocation(latitude: currentLat, longitude: currentLong)
        centerMapOnLocation(location: newLocation)
    }
    
    // zoom the map in to the location that we choose.
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)

        mapView.setRegion(coordinateRegion, animated: true)

        // make that map satellite view
        mapView.mapType = MKMapType.satellite
    }

    
    func zoomUserLocation(_ manager: CLLocationManager)
    {
        guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        currentLat = currentLocation.latitude
        currentLong = currentLocation.longitude

        mapView.setCenter(currentLocation, animated: true)
    }

    /* Appends the mission details to a json File named DroneMissions
     * Missions are stored in the Device/Simulator's default directory.
     */
    @IBAction func saveMissionDetails(_ sender: Any)
    {
        //Get a name for the mission
        let alert = UIAlertController(title: "Mission Name", message: "specify a name for the new mission", preferredStyle: .alert)
        
        alert.addTextField
        {
            (missionName) in missionName.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.saveMission(alert: alert)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    //just a helper method
    func saveMission(alert: UIAlertController)
    {
        let missionName:String = alert.textFields![0].text ?? "None"
        
        //Set up directory
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: "DroneMissions", relativeTo: directoryURL).appendingPathExtension("json")
        print(directoryURL)
        
        //Set up data to be stored
        let waypoints = mission.allWaypoints()
        if (waypoints.count > 2)
        {
            let mission_struct:Mission = Mission(name: missionName, altitude: altitude, coord1lat: y0, coord1lon: x0, coord2lat: y1, coord2lon: x1, coord3lat: y2, coord3lon: x2)
            var mission_array: [Mission]
            
            //Collect current missions
            do
            {
                //Prevent overwriting by storing current contents of the missions
                //file to an array. Then append the new mission to the array.
                let data = try Data(contentsOf: fileURL, options: [])
                mission_array = try JSONDecoder().decode([Mission].self, from: data)
                mission_array.append(mission_struct)
            }
            catch
            {
                mission_array = [mission_struct]
            }
            
            //Append new mission
            do
            {
                let jsonData = try JSONEncoder().encode(mission_array)
                let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
                print(jsonString!)
                try jsonData.write(to: fileURL, options: [])
                self.showAlertViewWithTitle(title: "Success", withMessage: "Successfully Saved Mission")
            }
            catch
            {
                self.showAlertViewWithTitle(title: "Error", withMessage: "Failed to Save Mission")
            }
        }
        else
        {
            self.showAlertViewWithTitle(title: "Error", withMessage: "Not Enough Waypoints!")
        }
    }
    
    /* Adds a waypoint when the map gets a long press.
     A maximum of two waypoints can be added by the user. Later, the rest of the waypoints are added to fill in the rectangle. */
    @IBAction func longPressAddWayPoint(_ gestureRecognizer: UILongPressGestureRecognizer) {
        print("Starting longPressAddWayPoint()...")
        
        let MAX_WAYPOINT_NUM = 3
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began
        {
            let touchPoint: CGPoint = gestureRecognizer.location(in: mapView)
            
            // a max of two waypoints are allowed. If they try to add another, print an error message
            if (mission.waypointCount < MAX_WAYPOINT_NUM)
            {
                let newCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
                
                let waypoint:DJIWaypoint = DJIWaypoint.init(coordinate: newCoordinate)
                waypoint.altitude = altitude
                
                // add the new waypoint
                
                //check for consistent altitude
                var validAltitude = true
                for point in mission.allWaypoints()
                {
                    if point.altitude != altitude
                    {
                        validAltitude = false
                    }
                }
                if !validAltitude
                {
                    showAlertViewWithTitle(title: "Inconsistent Altitude", withMessage: "This waypoint's altitude should be " + String(mission.allWaypoints()[0].altitude) + " to match the other point(s)")
                }
                else //waypoint altitude is valid
                {
                    if (CLLocationCoordinate2DIsValid(waypoint.coordinate))
                    {
                        mission.add(waypoint)
                        // put a annotation on the map for the user
                        addAnnotationOnLocation(pointedCoordinate: newCoordinate)
                    }
                    else //waypoint invalid for some other unknown reason
                    {
                        print("Waypoint not valid")
                    }
                }
            }
            else
            {
            showAlertViewWithTitle(title: "Too many waypoints!", withMessage: "The waypoints you add are the two corners of the box. A max of two are allowed. If you want to adjust the location of the box, push the 'Clear the Waypoints' button and start again. Thanks.")
            }
        }
    }
    
    // Clear all the annotations and overlays on the map
    //Removes all waypoints from the mission
    @IBAction func clearTheWaypoints(_ sender: Any)
    {
        mapView.removeAnnotations(mapView.annotations)
        mission.removeAllWaypoints()
        mapView.removeOverlay(flightLine)
    }
    
    // After the waypoints are added to the map, it takes the coordinates and loads the mission, uploads the mission then starts it.
    @IBAction func loadTheMission(_ sender: Any) {
        let MIN_WAYPOINT_NUM = 2
        let currentLocation = locationManager.location!.coordinate
        
        //TODO: If waypoints are too close, it messes up mission creation later. Fix this in the 'longpressaddwaypoint' method.
        if (mission.waypointCount < MIN_WAYPOINT_NUM)
        {
            showAlertViewWithTitle(title: "At least two waypoints are required", withMessage: "You must add markers which are the corners of the box.")
        }
        else
        {
            let homeLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            var waypointLocation: CLLocation
            var waypointList: [DJIWaypoint] = []
            var minDistance: Double = Double.greatestFiniteMagnitude
            
            //find the closest waypoint and make it the first waypoint
            //the starting waypoint is the first in the list.
            for waypoint in mission.allWaypoints()
            {
                waypointLocation = CLLocation(latitude: waypoint.coordinate.latitude, longitude: waypoint.coordinate.longitude)
                //if closer to home, prepend waypoint, else append
                if waypointLocation.distance(from: homeLocation) < minDistance
                {
                    minDistance = waypointLocation.distance(from: homeLocation)
                    waypointList.insert(waypoint, at: 0)
                }
                else
                {
                    waypointList.append(waypoint)
                }
            }
            
            
            if (mission.waypointCount == 2)
            {
                //make the implicit corner coordinates
                waypointList.remove(at: 1)
                
                let x1 = mission.allWaypoints()[0].coordinate.longitude
                let y2 = mission.allWaypoints()[1].coordinate.latitude
                let x2 = mission.allWaypoints()[1].coordinate.longitude
                let y1 = mission.allWaypoints()[0].coordinate.latitude
                let newCoord = CLLocationCoordinate2D(latitude: y2, longitude: x1)
                let newCoord2 = CLLocationCoordinate2D(latitude: y1, longitude: x2)
                waypointList.insert(DJIWaypoint.init(coordinate: newCoord), at: 1)
                waypointList.insert(DJIWaypoint.init(coordinate: newCoord2), at: 1)
            }
            clearTheWaypoints(self)
            // call the method to create a "box" shape of waypoints
            addWaypointsInBoxShape(cornersOfBox: waypointList)
        }
        
        guard let missionControl = DJISDKManager.missionControl() else {
            showAlertViewWithTitle(title: "Error", withMessage: "Couldn't get mission control!")
            return
        }
        
        //This line might not be necessary
        //The home point is set by default unless the drone has no GPS access
        let flightController:DJIFlightController = DJIFlightController()
        flightController.setHomeLocation(CLLocation(latitude: mission.waypoint(at: 0)!.coordinate.latitude, longitude: mission.waypoint(at: 0)!.coordinate.latitude))
        
        // set the heading mode, auto flight speed and max flight speed and the flightPathMode
        // when the mission is over, go back to the home point
        mission.headingMode = .auto
        mission.autoFlightSpeed = 2
        mission.maxFlightSpeed = 4
        mission.flightPathMode = .normal
        mission.finishedAction = DJIWaypointMissionFinishedAction.goHome

        let missionOperator:DJIWaypointMissionOperator = missionControl.waypointMissionOperator()

        
        // set the auto flight speed
        missionOperator.setAutoFlightSpeed(0.1, withCompletion: {(error:NSError?) -> () in

            if let speedError = error {
                DispatchQueue.main.async {
                    self.showAlertViewWithTitle(title: "Error setting auto flight speed", withMessage: speedError.localizedDescription)
                }
            } else {
                self.showAlertViewWithTitle(title: "Auto speed set successfully", withMessage: "good job")
            }

        } as? DJICompletionBlock)
        

        // "make sure the internal state of the mission plan is valid."
        if let err = mission.checkParameters() {
            self.showAlertViewWithTitle(title: "Mission not valid", withMessage: err.localizedDescription)
        } else {

            print("currentState.rawValue", missionOperator.currentState.rawValue)
            
            // load the mission
            if let loadErr = missionOperator.load(mission) {
                print(loadErr.localizedDescription)
                self.showAlertViewWithTitle(title: "Error loading mission", withMessage: loadErr.localizedDescription)
            } else {

                self.debugPrint(String(format: "loaded mission: %@" , missionOperator.loadedMission!))

                self.debugPrint(String(format: "mission load: %@", String(describing: missionOperator.currentState)))

                debugPrint("uploading...")
                // upload misssion to the product
                missionOperator.uploadMission(completion: {(error:Optional<Error>) -> () in

                    if let uploadErr = error {
                        self.debugPrint("upload failed")
                        DispatchQueue.main.async {
                            self.showAlertViewWithTitle(title: "Error uploading mission", withMessage: uploadErr.localizedDescription)
                        }
                    } else {
                        self.debugPrint("upload succeeded")
                        print("mission uploadMission: ", missionOperator.currentState)

                        // once this completes, prompt the user to start the mission
                        self.showAlertViewWithTitle(title: "Start the mission", withMessage: "Mash the 'Start the Mission' button")
                        
                        // reveal the button to the user
                        self.startTheMission.isHidden = false
                    }
                } as DJICompletionBlock)
            }
        }
        print("...Finished loadTheMission()")
    }
    
    @IBAction func startTheMission(_ sender: Any)
    {
        // start the mission
        self.debugPrint("starting...")
        guard let missionControl = DJISDKManager.missionControl() else {
            showAlertViewWithTitle(title: "Error", withMessage: "Couldn't get mission control!")
            return
        }
        guard let missionOperator:DJIWaypointMissionOperator = Optional(missionControl.waypointMissionOperator()) else {
            showAlertViewWithTitle(title: "Error", withMessage: "Couldn't get waypoint operator!")
            return
    }
        
        missionOperator.startMission(completion: {(error:Optional<Error>) -> () in
            if let startErr = error {
                // Getting 'Command cannot be executed'
                self.debugPrint("start failed")
                self.debugPrint(startErr.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlertViewWithTitle(title: "Error starting mission", withMessage: startErr.localizedDescription)
                }
            } else {
                self.debugPrint("start succeeded")
                print("mission startMission: %@", missionOperator.currentState)
                print("lastest Execution Progress: %@", missionOperator.latestExecutionProgress!)
            
                
                
                // send the drone home after the mission is finished
                self.mission.finishedAction = .goHome
            }
        } as DJICompletionBlock)
    }
    
    /* This method fills out the "box" shape defined by the user with a space-filling flight path, adding waypoints along the way. If the user want to move the box, the waypoints must be cleared and placed again.*/
    func addWaypointsInBoxShape(cornersOfBox: [DJIWaypoint])
    {
        //set altitude to waypoint altitude
        altitude = cornersOfBox[0].altitude
        //get coordinates
        x0 = cornersOfBox[0].coordinate.longitude
        y0 = cornersOfBox[0].coordinate.latitude
        x1 = cornersOfBox[1].coordinate.longitude
        y1 = cornersOfBox[1].coordinate.latitude
        x2 = cornersOfBox[2].coordinate.longitude
        y2 = cornersOfBox[2].coordinate.latitude
        
        //form initial vectors
        var v1 = simd_double2(x1-x0, y1-y0)
        var v2 = simd_double2(x2-x0, y2-y0)
        
        //determine number of pictures from resolution and vector length
        
        //make temporary vectors to make the spacing latitude invariant
        //the distance per unit longitude becomes smaller the farther the distance from the equator, proportional to the cosine of the latitude.
        let conv = 3.14159265/180 //convert degrees to radians.
        let u1 = simd_double2((x1-x0)*cos(conv*y1), y1-y0)
        let u2 = simd_double2((x2-x0)*cos(conv*y1), y2-y0)
        
        //experimental resolution. Increase this to take more pictures, have greater overlap between adjacent pictures.
        let RES: Double = 2500
        let numPicturesV1: Int = Int(ceil(RES*simd_length(u1)))
        let numPicturesV2: Int = Int(ceil(RES*simd_length(u2)))
        
        //making vectors
        v1[0] = v1[0]/Double(numPicturesV1-1)
        v1[1] = v1[1]/Double(numPicturesV1-1)
        v2[0] = v2[0]/Double(numPicturesV2-1)
        v2[1] = v2[1]/Double(numPicturesV2-1)
        
        var xcoord: CLLocationDegrees
        var ycoord: CLLocationDegrees
        var newCoord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        var waypoint: DJIWaypoint
        
        var coords: [CLLocationCoordinate2D] = [ locationManager.location!.coordinate]
        
        for i in 0...(numPicturesV1-1)
        {
            for j in 0...(numPicturesV2-1)
            {
                xcoord = x0 + Double(i)*v1[0]
                ycoord = y0 + Double(i)*v1[1]
                if (i % 2 == 0)
                {
                    xcoord = xcoord + Double(j)*v2[0]
                    ycoord = ycoord + Double(j)*v2[1]
                }
                else
                {
                    xcoord = xcoord + Double(numPicturesV2 - 1 - j)*v2[0]
                    ycoord = ycoord + Double(numPicturesV2 - 1 - j)*v2[1]
                }
                newCoord = CLLocationCoordinate2D(latitude: ycoord, longitude: xcoord)
                coords.append(newCoord)
                
                //show users the location and ordering of mission waypoints
                addAnnotationOnLocation(pointedCoordinate: newCoord, waypointName: String(i*numPicturesV2 + j))
                
                waypoint = DJIWaypoint.init(coordinate: newCoord)
                waypoint.altitude = altitude
                waypoint.speed = 10
                waypoint.add(DJIWaypointAction(actionType: DJIWaypointActionType(rawValue: DJIWaypointActionType.shootPhoto.rawValue)!, param: 1))
                //Even with this setting, the gimbal does not point down when taking photos. Instead, we had to adjust the gimbal pitch using the controller.
                waypoint.gimbalPitch = -90
                
                mission.add(waypoint)
            }
        }
        coords.append(locationManager.location!.coordinate)
        //places a red line indicating the path the drone will take
        flightLine = MKPolyline.init(coordinates: coords, count: numPicturesV1*numPicturesV2 + 2)
        mapView.addOverlay(flightLine)
        
        debugPrint("Number of waypoints: " + String(mission.allWaypoints().endIndex))
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
    
    // adds the waypoint symbol on the map
    func addAnnotationOnLocation(pointedCoordinate: CLLocationCoordinate2D, waypointName: String = "")
    {
        let annotation = MKPointAnnotation()
        annotation.coordinate = pointedCoordinate
        annotation.title = waypointName
        
        mapView.addAnnotation(annotation)
    }
}
