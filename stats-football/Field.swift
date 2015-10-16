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
    
    var arrows: UIImageView!
    
    override func drawRect(rect: CGRect) {
        
        ratio = CGFloat(bounds.width) / 120
        vratio = CGFloat(bounds.height) / 53.33
        
        if !ready {
            
            setData()
            tracker.setData()
            
        } else {
            
            if tracker.game.sequences.count > 0 {
                
                let s = tracker.game.sequences[tracker.index]
                
                let c = UIGraphicsGetCurrentContext()
                
                let pos_right: Bool = tracker.posRight(s)
                
                var x = s.startX.toX(pos_right)
                var y = s.startY.toP() * bounds.height
                if pos_right { y = (100 - s.startY).toP() * bounds.height }
                
                var prev: Play?
                for (i,play) in enumerate(s.plays) {
                    
                    if let endX = play.endX {
                        
                        if i == 0 {
                            
                            switch play.key as Key {
                            case .Run:
                                
                                x = s.startX.increment(-3).toX(pos_right)
                                
                            case .Pass,.Incomplete,.Interception:
                                
                                x = s.startX.increment(-4).toX(pos_right)
                                
                            case .Punt:
                                
                                x = s.startX.increment(-12).toX(pos_right)
                                
                            default:
                                
                                x = s.startX.toX(pos_right)
                                
                            }
                            
                        }
                        
                        CGContextMoveToPoint(c,CGFloat(x),CGFloat(y))
                        
                        x = endX.toX(pos_right)
                        y = play.endY!.toP() * bounds.height
                        if tracker.posRight(s) { y = (100 - play.endY!).toP() * bounds.height }
                        
                        CGContextSetLineWidth(c, 10.0)
                        
                        var color = Filters.colors(play.key, alpha: 1).CGColor
                        
                        switch play.key as Key {
                        case .Pass,.Incomplete,.Interception,.Punt,.Kick:
                            CGContextSetLineDash(c, 10, [6,3], 2)
                        default: ()
                        }
                        
                        CGContextSetStrokeColorWithColor(c,color)
                        
                        switch play.key as Key {
                        case .FGM,.FGA,.Sack: ()
                        default:
                            
                            CGContextAddLineToPoint(c,CGFloat(x),CGFloat(y))
                            CGContextStrokePath(c)
                            
                        }
                        
                        CGContextMoveToPoint(c,CGFloat(x),CGFloat(y))
                        
                        prev = play
                        
                    }
                    
                }
                
            }
            
        }
        
        ready = true
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
    }
    
    func setData(){
        
        let a = UIImage(named: "arrows.png")
        arrows = UIImageView(image: a)
        arrows.frame = CGRect(x: -1053, y: 0, width: 1053, height: 63)
        arrows.tag = -1
        arrows.alpha = 0.1
        insertSubview(arrows, atIndex: 1)
        
        highlight = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 0))
        highlight.alpha = 0.2
        highlight.backgroundColor = UIColor.whiteColor()
        highlight.tag = -1
        addSubview(highlight)
        
        line = LineMKR(frame: CGRect(x: -100, y: 0, width: ratio, height: bounds.height))
        line.field = self
        line.backgroundColor = Filters.colors(.Run, alpha: 1)
        line.tag = -1
        insertSubview(line, atIndex: 2)
        
        fd = FirstDownMKR(frame: CGRect(x: -100, y: 0, width: ratio, height: bounds.height))
        fd.field = self
        fd.backgroundColor = Filters.colors(.Penalty, alpha: 1)
        fd.tag = -1
        insertSubview(fd, atIndex: 3)
        fd.hidden = true
        
        crossH = UIView(frame: CGRect(x: 0, y: 300, width: bounds.width, height: ratio/2))
        crossH.backgroundColor = UIColor.whiteColor()
        crossH.alpha = 0.5
        crossH.tag = -1
        addSubview(crossH)
        
        crossV = UIView(frame: CGRect(x: 30, y: 0, width: ratio/2, height: bounds.height))
        crossV.backgroundColor = UIColor.whiteColor()
        crossV.alpha = 0.5
        crossV.tag = -1
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        tracker.fieldTouchesBegan(touches)
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        tracker.fieldTouchesMoved(touches)
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        tracker.fieldTouchesEnded(touches)
        
    }
    
}