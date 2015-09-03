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
        
        pan = UIPanGestureRecognizer(target: self, action: "dDrag:")
        addGestureRecognizer(pan)
        
        userInteractionEnabled = true
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        lastLocation = center
        
    }
    
    func dDrag(sender: UIPanGestureRecognizer){
        
        var translation  = sender.translationInView(superview!)
        
        var nex = lastLocation.y + translation.y
        
        let min: CGFloat = 10
        let max: CGFloat = field.bounds.height - 10
        
        if nex > max { nex = max }
        if nex < min { nex = min }
        
        center.y = nex
        
        field.tracker.updateSequence()
        
    }

}