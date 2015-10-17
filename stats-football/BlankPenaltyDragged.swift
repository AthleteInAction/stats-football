//
//  BlankPenaltyDragged.swift
//  stats-football
//
//  Created by grobinson on 10/16/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import Foundation
import UIKit

extension Tracker {
    
    func blankPenaltyDragged(sender: UIPanGestureRecognizer){
        
        let t = sender.translationInView(field)
        
        let vw = sender.view as! PenaltyVW
        
        let s = game.sequences[index]
        
        let penalty = s.penalties[vw.index]
        
        let pos_right = posRight(s)
        
        // BEGAN
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if sender.state == UIGestureRecognizerState.Began {
            
            bLast = sender.view!.center
            
        }
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        // CHANGED
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if sender.state == UIGestureRecognizerState.Changed {
            
            let min = ratio
            let max = 119 * ratio
            let vmin = sender.view!.bounds.height / 2
            let vmax = field.bounds.height - (sender.view!.bounds.height / 2)
            
            var x = round((t.x + bLast.x) / ratio) * ratio
            var ly = t.y + bLast.y
            var y = ly
            
            if x < min { x = min }
            if x > max { x = max }
            if y < vmin { y = vmin }
            if y > vmax { y = vmax }
            
            sender.view!.center.x = x
            sender.view!.center.y = y
            
            penalty.endX = Yardline(x: x, pos_right: pos_right)
            penalty.endY = Int(round((y / field.bounds.height) * 100))
            if pos_right { penalty.endY = 100 - penalty.endY! }
            
        }
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        // ENDED
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if sender.state == UIGestureRecognizerState.Ended {
            
            penalty.save(nil)
            
        }
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
    }
    
}