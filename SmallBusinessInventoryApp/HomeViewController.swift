//
//  HomeViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/8/24.
//

/*
 
 Location to Section: One-to-Many
 Each Location -> multiple Sections, each Section -> one Location.
 delete rule -> cascade -> when you delete a location, the sections under this location will be deleted too.
 
 Section to Container: One-to-Many
 Each Section -> multiple Containers, each Container -> one Section.
 delete rule -> cascade -> when you delete a section, the containers under this section will be deleted too.
 
 Container to Item: One-to-Many
 Each Container -> multiple Items, each Item -> one Container.
 delete rule -> cascade -> when you delete a container, the items under this container will be deleted too.
 
 
 Location: id & name
 Section: id & name
 Container: id & name
 Item: id, name, photo, description, ownership status, tag(s)
 
 */

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var homePageLabel: UILabel!
    @IBOutlet weak var itemListTableView: UITableView!
    
    var items: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemListTableView.dataSource = self
        itemListTableView.delegate = self
        
        loadItems()
    }
    
    func loadItems() {
        let item1: [String: Any] = [
            "name": "Pen",
            "description": "A pen",
            //"photo": (any BinaryInteger).self,
            "ownershipStatus": true
        ]
        items.append(item1)
        
        
        itemListTableView.reloadData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        let item = items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    
}
