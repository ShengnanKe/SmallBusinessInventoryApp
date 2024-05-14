//
//  ContainerViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/13/24.
//

import UIKit

class ContainerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var section: Section?
    var containers: [Container] = []
    
    @IBOutlet weak var containerTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContainers()
        containerTableView.dataSource = self
        containerTableView.delegate = self
        
        self.title = section?.name ?? "container ???"
    }
    
    func loadContainers() {
        if let section = section {
            containers = DBManager.shared.fetchContainers(for: section)
            containerTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return containers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContainerCell", for: indexPath) as! ContainerTableViewCell
        if let containerName = containers[indexPath.row].name {
            cell.configure(with: containerName)
        } else {
            cell.configure(with: "No name available")
        }
        return cell
    }
    
    
}
