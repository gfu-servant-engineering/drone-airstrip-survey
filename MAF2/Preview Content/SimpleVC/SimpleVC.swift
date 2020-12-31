//
//  SimpleVC.swift
//  MAF2
//
//  Created by Admin on 12/30/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SimpleVC: UIViewController {
    @IBOutlet weak var locationLabel: UILabel!
    
    var locationString: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.text = locationString
        // Do any additional setup after loading the view.
    }
    
    func customInit(locationString: String)
    {
        self.locationString = locationString
    }
}
