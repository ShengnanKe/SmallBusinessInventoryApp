//
//  AddSectionTableViewCell.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/14/24.
//

import UIKit

class AddSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sectionNameLabel: UILabel!
    
    func configure(with section: Section) {
        sectionNameLabel.text = section.name
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
