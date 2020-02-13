//
//  ViewController.swift
//  HintsaLogUI
//
//  Created by Tewodros Mengesha on 12.2.2020.
//  Copyright © 2020 Tewodros Mengesha. All rights reserved.
//

import UIKit
import CoreData

@objc extension UIButton {
    func roundButton() {
        let button = self
        button.layer.cornerRadius = button.frame.size.width/2
        button.clipsToBounds = true
    }
}
@objc extension UIImageView {
    func roundImageView () {
        let imageView = self
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
    }

}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnLog: UIButton!
    @IBOutlet weak var lblEnduranceTotal: UILabel!
    @IBOutlet weak var lblStrengthTotal: UILabel!
    @IBOutlet weak var lblMobilityTotal: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var sessionArray:[ExerciseSession] = []
    let defaults = UserDefaults.standard
    let appDelegate = UIApplication.shared.delegate as!AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTotalLabels), name: Notification.Name("TotalValueChanged"), object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = UINib(nibName: "SessionsTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "tableViewCell")
        
        
        self.fetchData()
        self.tableView.reloadData()

        //roundUIElements
        imgProfile.roundImageView()
        btnLog.roundButton()
        
        //Assigning endurance, strength and mobility total
        updateTotalLabels()
    
    }
    
    //Action from notification that is sent while adding a new entry
    @objc func refreshTotalLabels() {
        //Update tableview
        fetchData()
        self.tableView.reloadData()
       
        //Update totals endurance, strength and mobility total
        updateTotalLabels()
    }
    
    func updateTotalLabels() {
        lblEnduranceTotal.text = minutesToHoursMinutes(minutes: defaults.integer(forKey: "enduranceTotal"))
        lblStrengthTotal.text = minutesToHoursMinutes(minutes: defaults.integer(forKey: "strengthTotal"))
        lblMobilityTotal.text = minutesToHoursMinutes(minutes: defaults.integer(forKey: "mobilityTotal"))
    }
    
    
    func fetchData() {
        let context = (appDelegate).persistentContainer.viewContext
        
        do{
            sessionArray = try context.fetch(ExerciseSession.fetchRequest())
        }catch {
            print(error)
        }
    }
    
    func minutesToHoursMinutes (minutes : Int) -> String {
        if(minutes == 0) {
            return("0 min")
        }
        else if(minutes % 60 == 0){
            return("\(minutes / 60)h")
        }
        else {
            if((minutes / 60) == 0) {
                return("\((minutes % 60)) min")
            }
            else {
                return("\(minutes / 60)h \((minutes % 60)) min")
            }
            
        }
    }
    
    func updateTotal(catagory: String, minutes: Int) {
        var currentValue: Int
        if (catagory == "Endurance") {
            currentValue = defaults.integer(forKey: "enduranceTotal")
            defaults.set(currentValue-minutes, forKey: "enduranceTotal")
            
        }
        else if (catagory == "Strength") {
            currentValue = defaults.integer(forKey: "strengthTotal")
            defaults.set(currentValue-minutes, forKey: "strengthTotal")
            
        }
        else {
            currentValue = defaults.integer(forKey: "mobilityTotal")
            defaults.set(currentValue-minutes, forKey: "mobilityTotal")
        }
    }
    
    private let cellReuseIdentifier: String = "tableViewCell"
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessionArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let formatter = DateFormatter()
        
  
        let cell = tableView.dequeueReusableCell(withIdentifier: (cellReuseIdentifier), for: indexPath) as! SessionsTableViewCell
        let session = sessionArray[indexPath.row]
        formatter.dateFormat = "E"
        cell.lblWeekDay!.text = formatter.string(from: session.completedAt!)
        formatter.dateFormat = "dd"
        cell.lblWeekDate!.text = formatter.string(from: session.completedAt!)
        formatter.dateFormat = "dd/MM/yyyy"
        cell.lblFullDate!.text = formatter.string(from: session.completedAt!)
        
        print(formatter.string(from: session.completedAt!))
        cell.lblDescription!.text = session.trainingDescription
        cell.lblCatagory!.text = session.category
        cell.lblDuration!.text = minutesToHoursMinutes(minutes: Int(session.durationInMinutes))
        
        return cell
    }
    
    //Height of custom cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //Delete row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = (appDelegate).persistentContainer.viewContext
        var catagory = ""
        var minutesToDelete = 0
        if editingStyle == .delete {
            let session = sessionArray[indexPath.row]
            catagory = session.category!
            minutesToDelete = Int(session.durationInMinutes)
            context.delete(session)
            (appDelegate).saveContext()
            do {
                sessionArray = try context.fetch(ExerciseSession.fetchRequest())
            }
            catch {
                print(error)
            }
        }
        updateTotal(catagory: catagory, minutes: minutesToDelete)
        updateTotalLabels()
        tableView.reloadData()
    }


}

