//
//  ItemTableViewCell.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/10/24.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var itemImageView: UIImageView!
    
    func configure(with item: [String: Any]) {
        nameLabel.text = item["name"] as? String
        descriptionTextView.text = item["description"] as? String
        if let imageData = item["photo"] as? UIImage {
            itemImageView.image = imageData
        } else {
            itemImageView.image = nil
        }
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
