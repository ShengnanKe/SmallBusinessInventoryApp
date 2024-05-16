//
//  AddSectionViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/14/24.
//

import UIKit
import CoreData

class AddSectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addSectionLabel: UILabel!
    @IBOutlet weak var sectionTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveSectionButton: UIButton!
    
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
            print("Failed to add section: \(sectionName)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddSectionCell", for: indexPath) as! AddSectionTableViewCell
        let section = sections[indexPath.row]
        cell.configure(with: section)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSection = sections[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addContainerVC = storyboard.instantiateViewController(withIdentifier: "AddContainerViewController") as? AddContainerViewController {
            addContainerVC.section = selectedSection
            navigationController?.pushViewController(addContainerVC, animated: true)
        }
    }
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "showAddContainer" {
    //            print("Preparing for segue to AddContainerViewController")
    //            if let destinationVC = segue.destination as? AddContainerViewController,
    //               let section = sender as? Section {
    //                destinationVC.section = section
    //            }
    //        }
    //    }
    
    
}
