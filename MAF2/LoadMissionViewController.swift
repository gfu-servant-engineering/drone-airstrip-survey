//
//  LoadMissionViewController.swift
//  MAF2
//
//  Created by Admin on 2/11/21.
//  Copyright © 2021 Admin. All rights reserved.
//

import UIKit

class LoadMissionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var missionPicker: UIPickerView!
    var missionList: [Mission] = []
    var pickerData: [String] = [String]()
    var selectedName: String = ""
    
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
        //initialize picker data
        self.missionPicker.delegate = self
        self.missionPicker.dataSource = self
        for mission in missionList
        {
            pickerData.append(mission.name)
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        //Display the list of missions
        
    }
    
    //updates some parameters on RunMissionViewCOntroller when segueing in
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! RunMissionViewController
        controller.fromHome = false
        controller.selectedMission = missionList[0]
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
        selectedName = missionList[row].name
    }
}
