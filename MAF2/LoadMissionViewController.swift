//
//  LoadMissionViewController.swift
//  MAF2
//
//  Created by Admin on 2/11/21.
//  Copyright © 2021 Admin. All rights reserved.
//

import UIKit

class LoadMissionViewController: UIViewController
{
    var missionList: [Mission] = []
    override func viewDidLoad()
    {
           super.viewDidLoad()
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: "DroneMissions", relativeTo: directoryURL).appendingPathExtension("json")
        print(directoryURL)
        let fileManager = FileManager.default
        if (!fileManager.fileExists(atPath: fileURL.path))
        {
            //no missions exist
            self.showAlertViewWithTitle(title: "No Missions", withMessage: "No missions exist yet. Go back and add a new mission.")
        }
        missionList = decodeData(pathName: fileURL)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        //Display the list of missions
        
    }
    
    func showAlertViewWithTitle(title:String, withMessage message:String ) {
        print("Starting showAlertViewWithTitle()...")
        
        let alert:UIAlertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertController.Style.alert)
        let okAction:UIAlertAction = UIAlertAction(title:"Ok", style:UIAlertAction.Style.`default`, handler:nil)
        alert.addAction(okAction)
        self.present(alert, animated:true, completion:nil)
        print("...Finished showAlertWithTitle()")
    }
    
    func decodeData(pathName: URL)-> [Mission]
    {
        var missions: [Mission]
        do
        {
            let jsonData = try Data(contentsOf: pathName)
            let decoder = JSONDecoder()
            missions = try decoder.decode([Mission].self, from: jsonData)
        }
        catch
        {
            //Data is corrupted I guess
            missions = []
        }
        return missions
    }
    
}
