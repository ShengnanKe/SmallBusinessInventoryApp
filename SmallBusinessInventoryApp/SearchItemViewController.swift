//
//  SearchItemViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/8/24.
//

// search 的时候用这个NSPredicate



import UIKit
import CoreData

class SearchItemViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var items: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchItemCell")

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        items = DBManager.shared.fetchItems(matching: searchText)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = "\(item.name ?? "Unknown") - \(item.itemdescription ?? "No Description")"
        return cell
    }
    
    // swipe delete and update ->
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        print("swipr delete actions")
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            let itemToDelete = self.items[indexPath.row]
            if let itemName = itemToDelete.name {
                if DBManager.shared.deleteEntity(entityName: "Item", name: itemName) {
                    self.items.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            } else {
                print("Invalid item name")
                completionHandler(false)
            }
        }
        
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    


}

