//
//  SectionViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/13/24.
//

import UIKit

class SectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var location: Location?
    var sections: [Section] = []
    
    @IBOutlet weak var sectionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("Is sectionTableView nil? \(sectionTableView == nil)")
        
        sectionTableView.delegate = self
        sectionTableView.dataSource = self
        self.title = location?.name ?? "Sections"
        
        loadSections()
    }
    
    func loadSections() {
        if let location = location {
            sections = DBManager.shared.fetchSections(for: location)
            sectionTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as? SectionTableViewCell else {
            fatalError("Could not dequeue SectionTableViewCell")
        }
        let section = sections[indexPath.row]
        cell.configure(with: section.name ?? "No Name")
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContainers" {
            if let containerVC = segue.destination as? ContainerViewController,
               let indexPath = sectionTableView.indexPathForSelectedRow {
                let selectedSection = sections[indexPath.row]
                containerVC.section = selectedSection
            }
        }
    }
    
}

