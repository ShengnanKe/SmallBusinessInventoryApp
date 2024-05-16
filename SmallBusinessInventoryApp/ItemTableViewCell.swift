//
//  ItemTableViewCell.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/14/24.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    func configure(with itemName: String) {
        itemNameLabel.text = itemName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
