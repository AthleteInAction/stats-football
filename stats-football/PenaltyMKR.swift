//
//  PenaltyMKR.swift
//  stats-football
//
//  Created by grobinson on 9/6/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PenaltyMKR: UIButton {
    
    var tracker: Tracker!
    
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
        
        var nex = round((lastLocation.x + translation.x) / ratio) * ratio
        
        var yard_inc: Int = Int(round(translation.x / ratio))
        
        var x = p.endX!.spot + yard_inc
        
        if pos_right {
            x = p.endX!.spot - yard_inc
        }
        
        if x < 1 { x = 1 }
        if x > 99 { x = 99 }
        
        let newEndX = Yardline(spot: x)
        
        setMKR(newEndX)
        
        if sender.state == UIGestureRecognizerState.Ended {
            
            p.endX = newEndX
            
            p.save(nil)
            
            s.getPenalties()
            
            tracker.penaltyTBL.penalties = s.penalties
            
            tracker.updateScore()
            
        }
        
        let ip = NSIndexPath(forRow: index, inSection: 0)
        tracker.penaltyTBL.reloadRowsAtIndexPaths([ip], withRowAnimation: .None)
        
    }
    
    func setMKR(spot: Yardline) -> Bool {
        
        let s = tracker.game.sequences[tracker.index]
        
        let penalty = s.penalties[index]
        
        let pos_right = tracker.posRight(s)
        
        var w = CGFloat(penalty.distance) * ratio
        var x = spot.toX(pos_right)
        
        var _frame: CGRect!
        
        // If the penalty is on the original team
        if s.team.object.isEqual(penalty.team.object) {
            
            let half = penalty.distance
            
            if spot.spot < half {
                
                w = CGFloat(spot.spot) * ratio
                
            }
            
            if pos_right { x = x - w }
            
        } else {
            
            let half = 100 - penalty.distance
            
            if spot.spot > half {
                
                w = CGFloat((100 - spot.spot)) * ratio
                
            }
            
            if !pos_right { x = x - w }
            
        }
        
        _frame = CGRect(x: x, y: 0, width: w, height: tracker.field.bounds.height)
        
        frame = _frame
        
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