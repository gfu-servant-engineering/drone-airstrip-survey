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
    @IBOutlet weak var selectMission: RoundButton!
    @IBOutlet weak var sortSelect: UISegmentedControl!
    
    var missionList: [Mission] = []
    var pickerData: [String] = [String]()
    var selectedMission: Mission? = nil
    var isSorted: Bool = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: "DroneMissions", relativeTo: directoryURL).appendingPathExtension("json")
        print(directoryURL)
        let fileManager = FileManager.default
        missionList = decodeData(pathName: fileURL)
        
        //initialize picker data
        self.missionPicker.delegate = self
        self.missionPicker.dataSource = self
        for mission in missionList
        {
            pickerData.append(mission.name)
        }
        
        if (!fileManager.fileExists(atPath: fileURL.path))
        {
            //no missions exist
            self.showAlertViewWithTitle(title: "No Missions", withMessage: "No missions exist yet. Go back and add a new mission.")
        }
        else
        {
            selectedMission = missionList[0]
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    //updates some parameters on RunMissionViewCOntroller when segueing in
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! RunMissionViewController
        controller.fromHome = false
        controller.selectedMission = self.selectedMission
    }
    
    func showAlertViewWithTitle(title:String, withMessage message:String ) {
        print("Starting showAlertViewWithTitle()...")
        
        let alert:UIAlertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertController.Style.alert)
        let okAction:UIAlertAction = UIAlertAction(title:"Ok", style:UIAlertAction.Style.`default`, handler:nil)
        alert.addAction(okAction)
        self.present(alert, animated:true, completion:nil)
        print("...Finished showAlertWithTitle()")
    }
    
    //helper method for loading in the missions
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
    
    //picker view functions
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
        if (isSorted)
        {
            selectedMission = missionList.sorted()[row]
        }
        else
        {
            selectedMission = missionList[row]
        }
    }

    @IBAction func sortMissions(_ sender: Any) {
        pickerData = [String]()
        if (sortSelect.selectedSegmentIndex == 0)
        {
            isSorted = false
            for mission in missionList
            {
                pickerData.append(mission.name)
            }
        }
        else
        {
            isSorted = true
            for mission in missionList.sorted()
            {
                pickerData.append(mission.name)
            }
        }
        missionPicker.reloadAllComponents()
    }

    @IBAction func deleteMission(_ sender: Any) {
        //double check that the user wants to delete a mission
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this mission?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.deleteMissionConfirmed()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteMissionConfirmed()
    {
        let newMissionList = missionList.filter(){$0 != selectedMission}
        
        do
        {
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = URL(fileURLWithPath: "DroneMissions", relativeTo: directoryURL).appendingPathExtension("json")
            let jsonData = try JSONEncoder().encode(newMissionList)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            print(jsonString!)
            try jsonData.write(to: fileURL, options: [])
            
            //reinitialize picker data
            pickerData = [String]()
            for mission in newMissionList
            {
                pickerData.append(mission.name)
            }
            missionPicker.reloadAllComponents()
            missionList = newMissionList
            self.showAlertViewWithTitle(title: "Success", withMessage: "Successfully Deleted Mission")
        }
        catch
        {
            self.showAlertViewWithTitle(title: "Error", withMessage: "Failed to Delete Mission")
        }
    }
}
