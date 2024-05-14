//
//  SectionTableViewCell.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/13/24.
//

import UIKit

class SectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with name: String) {
        nameLabel.text = name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
