//
//  MyContactsTableViewCell.swift
//  Chat
//
//  Created by SherifShokry on 3/20/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import UIKit

class MyContactsTableViewCell: UITableViewCell {

   
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userNameTextField: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
