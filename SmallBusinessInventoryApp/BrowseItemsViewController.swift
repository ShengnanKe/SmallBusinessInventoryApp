//
//  BrowseItemsViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/11/24.
//


// browse inventory items by location, section, or container.


import UIKit
import CoreData

class BrowseItemsViewController: UIViewController{//, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!

    var locations: [Location] = []
    var selectedLocation: Location?
    var selectedSection: Section?
    var selectedContainer: Container?
    var items: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        pickerView.delegate = self
//        pickerView.dataSource = self
//        tableView.delegate = self
//        tableView.dataSource = self

    }

}
