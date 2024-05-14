//
//  SearchItemTableViewCell.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/14/24.
//

import UIKit
class SearchItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with item: Item) {
        itemNameLabel.text = item.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
