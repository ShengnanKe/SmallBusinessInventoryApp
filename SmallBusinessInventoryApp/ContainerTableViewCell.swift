//
//  ContainerTableViewCell.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/14/24.
//

import UIKit

class ContainerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with name: String) {
        containerNameLabel.text = name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
