//
//  SearchItemViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/8/24.
//



import UIKit
import CoreData

class SearchItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
//        setupFetchedResultsController()
    }
    
    
    
    
    
    
//    var fetchedResultsController: NSFetchedResultsController<InventoryItem>!
//    var managedObjectContext: NSManagedObjectContext!
//    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//
//    
//    func setupFetchedResultsController() {
//        let fetchRequest: NSFetchRequest<InventoryItem> = InventoryItem.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//        try? fetchedResultsController.performFetch()
//        // before reload table -> Thread.current ???
//        searchTableView.reloadData()
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        var predicates: [NSPredicate] = []
//        if !searchText.isEmpty {
//            predicates.append(NSPredicate(format: "name CONTAINS[cd] %@", searchText))
//            predicates.append(NSPredicate(format: "itemDescription CONTAINS[cd] %@", searchText))
//            // tbc
//        }
//        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
//        try? fetchedResultsController.performFetch()
//        searchTableView.reloadData()
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
//        let item = fetchedResultsController.object(at: indexPath)
//        return cell
//    }
//    
    
}
