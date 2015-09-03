
//
//  DownMKR.swift
//  stats-football
//
//  Created by grobinson on 8/26/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class DownMKR: UIView {
    
    var field: Field!
    
    var lastLocation:CGPoint = CGPointMake(0,0)
    
    var pan: UIPanGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pan = UIPanGestureRecognizer(target: self, action: "dDrag:")
        addGestureRecognizer(pan)
        
        alpha = 0.7
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
        
        var nex = round((lastLocation.x + translation.x) / field.ratio) * field.ratio
        
        let min = 11 * field.ratio
        let max = 109 * field.ratio
        
        if nex > max { nex = max }
        if nex < min { nex = min }
        
        center.x = nex
        
        field.ball.center.x = nex
        field.tracker.updateSequence()
        
    }
    
    func moveTo(yardline: Int,pos_right: Bool){
        
        var y: CGFloat = 0
        
        if pos_right {
            
            if yardline > -50 && yardline < 0 {
                
                y = 100 - (CGFloat(yardline) * -1)
                
            }
            
            if yardline > 0 && yardline < 50 {
                
                y = CGFloat(yardline)
                
            }
            
        } else {
            
            if yardline > -50 && yardline < 0 {
                
                y = (CGFloat(yardline) * -1)
                
            }
            
            if yardline > 0 && yardline < 50 {
                
                y = 100 - CGFloat(yardline)
                
            }
            
        }
        
        y += 10
        
        center.x = y * field.ratio
        
    }
    
    func getY() -> Int {
        
        let y = Int(round(center.x / field.ratio)) - 10
        
        return y
        
    }

}