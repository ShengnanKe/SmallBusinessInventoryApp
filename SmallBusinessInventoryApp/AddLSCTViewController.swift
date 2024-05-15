//
//  AddLSCTViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/14/24.
//

// add Locations Sections Containers Tags

import UIKit

class AddLSCTViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var sectionTextField: UITextField!
    @IBOutlet weak var containerTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var sectionButton: UIButton!
    @IBOutlet weak var containerButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addLocation(_ sender: UIButton) {
        guard let locationName = locationTextField.text, !locationName.isEmpty else {
            showAlert(message: "Please enter a location name.")
            return
        }
        
        let locationModel = LocationModel(name: locationName)
        let success = DBManager.shared.addLocation(with: locationModel)
        if success {
            showAlert(message: "Location added successfully!")
            print("Successfully added location: \(locationName)")
        } else {
            showAlert(message: "Failed to add location.")
            print("Failed to add location: \(locationName)")
        }
    }
    
    
    @IBAction func addSection(_ sender: UIButton) {
        guard let locationName = locationTextField.text, !locationName.isEmpty else {
            showAlert(message: "Please enter the location name for the section.")
            return
        }
        
        guard let sectionName = sectionTextField.text, !sectionName.isEmpty else {
            showAlert(message: "Please enter a section name.")
            return
        }
        
        if let location = DBManager.shared.fetchData(entityName: "Location", attribute: "name", value: locationName).first as? Location {
            let success = DBManager.shared.addSection(with: sectionName, to: location)
            if success {
                showAlert(message: "Section added successfully!")
            } else {
                showAlert(message: "Failed to add section.")
            }
        } else {
            showAlert(message: "Location not found.")
        }
    }
    
    @IBAction func addContainer(_ sender: UIButton) {
        guard let sectionName = sectionTextField.text, !sectionName.isEmpty else {
            showAlert(message: "Please enter the section name for the container.")
            return
        }
        
        guard let containerName = containerTextField.text, !containerName.isEmpty else {
            showAlert(message: "Please enter a container name.")
            return
        }
        
        if let section = DBManager.shared.fetchData(entityName: "Section", attribute: "name", value: sectionName).first as? Section {
            let success = DBManager.shared.addContainer(with: containerName, to: section)
            if success {
                showAlert(message: "Container added successfully!")
            } else {
                showAlert(message: "Failed to add container.")
            }
        } else {
            showAlert(message: "Section not found.")
        }
    }
    
    @IBAction func addTag(_ sender: UIButton) {
        guard let tagName = tagTextField.text, !tagName.isEmpty else {
            showAlert(message: "Please enter a tag name.")
            return
        }
        
        let success = DBManager.shared.addTag(with: tagName)
        if success {
            showAlert(message: "Tag added successfully!")
        } else {
            showAlert(message: "Failed to add tag.")
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
