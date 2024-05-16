//
//  AddContainerTableViewCell.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/14/24.
//

import UIKit

class AddContainerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerNameLabel: UILabel!
    
    func configure(with container: Container) {
        containerNameLabel.text = container.name
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
