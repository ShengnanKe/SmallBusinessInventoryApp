//
//  AddSectionViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/14/24.
//

import UIKit
import CoreData

class AddSectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sectionTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var location: Location?
    var sections: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadSections()
    }
    
    func loadSections() {
        if let location = location {
            sections = location.hasSections?.allObjects as? [Section] ?? []
            tableView.reloadData()
        }
    }
    
    @IBAction func addSection(_ sender: UIButton) {
        guard let sectionName = sectionTextField.text, !sectionName.isEmpty else {
            return
        }
        guard let location = location else {
            return
        }
        
        let success = DBManager.shared.addSection(with: sectionName, to: location)
        if success {
            sectionTextField.text = ""
            loadSections()
        } else {

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath)
        cell.textLabel?.text = sections[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSection = sections[indexPath.row]
        performSegue(withIdentifier: "showAddContainer", sender: selectedSection)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showAddContainer" {
//            if let destinationVC = segue.destination as? AddContainerViewController,
//               let section = sender as? Section {
//                destinationVC.section = section
//            }
//        }
//    }
    
    
}
