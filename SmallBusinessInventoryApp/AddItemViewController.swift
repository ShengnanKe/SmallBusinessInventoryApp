//
//  AddItemViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/8/24.
//

/*
 
 Location to Section: One-to-Many -> hasSections
 Each Location -> multiple Sections, each Section -> one Location.
 delete rule -> cascade -> when you delete a location, the sections under this location will be deleted too.
 
 Section to Container: 
 One-to-Many -> hasContainers
 toLocation -> section belongs to one location
 Each Section -> multiple Containers, each Container -> one Section.
 delete rule -> cascade -> when you delete a section, the containers under this section will be deleted too.
 
 Container to Item: One-to-Many
 Each Container -> multiple Items
 each Item belongs to one Container.
 delete rule -> cascade -> when you delete a container, the items under this container will be deleted too.
 
 Item to Tag: One-to-One, one item has one tag
 but one tag can belong to many items
 
 
 Location:  name
 Section:  name
 Container:  name
 Item: name, photo(save the path to the file -> String), description, ownership status,
 tag: name
 
 */

// add logic in the view, not in table view cell
// cellForRowAt -> cell.imageview
// reloadCell
// tableview.reloadData

import UIKit
import CoreData

class AddItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addItemLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedContainer: Container?
    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AddItemCell")
        
        loadItems()
    }
    
//    func loadItems() {
//        items = DBManager.shared.fetchAllEntities(entityName: "Item") as? [Item] ?? []
//        
//        if items.isEmpty {
//            print("No items available")
//        }
//
    //        DispatchQueue.main.async {
    //            self.tableView.reloadData()
    //        }
    //    }
    
    func loadItems() {
        if let container = selectedContainer {
            items = container.hasItems?.allObjects as? [Item] ?? []
            tableView.reloadData()
        }
    }
    
    @IBAction func addItemDetailsButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addItemDetailVC = storyboard.instantiateViewController(withIdentifier: "AddItemDetailViewController") as? AddItemDetailViewController {
            addItemDetailVC.selectedContainer = selectedContainer
            navigationController?.pushViewController(addItemDetailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemCell", for: indexPath) as! AddItemTableViewCell
        let item = items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addItemDetailVC = storyboard.instantiateViewController(withIdentifier: "AddItemDetailViewController") as? AddItemDetailViewController {
            addItemDetailVC.item = selectedItem
            addItemDetailVC.selectedContainer = selectedContainer
            navigationController?.pushViewController(addItemDetailVC, animated: true)
        }
    }
}
