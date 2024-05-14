//
//  LocationViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/13/24.
//

import UIKit

class LocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var locations: [Location] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        
        loadLocations()
    }
    
    func loadLocations() {
        locations = DBManager.shared.fetchAllEntities(entityName: "Location") as? [Location] ?? []
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationTableViewCell
        if let locationName = locations[indexPath.row].name {
            cell.configure(with: locationName)
        } else {
            cell.configure(with: "No name available")
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedLocation = locations[indexPath.row]
//        let sectionViewController = SectionViewController()
//        sectionViewController.location = selectedLocation
//        navigationController?.pushViewController(sectionViewController, animated: true)
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "showSections", sender: self)
//    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSections" {
            if let sectionVC = segue.destination as? SectionViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                let selectedLocation = locations[indexPath.row]  
                sectionVC.location = selectedLocation
            }
        }
    }

}
