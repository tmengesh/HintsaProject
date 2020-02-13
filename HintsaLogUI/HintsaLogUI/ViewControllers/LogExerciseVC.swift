//
//  LogExerciseVC.swift
//  HintsaLogUI
//
//  Created by Tewodros Mengesha on 12.2.2020.
//  Copyright © 2020 Tewodros Mengesha. All rights reserved.
//

import UIKit
import CoreData

@objc extension UIButton {
    func customizeButton() {
        let button = self
        
        button.backgroundColor = .none
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.borderWidth = 0.5
        button.setTitleColor(.brown, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
    }
}

class LogExerciseVC: UIViewController {

    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet weak var txtDuration: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    private var datePicker: UIDatePicker?
    
    @IBOutlet weak var btnEndurance: UIButton!
    @IBOutlet weak var btnStrength: UIButton!
    @IBOutlet weak var btnMobility: UIButton!
    
    let defaults = UserDefaults.standard
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    var catagory = "Endurance"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action:#selector(LogExerciseVC.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(LogExerciseVC.viewTapped(gestureRecognizer:)))
        txtDate.inputView = datePicker
        view.addGestureRecognizer(tapGesture)
        
        //Round buttons
        btnMobility.customizeButton()
        btnStrength.customizeButton()
        btnEndurance.customizeButton()
        
        //Setting default value
        btnEndurance.backgroundColor = #colorLiteral(red: 0.7215434313, green: 0.5451264381, blue: 0.3646684587, alpha: 1)
        btnEndurance.setTitleColor(.white, for: .normal)
        
    }
    
    //Select/Deselect button..... I used tag to identify which button is selected
    @IBAction private func catagoryButtonAction(_ sender: UIButton) {
        // Create a list of all tags
        let allButtonTags = [1, 2, 3]
        let currentButtonTag = sender.tag
        catagory = sender.titleLabel!.text!
        print("catagory: \(catagory)")
        
        allButtonTags.filter { $0 != currentButtonTag }.forEach { tag in
               if let button = self.view.viewWithTag(tag) as? UIButton {
                   // Deselect/Disable these buttons
                   button.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9412290454, blue: 0.9293014407, alpha: 1)
                   button.setTitleColor(.brown, for: .normal)
                   button.isSelected = false
               }
           }
           // Select/Enable clicked button
           sender.backgroundColor = #colorLiteral(red: 0.7215434313, green: 0.5451264381, blue: 0.3646684587, alpha: 1)
           sender.setTitleColor(.white, for: .normal)
           sender.isSelected = !sender.isSelected
    }
    
    // Add contents to coreData
    @IBAction private func saveButtonAction(_ sender: UIButton) {
       
        if (!isInputValid()) {
            
        } else {
            updateTotal()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let formmatedDate = formatter.date(from: txtDate.text!)

            let newSession = NSEntityDescription.insertNewObject(forEntityName: "ExerciseSession", into: context)
            newSession.setValue(self.txtDescription!.text, forKey: "trainingDescription")
            newSession.setValue(Int32(self.txtDuration.text!), forKey: "durationInMinutes")
            newSession.setValue(formmatedDate, forKey: "completedAt")
            newSession.setValue(self.catagory, forKey: "category")
            
            showAlert(message: "Session is saved successfully 😊")
            
            //Notify to update total on main view controller
            NotificationCenter.default.post(name: Notification.Name("TotalValueChanged"), object: nil)
        }
        
        
        do {
            try context.save()
        } catch {
            print(error)
        }

        resetView()
    }
    
    func isInputValid() -> Bool {
        let possibleInt = txtDuration.text ?? ""
        var isNumber = false
        if let convertedNumber = Int(possibleInt) {
            print(convertedNumber)
            isNumber = true
            
        }
       
        if(txtDate.text == "" || txtDescription.text == "" || txtDate.text == "") {
            showAlert(message: "Field can not be empty")
            return false
        }
        if(isNumber == false) {
            showAlert(message: "Please enter minutes in number")
            txtDate.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateTotal() {
        var currentValue: Int
        if (catagory == "Endurance") {
            currentValue = defaults.integer(forKey: "enduranceTotal")
            defaults.set(currentValue + Int(txtDuration.text!)!, forKey: "enduranceTotal")
            
        }
        else if (catagory == "Strength") {
            currentValue = defaults.integer(forKey: "strengthTotal")
            defaults.set(currentValue + Int(txtDuration.text!)!, forKey: "strengthTotal")
            
        }
        else {
            currentValue = defaults.integer(forKey: "mobilityTotal")
            defaults.set(currentValue + Int(txtDuration.text!)!, forKey: "mobilityTotal")
        }
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        txtDate.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func resetView() {
        txtDate.text = ""
        txtDuration.text = ""
        txtDescription.text = ""
        txtDescription.becomeFirstResponder()
    }
    
}
