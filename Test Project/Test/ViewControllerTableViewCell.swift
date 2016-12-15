//
//  ViewControllerTableViewCell.swift
//  Test
//
//  Created by Marcin on 14/12/2016.
//  Copyright © 2016 MarcinSteciuk. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherCellLabel: UILabel!
    
    @IBOutlet weak var weatherCellImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
