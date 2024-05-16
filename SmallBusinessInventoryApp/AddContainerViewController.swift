//
//  AddContainerViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/14/24.
//

import UIKit
import CoreData

class AddContainerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var containerLabel: UILabel!
    @IBOutlet weak var containerTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveContainerButton: UIButton!
    
    var section: Section?
    var containers: [Container] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        loadContainers()
    }
    
    func loadContainers() {
        if let section = section {
            containers = section.hasContainers?.allObjects as? [Container] ?? []
            tableView.reloadData()
        }
    }
    
    @IBAction func addContainer(_ sender: UIButton) {
        guard let containerName = containerTextField.text, !containerName.isEmpty else {
            return
        }
        guard let section = section else {
            return
        }
        
        let success = DBManager.shared.addContainer(with: containerName, to: section)
        if success {
            containerTextField.text = ""
            loadContainers()
        } else {
            print("Failed to add section: \(containerName)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return containers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddContainerCell", for: indexPath) as! AddContainerTableViewCell
        let container = containers[indexPath.row]
        cell.configure(with: container)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContainer = containers[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addItemVC = storyboard.instantiateViewController(withIdentifier: "AddItemViewController") as? AddItemViewController {
            addItemVC.selectedContainer = selectedContainer
            navigationController?.pushViewController(addItemVC, animated: true)
        }
    }
}
