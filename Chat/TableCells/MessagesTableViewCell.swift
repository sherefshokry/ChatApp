//
//  MessagesTableViewCell.swift
//  Chat
//
//  Created by SherifShokry on 3/20/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
