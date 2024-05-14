//
//  ItemDetailViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/10/24.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    var item: Item!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ownershipStatusLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Item Details"
        setupItemDetails()
    }
    
    private func setupItemDetails() {
        nameLabel.text = item.name
        descriptionLabel.text = item.itemdescription
        ownershipStatusLabel.text = item.ownershipstatus ? "Owned" : "Borrowed"
        
        if let imagePath = item.photo, !imagePath.isEmpty {
            imageView.image = UIImage(contentsOfFile: imagePath)
        } else {
            // default image -> dont really have any
            imageView.image = UIImage(named: "defaultImage")
        }
    }
    
    @IBAction func editItemTapped(_ sender: UIButton) {
        let editVC = EditItemViewController()
        editVC.item = item
        navigationController?.pushViewController(editVC, animated: true)
    }
    
}
