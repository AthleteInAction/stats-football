//
//  SequenceCell.swift
//  stats-football
//
//  Created by grobinson on 9/22/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class SequenceCell: UITableViewCell {
    
    var sequence: Sequence!

    @IBOutlet weak var flag: UIView!
    @IBOutlet weak var leftTXT: UILabel!
    @IBOutlet weak var midTXT: UILabel!
    @IBOutlet weak var rightTXT: UILabel!
    @IBOutlet weak var team: UIView!
    @IBOutlet weak var penalty: UIView!
    @IBOutlet weak var qtrTXT: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            
            backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 241/255, alpha: 1)
            
        } else {
            
            backgroundColor = UIColor.whiteColor()
            
        }
        
    }
    
}