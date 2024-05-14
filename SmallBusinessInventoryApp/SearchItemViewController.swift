//
//  SearchItemViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/8/24.
//

// search 的时候用这个NSPredicate



import UIKit
import CoreData

class SearchItemViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var items: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        
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
}

    
//    var fetchedResultsController: NSFetchedResultsController<InventoryItem>!
//    var managedObjectContext: NSManagedObjectContext!
//    
    
