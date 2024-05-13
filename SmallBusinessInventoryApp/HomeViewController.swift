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
 
 Item to Tag: One-to-One
 
 
 Location: id & name
 Section: id & name
 Container: id & name
 Item: id, name, photo(save the path to the file -> String), description, ownership status, tag(s)
 
 */

import UIKit
import CoreData

class HomeViewController: UIViewController {//}, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var homePageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSPersistentContainer.defaultDirectoryURL()
        homePageLabel.text = "Home Page"
        
    }
    
}
