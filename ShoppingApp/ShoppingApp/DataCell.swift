//
//  DataCell.swift
//  ShoppingApp
//
//  Created by Porcaro, Keano Dean - porkd002 on 12/11/17.
//  Copyright © 2017 Porcaro, Keano Dean - porkd002. All rights reserved.
//

import UIKit

/* This class isn't used in the application. I just left it because it serves a good template */
class DataCell: UITableViewCell {
    
    /* Label that is used to store data in the cell */
    @IBOutlet weak var label: UILabel!
    
    /* Inherited function */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /* Configure the view for the selected state */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /* Set the data in the cell */
    func congigureCell(text: String) {
        label.text = text
    }
}
