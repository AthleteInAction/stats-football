//
//  Field.swift
//  stats-football
//
//  Created by grobinson on 8/26/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class Field: UIView {
    
    var tracker: Tracker!
    
    var crossH: UIView!
    var crossV: UIView!
    
    var highlight: UIView!
    
    var line: LineMKR!
    var fd: FirstDownMKR!
    
    var ready: Bool = false
    
    override func drawRect(rect: CGRect) {
        
        ratio = CGFloat(bounds.width) / 120
        vratio = CGFloat(bounds.height) / 53.33
        
        if !ready {
            
            setData()
            tracker.setData()
            
        }
        
        for v in subviews { if v.tag == -2 { v.removeFromSuperview() } }
        
        if tracker.game.sequences.count > 0 {
            
            let s = tracker.game.sequences[tracker.index]
            
            let c = UIGraphicsGetCurrentContext()
            
            let pos_right: Bool = tracker.posRight(s)
            
            var x = s.startX.toX(pos_right)
            var y = s.startY.toP() * bounds.height
            if tracker.posRight(s) { y = (100 - s.startY).toP() * bounds.height }
            
            CGContextMoveToPoint(c,CGFloat(x),CGFloat(y))
            
            var prev: Play?
            for (i,play) in enumerate(s.plays) {
                
                if let endX = play.endX {
                    
                    x = endX.toX(pos_right)
                    y = play.endY!.toP() * bounds.height
                    if tracker.posRight(s) { y = (100 - play.endY!).toP() * bounds.height }
                    
                    CGContextSetLineWidth(c, 10.0)
                    CGContextSetLineDash(c, 10, [6,3], 2)
                    
                    var color = Filters.colors(play.key, alpha: 0.7).CGColor
                    
                    CGContextSetStrokeColorWithColor(c,color)
                    
                    CGContextAddLineToPoint(c,CGFloat(x),CGFloat(y))
                    
                    CGContextStrokePath(c)
                    
                    CGContextMoveToPoint(c,CGFloat(x),CGFloat(y))
                    
                    prev = play
                    
                }
                
            }
            
        }
        
        ready = true
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
    }
    
    func setData(){
        
        highlight = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 0))
        highlight.alpha = 0.2
        highlight.backgroundColor = UIColor.whiteColor()
        addSubview(highlight)
        
        line = LineMKR(frame: CGRect(x: -100, y: 0, width: ratio, height: bounds.height))
        line.field = self
        line.backgroundColor = UIColor.blueColor()
        addSubview(line)
        
        fd = FirstDownMKR(frame: CGRect(x: -100, y: 0, width: ratio, height: bounds.height))
        fd.field = self
        fd.backgroundColor = UIColor.yellowColor()
        addSubview(fd)
        fd.hidden = true
        
        crossH = UIView(frame: CGRect(x: 0, y: 300, width: bounds.width, height: ratio/2))
        crossH.backgroundColor = UIColor.whiteColor()
        crossH.alpha = 0.5
        addSubview(crossH)
        
        crossV = UIView(frame: CGRect(x: 30, y: 0, width: ratio/2, height: bounds.height))
        crossV.backgroundColor = UIColor.whiteColor()
        crossV.alpha = 0.5
        addSubview(crossV)
        
        hideCrosses()
        
    }
    
    func lineDragged(touches: Set<NSObject>) -> Bool {
        
        let s = tracker.game.sequences[tracker.index]
        let cell = tracker.sequenceTBL.cellForRowAtIndexPath(NSIndexPath(forRow: tracker.index, inSection: 0)) as! SequenceCell
        
        let t: UITouch = touches.first as! UITouch
        let l: CGPoint = t.locationInView(self)
        
        return true
        
    }
    
    func showCrosses(){
        
        crossV.hidden = false
        crossH.hidden = false
        
    }
    
    func hideCrosses(){
        
        crossV.hidden = true
        crossH.hidden = true
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        tracker.fieldTOuchesMoved(touches)
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        tracker.fieldTOuchesEnded(touches)
        
    }
    
}