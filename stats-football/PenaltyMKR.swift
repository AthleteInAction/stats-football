//
//  PenaltyMKR.swift
//  stats-football
//
//  Created by grobinson on 9/6/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PenaltyMKR: UIButton {
    
    var tracker: TrackerCTRL!
    
    var index: Int!
    
    var pan = UIPanGestureRecognizer()
    
    var lastLocation: CGPoint!
    
    var dir: Bool = true
    
    var img: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 0.6)
        
        pan = UIPanGestureRecognizer(target: self, action: "dDrag:")
        addGestureRecognizer(pan)
        
        img = UIImageView()
        
        addSubview(img)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        lastLocation = frame.origin
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        
        
    }
    
    func dDrag(sender: UIPanGestureRecognizer){
        
        let s = tracker.game.sequences[tracker.index]
        let p = s.penalties[index]
        
        let pos_right: Bool = tracker.posRight(s)
        
        var translation  = sender.translationInView(superview!)
        
        var nex = round((lastLocation.x + translation.x) / tracker.field.ratio) * tracker.field.ratio
        
        var yard_inc: Int = Int(round(translation.x / tracker.field.ratio))
        
        let newEndX = (p.endX!.yardToFull(pos_right) + yard_inc).fullToYard(pos_right)
        
        setMKR(newEndX)
        
        if sender.state == UIGestureRecognizerState.Ended {
            
            p.endX = newEndX
            p.save(nil)
            tracker.MPC.sendGame(tracker.game)
            tracker.penaltyTBL.reloadData()
            
        }
        
    }
    
    func setMKR(spot: Int) -> Bool {
        
        if (spot <= 50 && spot > 0) || (spot <= -1 && spot >= -49) {
            
        } else {
            return false
        }
        
        let s = tracker.game.sequences[tracker.index]
        let p = s.penalties[index]
        
        let pos_right: Bool = tracker.posRight(s)
        
        var newEndFull = spot.yardToFull(pos_right)
        
        var w = CGFloat(p.distance) * tracker.field.ratio
        
        if pos_right && dir {
            
            if (100 - newEndFull) < p.distance {
                
                w = (100 - CGFloat(newEndFull)) * tracker.field.ratio
                
            }
            
        } else {
            
            if newEndFull < p.distance {
                
                w = CGFloat(newEndFull) * tracker.field.ratio
                
            }
            
        }
        
        var x = tracker.field.toX(newEndFull)
        
        if dir { x -= w }
        
        frame = CGRect(x: x, y: 0, width: w, height: tracker.field.bounds.height)
        
        setArrow(dir)
        
        return true
    
    }
    
    func setArrow(right: Bool){
        
        dir = right
        
        let x = bounds.width / 2
        let y = bounds.height / 2
        
        img.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        img.alpha = 0.6
        
        img.center.x = x
        img.center.y = y
        img.contentMode = UIViewContentMode.ScaleAspectFit
        
        if right {
        
            img.image = UIImage(named: "arrow_r.png")
            
        } else {
            
            img.image = UIImage(named: "arrow_l.png")
            
        }
        
    }

}
