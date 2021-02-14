import UIKit
import DJISDK
import DJIWidget

class CameraViewController: UIViewController, DJIVideoFeedListener, DJICameraDelegate, DJIBaseProductDelegate {
    @IBOutlet var recordBtn: UIButton!
    @IBOutlet var changeWorkModeSegmentControl: UISegmentedControl!
    @IBOutlet var fpvPreviewView: UIView!
    @IBOutlet var currentRecordTimeLabel: UILabel!
    
    // the variable for the camera method
    var isRecording = false
    
    // TODO: Figure out how to handle product disconnections across the app.
    /*guard let camera:DJICamera = self.fetchCamera() else {return}
    if let delegate = camera.delegate, delegate === self {
        camera.delegate = nil;
    }
    self.resetVideoPreview()*/
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.registerApp()
        
        if let control = DroneControl.instance, let product = control.product {
            product.delegate = self;
            guard let camera:DJICamera = self.fetchCamera() else {return}
            camera.delegate = self
            
            self.setupVideoPreviewer()
            //self.showAlertViewWithTitle(title: "Success", withMessage: "product connected!")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentRecordTimeLabel.isHidden = true
    }
    
    
    // the setUpVideoPreviewer
    func setupVideoPreviewer() {
        // variables
        DJIVideoPreviewer.instance().setView(self.fpvPreviewView)
        guard let product:DJIBaseProduct = DJISDKManager.product() else {return}
        
        if product.model == DJIAircraftModelNameA3 ||
            product.model == DJIAircraftModelNameN3 ||
            product.model == DJIAircraftModelNameMatrice600 ||
            product.model == DJIAircraftModelNameMatrice600Pro {
            DJISDKManager.videoFeeder()?.secondaryVideoFeed.add(self, with: nil)
        } else {
            DJISDKManager.videoFeeder()?.primaryVideoFeed.add(self, with: nil)
        }
        
        DJIVideoPreviewer.instance().start()
    }
    
    func resetVideoPreview() {
        DJIVideoPreviewer.instance().unSetView()
        guard let product:DJIBaseProduct = DJISDKManager.product() else {return}
        
        if product.model == DJIAircraftModelNameA3 ||
            product.model == DJIAircraftModelNameN3 ||
            product.model == DJIAircraftModelNameMatrice600 ||
            product.model == DJIAircraftModelNameMatrice600Pro {
            DJISDKManager.videoFeeder()?.secondaryVideoFeed.remove(self)
        } else {
            DJISDKManager.videoFeeder()?.primaryVideoFeed.remove(self)
        }
        
    }
    
    func fetchCamera() -> DJICamera? {
        if DJISDKManager.product() == nil {
            // if the product doesn't exist, display a "device not found" message and
            // exit the method
            displayDeviceNotConnectedMessage()
            return nil
        }

        if let productKind = DJISDKManager.product(), productKind.isKind(of:DJIAircraft.self) {
            return (DJISDKManager.product() as? DJIAircraft)?.camera
        
        } else if let productKind2 = DJISDKManager.product(), productKind2.isKind(of:DJIHandheld.self) {
            return (DJISDKManager.product() as? DJIHandheld)?.camera
        }
        return nil
    }
    
    func setShootPhotoMode () {
        //DJICameraShootPhotoMode.
    }
    
    
    // show a "device not connected" message
    func displayDeviceNotConnectedMessage() {
        let message:NSString = "No device (ie drone) is connected to the app!"
        self.showAlertViewWithTitle(title: "Connect Device", withMessage:message)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let camera:DJICamera = self.fetchCamera() else {return}
        if let delegate = camera.delegate, delegate === self {
            camera.delegate = nil
        }
        self.resetVideoPreview()
    }
    
    public func videoFeed(_ videoFeed: DJIVideoFeed, didUpdateVideoData videoData: Data) {
        var data2 = videoData
        data2.withUnsafeMutableBytes({ (data: UnsafeMutablePointer<UInt8>) in
            DJIVideoPreviewer.instance().push(data, length: Int32(videoData.count))

        })
    }
    
    func camera(_ camera: DJICamera, didUpdate systemState: DJICameraSystemState) {
        if (systemState.mode == .shootPhoto) {
         self.changeWorkModeSegmentControl.selectedSegmentIndex = 0
        } else if (systemState.mode == .recordVideo){
         self.changeWorkModeSegmentControl.selectedSegmentIndex = 1
         }
        
        self.isRecording = systemState.isRecording
        
        self.currentRecordTimeLabel.isHidden = !self.isRecording
        //self.currentRecordTimeLabel.te
    }


    @IBAction func captureAction(sender:Any) {
        guard let camera:DJICamera = self.fetchCamera() else {return}
        // WeakRef(target);
        camera.setShootPhotoMode(.single, withCompletion: { (error:NSError?) -> () in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { () -> () in
                camera.startShootPhoto(completion: {(error:Optional<NSError>) -> () in
                    guard let errorMessage = error?.description as NSString? else {return}
                    self.showAlertViewWithTitle(title: "Take Photo Error", withMessage:errorMessage)
                    } as? DJICompletionBlock)
            })
        } as? DJICompletionBlock)
    }
    
    
    
    @IBAction func changeWorkModeAction(_ sender: UISegmentedControl) {
        let segmentControl:UISegmentedControl = sender
        if let camera:DJICamera = self.fetchCamera() {
            // to take picture
            if (segmentControl.selectedSegmentIndex == 0) {
                camera.setMode(.shootPhoto, withCompletion: {(error:NSError) -> () in
                    self.showAlertViewWithTitle(title: "Set DJICameraModeShootPhoto Failed", withMessage:error.description as NSString)
                } as? DJICompletionBlock)
            } else if (segmentControl.selectedSegmentIndex == 1) {
                camera.setMode(.shootPhoto, withCompletion: {(error:NSError) -> () in
                    self.showAlertViewWithTitle(title: "Set DJICameraModeRecordVideo Failed", withMessage:error.description as NSString)
                } as? DJICompletionBlock)
            }
        }
    }
    
    
    /*@IBAction func confirmAlert(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Start Survey", message: "All of the presets go here.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default)
        { (alertAction) in
            // next scene
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }*/
    
    func showAlertViewWithTitle(title:NSString, withMessage message:NSString ) {
        let alert:UIAlertController = UIAlertController(title:title as String, message:message as String, preferredStyle:UIAlertController.Style.alert)
        let okAction:UIAlertAction = UIAlertAction(title:"Ok", style:UIAlertAction.Style.`default`, handler:nil)
        alert.addAction(okAction)
        self.present(alert, animated:true, completion:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
