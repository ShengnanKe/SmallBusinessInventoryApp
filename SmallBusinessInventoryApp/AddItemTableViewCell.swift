//
//  AddItemTableViewCell.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/15/24.
//

import UIKit

class AddItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    func configure(with item: Item) {
        itemNameLabel.text = item.name
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
