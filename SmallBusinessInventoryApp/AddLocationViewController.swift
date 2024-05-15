//
//  AddLocationViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/14/24.
//

import UIKit
import CoreData

class AddLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var locations: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        loadLocations()
    }
    
    func loadLocations() {
        locations = DBManager.shared.fetchAllEntities(entityName: "Location") as? [Location] ?? []
        
        print("Loaded locations: \(locations.count)")
        tableView.reloadData()
    }

    
    @IBAction func addLocation(_ sender: UIButton) {
        guard let locationName = locationTextField.text, !locationName.isEmpty else {
            print("Please enter a location name.")
            return
        }
        
        print("Attempting to add location: \(locationName)")
        let locationModel = LocationModel(name: locationName)
        let success = DBManager.shared.addLocation(with: locationModel)
        if success {
            print("Successfully added location: \(locationName)")
            locationTextField.text = ""
            loadLocations()
        } else {
            print("Failed to add location: \(locationName)")
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddLocationCell", for: indexPath)
        cell.textLabel?.text = locations[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = locations[indexPath.row]
        performSegue(withIdentifier: "showAddSection", sender: selectedLocation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddSection" {
            if let destinationVC = segue.destination as? AddSectionViewController,
               let location = sender as? Location {
                destinationVC.location = location
            }
        }
    }
    
    
}
