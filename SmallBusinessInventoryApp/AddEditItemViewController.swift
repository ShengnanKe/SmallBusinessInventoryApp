//
//  AddEditItemViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/8/24.
//

/*
 
 Location to Section: One-to-Many
 Each Location -> multiple Sections, each Section -> one Location.
 delete rule -> cascade -> when you delete a location, the sections under this location will be deleted too.
 
 Section to Container: One-to-Many
 Each Section -> multiple Containers, each Container -> one Section.
 delete rule -> cascade -> when you delete a section, the containers under this section will be deleted too.
 
 Container to Item: One-to-Many
 Each Container -> multiple Items, each Item -> one Container.
 delete rule -> cascade -> when you delete a container, the items under this container will be deleted too.
 
 Item to Tag: One-to-One
 
 
 Location: id & name
 Section: id & name
 Container: id & name
 Item: id, name, photo(save the path to the file -> String), description, ownership status, tag(s)
 
 */

// add logic in the view, not in table view cell
// cellForRowAt -> cell.imageview
// reloadCell
// tableview.reloadData

import UIKit

class AddEditItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var item: Item?
    var containers: [Container] = []
    var tags: [Tag] = []
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var containerPickerView: UIPickerView!
    @IBOutlet weak var ownershipSwitch: UISwitch!
    @IBOutlet weak var tagPickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setupPickerViews()
        containerPickerView.delegate = self
        containerPickerView.dataSource = self
        tagPickerView.delegate = self
        tagPickerView.dataSource = self
        
        nameTextField.placeholder = "Please enter item name: "
        descriptionTextField.placeholder = "Please enter item description here: "
        
        if let item = item {
            nameTextField.text = item.name
            descriptionTextField.text = item.itemdescription
        } else {
            nameTextField.placeholder = "Enter item name"
            descriptionTextField.placeholder = "Enter a description"
        }
        
        // borrowed / owned
        ownershipSwitch.isOn = item?.ownershipstatus ?? false // -> default to borrowed, true owned
        ownershipSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        loadPickerData()

    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        print("Switch new value: \(sender.isOn)")
    }
    
    func loadPickerData() {
        containers = DBManager.shared.fetchData(entityName: "Container", attribute: "name", value: "%") as? [Container] ?? []
        tags = DBManager.shared.fetchData(entityName: "Tag", attribute: "name", value: "%") as? [Tag] ?? []
        containerPickerView.reloadAllComponents()
        tagPickerView.reloadAllComponents()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == containerPickerView {
            return containers.count
        } else if pickerView == tagPickerView {
            return tags.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == containerPickerView {
            return containers[row]
        } else if pickerView == tagPickerView {
            return tags[row]
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if pickerView == containerPickerView {
               
            } else if pickerView == tagPickerView {
                
            }
        }

}


/*
 
 extension DestinationSearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return cities.count
     }
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return cities[row]
     }
     
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         let selectedCity = cities[row]
         if var bookingInfo = bookingDetails["bookingInfo"] as? [String: Any] {
             if pickerView.tag == 0 {
                 bookingInfo["originCity"] = selectedCity
                 print("Origin city set to: \(selectedCity)")
             } else {
                 bookingInfo["destinationCity"] = selectedCity
                 print("Destination city set to: \(selectedCity)")
             }
             bookingDetails["bookingInfo"] = bookingInfo
         }
     }
     
 }
 
 */
