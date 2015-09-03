//
//  SubBTN.swift
//  stats-football
//
//  Created by grobinson on 9/1/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class SubBTN: UIButton {

    var d: Field!
    
    var play: Play!
    
    var log: [Sequence]!
    var sequenceIndex: Int!
    var playIndex: Int!
    var buttonIndex: Int!
    var itemIndex: Int!
    var type: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        
        
    }

}
