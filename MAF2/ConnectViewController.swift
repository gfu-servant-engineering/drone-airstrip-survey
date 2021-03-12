import Foundation
import UIKit
import DJISDK

class ConnectViewController: UIViewController {
    
    @IBOutlet weak var couldNotConnect: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    override func viewDidLoad() {
        // hide the button until needed
        couldNotConnect.isHidden = true
        retryButton.isHidden = true
        
        // if the app is registered correctly, move on the the home page
        retry(self)
    }
    
//    if (productPublisher.connectionState == ConnectionState.DISCONNECTED) {
//        Button("Connect") {
//            productPublisher.registerWithSDK()
//        }
//    } else {
//        Button("Disconnect") {
//            productPublisher.stop()
//        }
//    }
    
    /* this method registers the app. If it fails to load correctly, you can push
     the button to call is again. */
    @IBAction func retry(_ sender: Any) {
        DroneControl.setupDrone()
        NSLog("\(DroneControl.instance!.connectionState)")
        if (DroneControl.instance!.connectionState == ConnectionState.CONNECTED) {
            self.showAlertViewWithTitle(title: "SetUp Success", withMessage: "it set up correctly." )
            self.performSegue(withIdentifier: "toMainMenu", sender: nil)
        } else {
            self.showAlertViewWithTitle(title: "setup not successful", withMessage: "no good.")
            // if the app doesn't connect, show a message and a button to try again
            self.couldNotConnect.isHidden = false
            self.retryButton.isHidden = false
        }
    }
    
    // show the message as a pop up window in the app
    func showAlertViewWithTitle(title:String, withMessage message:String ) {
        let alert:UIAlertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertController.Style.alert)
        let okAction:UIAlertAction = UIAlertAction(title:"Ok", style:UIAlertAction.Style.`default`, handler:nil)
        alert.addAction(okAction)
        self.present(alert, animated:true, completion:nil)
    }
    
    
}
import Foundation
import UIKit
import DJISDK

class ConnectViewController: UIViewController {
    
    @IBOutlet weak var couldNotConnect: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    override func viewDidLoad() {
        // hide the button until needed
        couldNotConnect.isHidden = true
        retryButton.isHidden = true
        
        // if the app is registered correctly, move on the the home page
        retry(self)
    }
    
//    if (productPublisher.connectionState == ConnectionState.DISCONNECTED) {
//        Button("Connect") {
//            productPublisher.registerWithSDK()
//        }
//    } else {
//        Button("Disconnect") {
//            productPublisher.stop()
//        }
//    }
    
    /* this method registers the app. If it fails to load correctly, you can push
     the button to call is again. */
    @IBAction func retry(_ sender: Any) {
        DroneControl.setupDrone()
        NSLog("\(DroneControl.instance!.connectionState)")
        if (DroneControl.instance!.connectionState == ConnectionState.CONNECTED) {
            self.showAlertViewWithTitle(title: "SetUp Success", withMessage: "it set up correctly." )
            self.performSegue(withIdentifier: "toMainMenu", sender: nil)
        } else {
            self.showAlertViewWithTitle(title: "setup not successful", withMessage: "no good.")
            // if the app doesn't connect, show a message and a button to try again
            self.couldNotConnect.isHidden = false
            self.retryButton.isHidden = false
        }
    }
    
    // show the message as a pop up window in the app
    func showAlertViewWithTitle(title:String, withMessage message:String ) {
        let alert:UIAlertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertController.Style.alert)
        let okAction:UIAlertAction = UIAlertAction(title:"Ok", style:UIAlertAction.Style.`default`, handler:nil)
        alert.addAction(okAction)
        self.present(alert, animated:true, completion:nil)
    }
    
    
}
