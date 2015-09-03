//
//  Field.swift
//  stats-football
//
//  Created by grobinson on 8/26/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class Field: UIView {
    
    var ball: BallBTN!
    
    var tracker: TrackerCTRL!
    
    var ratio: CGFloat!
    var vratio: CGFloat!
    
    var crossH: UIView!
    var crossV: UIView!
    
    var los: DownMKR!
    var fd: DownMKR!
    var cr: CGFloat?
    
    var buttons: [PointBTN] = []
    
    var tap = UITapGestureRecognizer()
    
    override func drawRect(rect: CGRect) {
        
        if tracker.log.count > 0 {
            
            let s = tracker.log[tracker.index]
            
            let c = UIGraphicsGetCurrentContext()
            
            var x = toX(s.startX.yardToFull(s.pos_right))
            var y = toP(s.startY)
            
            CGContextMoveToPoint(c,CGFloat(x),CGFloat(y))
            
            var prev: Play?
            
            var i = 0
            for play in reverse(s.plays) {
                
                x = toX(play.endX!.yardToFull(s.pos_right))
                y = toP(play.endY!)
                
                CGContextSetLineWidth(c, 10.0)
                CGContextSetLineDash(c, 10, [6,3], 2)
                
                var color = UIColor.blackColor().CGColor
                
                switch play.key {
                case "run":
                    color = UIColor(red: 57/255, green: 140/255, blue: 183/255, alpha: 0.7).CGColor
                case "pass":
                    color = UIColor(red: 53/255, green: 255/255, blue: 63/255, alpha: 0.7).CGColor
                case "kick","punt":
                    color = UIColor(red: 255/255, green: 120/255, blue: 0, alpha: 0.7).CGColor
                case "penalty":
                    color = UIColor(red: 255/255, green: 228/255, blue: 0, alpha: 0.7).CGColor
                case "interception":
                    color = UIColor(red: 255/255, green: 47/255, blue: 47/255, alpha: 0.7).CGColor
                case "lateral":
                    color = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.7).CGColor
                default:
                    color = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7).CGColor
                }
                
                CGContextSetStrokeColorWithColor(c,color)
                
                CGContextAddLineToPoint(c,CGFloat(x),CGFloat(y))
                
                CGContextStrokePath(c)
                
                CGContextMoveToPoint(c,CGFloat(x),CGFloat(y))
                
                prev = play
                
                tracker.drawSubButtons(i)
                
                i++
                
            }
            
        }
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        ball = BallBTN(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        ball.setImage(UIImage(named: "icon-football.png"), forState: .Normal)
        ball.field = self
        
        tap.addTarget(self, action: "fieldTPD")
        tap.numberOfTapsRequired = 2
        
        addGestureRecognizer(tap)
        
        ratio = CGFloat(bounds.width) / 120
        vratio = CGFloat(bounds.height) / 53.33
        
        los = DownMKR(frame: CGRect(x: 20/*yarline*/ * ratio-(ratio/2), y: 0, width: ratio, height: bounds.height))
        los.field = self
        los.backgroundColor = UIColor.blueColor()
        addSubview(los)
        
        fd = DownMKR(frame: CGRect(x: 30/*yarline*/ * ratio-(ratio/2), y: 0, width: ratio, height: bounds.height))
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
        
        ball.center = los.center
        addSubview(ball)
        
        cr = los.center.x
        
        hideCrosses()
        
    }
    
    func toX(y: Int) -> CGFloat {
        
        let ney = (CGFloat(y)+10) * ratio
        
        return ney
        
    }
    
    func toY(x: CGFloat) -> Int {
        
        let ney = round(x / ratio) - 10
        
        return Int(ney)
        
    }
    
    func toP(p: Int) -> Int{
        
        let n = Int(round((CGFloat(p) / 100) * bounds.height))
        
        return n
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        tracker.fieldTOuchesMoved(touches)
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        tracker.fieldTOuchesEnded(touches)
        
    }
    
    func showCrosses(){
        
        crossV.hidden = false
        crossH.hidden = false
        
    }
    
    func hideCrosses(){
        
        crossV.hidden = true
        crossH.hidden = true
        
    }
    
    func markerMoved(){
        
//        d.markerMoved()
        
    }
    
    func draw(){
        
        self.setNeedsDisplay()
        
    }
    
    func fieldTPD(){
        
        tracker.fieldTPD()
        
    }
    
    func buttonDragged(sender: UIPanGestureRecognizer){
        
        var t = sender.translationInView(superview!)
        
    }
    
    func mirrorLOS(){
        
        ball.center.x = los.center.x
        
    }

}

extension Int {
    
    // CONVERT -40/40 to 40/60
    func yardToFull(pos_right: Bool) -> Int {
        
        var nex = self
        
        if pos_right {
        // RIGHT TO LEFT
            
            // RIGHT SIDE OF FIELD
            if self > -50 && self < 0 {
                
                nex = 100 - (self * -1)
                
            }
            
        } else {
        // LEFT TO RIGHT
            
            // RIGHT SIDE OF FIELD
            if self > 0 && self < 50 {
                
                nex = 100 - self
                
            }
            
            // LEFT SIDE OF FIELD
            if self > -50 && self < 0 {
                
                nex = self * -1
                
            }
            
        }
        
        return nex
        
    } // CONVERT -40/40 to 40/60
    
    // FLIP SPOT
    func flipSpot() -> Int {
        
        var spot = self
        
        if self != 50 { spot *= -1 }
        
        return spot
        
    }
    
}