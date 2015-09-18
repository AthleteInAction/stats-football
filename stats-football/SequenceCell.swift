//
//  DownCell.swift
//  stats-football
//
//  Created by grobinson on 9/16/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class SequenceCell: UITableViewCell {
    
    @IBOutlet weak var posIndicator: UIButton!
    @IBOutlet weak var ballPos: UIButton!
    @IBOutlet weak var midTXT: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posIndicator.layer.cornerRadius = 3
        ballPos.layer.cornerRadius = posIndicator.layer.cornerRadius
        
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