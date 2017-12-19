//
//  TableViewCell.swift
//  Weather Forever
//
//  Created by Patrick Moening on 12/9/17.
//  Copyright © 2017 Patrick Moening. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {
    
    
    @IBOutlet weak var cityLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
