//
//  ItemViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/13/24.
//

import UIKit

class ItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var container: Container?
    var items: [Item] = []
    
    @IBOutlet weak var itemTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTableView.dataSource = self
        itemTableView.delegate = self
        
        self.title = container?.name ?? "Items"
        
        loadItems()
    }
    
    func loadItems() {
        if let container = container {
            DispatchQueue.global(qos: .userInitiated).async {
                let fetchedItems = DBManager.shared.fetchItems(for: container)
                DispatchQueue.main.async {
                    self.items = fetchedItems
                    self.itemTableView.reloadData()
                    print("Loaded items: \(self.items.count)") // Debug logging
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        if let itemName = items[indexPath.row].name {
            cell.configure(with: itemName)
        } else {
            cell.configure(with: "No name available")
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItemDetails" {
            if let detailVC = segue.destination as? ItemDetailViewController,
               let indexPath = itemTableView.indexPathForSelectedRow {
                let selectedItem = items[indexPath.row]
                detailVC.item = selectedItem
            }
        }
    }
}
