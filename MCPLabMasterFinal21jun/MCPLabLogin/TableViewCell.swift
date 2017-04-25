//
//  TableViewCell.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 7/10/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var sharedButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
