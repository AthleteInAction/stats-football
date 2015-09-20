
//
//  DownMKR.swift
//  stats-football
//
//  Created by grobinson on 8/26/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class FirstDownMKR: UIView {
    
    var field: Field!
    
    var lastLocation:CGPoint = CGPointMake(0,0)
    
    var pan: UIPanGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pan = UIPanGestureRecognizer(target: self, action: "dragged:")
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
    
    func dragged(sender: UIPanGestureRecognizer){
        
        var translation  = sender.translationInView(superview!)
        
        var nex = round((lastLocation.x + translation.x) / field.ratio) * field.ratio
        
        let min = 10 * field.ratio
        let max = 110 * field.ratio
        
        if nex > max { nex = max }
        if nex < min { nex = min }
        
        if nex <= min || nex >= max {
            
            backgroundColor = UIColor.redColor()
            
        } else {
            
            backgroundColor = UIColor.yellowColor()
            
        }
        
        let s = field.tracker.game.sequences[field.tracker.index]
        
        let pos_right = field.tracker.posRight(s)
        
        if pos_right {
            
            if nex < field.los.center.x { center.x = nex }
            
        } else {
            
            if nex > field.los.center.x { center.x = nex }
            
        }
        
        s.fd = field.toY(center.x).fullToYard(pos_right)
        
        if sender.state == UIGestureRecognizerState.Ended {
            
            println("<<< FD DRAG ENDED >>>")
            
            s.save(nil)
            
        }
        
        field.tracker.sequenceTBL.reloadData()
        
        field.tracker.sequenceTBL.selectRowAtIndexPath(NSIndexPath(forRow: field.tracker.index, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.Top)
        
    }
    
    func moveTo(yardline: Int,pos_right: Bool){
        
        var y: CGFloat = 0
        
        let full = yardline.yardToFull(pos_right)
        
        if yardline == 100 {
            
            backgroundColor = UIColor.redColor()
            
        } else {
            
            backgroundColor = UIColor.yellowColor()
            
        }
        
        center.x = field.toX(full)
        
    }
    
    func getY() -> Int {
        
        let y = Int(round(center.x / field.ratio)) - 10
        
        return y
        
    }
    
}