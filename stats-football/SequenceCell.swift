//
//  SequenceCell.swift
//  stats-football
//
//  Created by grobinson on 9/22/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class SequenceCell: UITableViewCell {

    @IBOutlet weak var leftTXT: UILabel!
    @IBOutlet weak var midTXT: UILabel!
    @IBOutlet weak var rightTXT: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            
            backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
            
        } else {
            
            backgroundColor = UIColor.whiteColor()
            
        }
        
    }
    
}