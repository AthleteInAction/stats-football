
//
//  DownMKR.swift
//  stats-football
//
//  Created by grobinson on 8/26/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class LineMKR: UIView {
    
    var field: Field!
    
    var lastLocation: CGPoint = CGPointMake(0,0)
    
    var pan: UIPanGestureRecognizer!
    
    override func drawRect(rect: CGRect) {
        
//        for i in 0 ... floor(bounds.height / 40) {
//            
//            let txt = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//            
//        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pan = UIPanGestureRecognizer(target: self, action: "dragged:")
        addGestureRecognizer(pan)
        
//        alpha = 0.7
        userInteractionEnabled = true
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        lastLocation = center
        
    }
    
    func dragged(sender: UIPanGestureRecognizer){
        
        if field.tracker.newPlay == nil && field.tracker.newPenalty == nil {
            
            let s = field.tracker.game.sequences[field.tracker.index]
            
            let pos_right = field.tracker.posRight(s)
            
            var translation  = sender.translationInView(superview!)
            
            var nex = round((lastLocation.x + translation.x) / ratio) * ratio
            
            let min = 11 * ratio
            let max = 109 * ratio
            
            if nex > max { nex = max }
            if nex < min { nex = min }
            
            s.startX = Yardline(x: nex, pos_right: pos_right)
            
            center.x = nex
            
            if sender.state == .Ended {
                
                s.save(nil)
                
            }
            
            let ip = NSIndexPath(forRow: field.tracker.index, inSection: 0)
            field.tracker.sequenceTBL.reloadRowsAtIndexPaths([ip], withRowAnimation: .None)
            
            field.setNeedsDisplay()
            
        }
        
    }

}