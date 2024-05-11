//
//  BrowseItemsViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/11/24.
//

import UIKit
import CoreData

class BrowseItemsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!

    var locations: [Location] = []
    var selectedLocation: Location?
    var selectedSection: Section?
    var selectedContainer: Container?
    var items: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self

        fetchInitialData()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return locations.count
        case 1:
            return selectedLocation?.sections.count ?? 0
        case 2:
            return selectedSection?.containers.count ?? 0
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return locations[row].name
        case 1:
            return selectedLocation?.sections[row].name
        case 2:
            return selectedSection?.containers[row].name
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedLocation = locations[row]
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        case 1:
            selectedSection = selectedLocation?.sections[row]
            pickerView.reloadComponent(2)
        case 2:
            selectedContainer = selectedSection?.containers[row]
            updateTableView()
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }

    func updateTableView() {
        items = selectedContainer?.items ?? []
        tableView.reloadData()
    }

    func fetchInitialData() {
       
    }
}
