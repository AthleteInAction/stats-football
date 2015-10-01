//
//  BallBTN.swift
//  stats-football
//
//  Created by grobinson on 8/31/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class BallBTN: UIButton {

    var field: Field!
    
    var pan = UIPanGestureRecognizer()
    
    var lastLocation:CGPoint = CGPointMake(0,0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pan = UIPanGestureRecognizer(target: self, action: "dragged:")
        addGestureRecognizer(pan)
        
        userInteractionEnabled = true
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        lastLocation = center
        
    }
    
    func dragged(sender: UIPanGestureRecognizer){
        
        var translation  = sender.translationInView(superview!)
        
    }

}