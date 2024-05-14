//
//  LocationTableViewCell.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/13/24.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with locationName: String) {
        nameLabel.text = locationName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
