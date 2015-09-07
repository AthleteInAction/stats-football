
//
//  DownMKR.swift
//  stats-football
//
//  Created by grobinson on 8/26/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class LosMKR: UIView {
    
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
        
        let s = field.tracker.log[field.tracker.index]
        
        let pos_right: Bool = (s.pos_id == field.tracker.homeTeam && field.tracker.rightHome) || (s.pos_id == field.tracker.awayTeam && !field.tracker.rightHome)
        
        if pos_right {
            
            if nex > field.fd.center.x { center.x = nex }
            
        } else {
            
            if nex < field.fd.center.x { center.x = nex }
            
        }
        
        field.ball.center.x = center.x
        
        s.startX = field.toY(nex).fullToYard(pos_right)
        
        field.tracker.sequenceTBL.reloadData()
        field.tracker.sequenceTBL.selectRowAtIndexPath(NSIndexPath(forRow: field.tracker.index, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.Top)
        
    }
    
    func moveTo(yardline: Int,pos_right: Bool){
        
        var y: CGFloat = 0
        
        let full = yardline.yardToFull(pos_right)
        
        center.x = field.toX(full)
        
    }
    
    func getY() -> Int {
        
        let y = Int(round(center.x / field.ratio)) - 10
        
        return y
        
    }

}