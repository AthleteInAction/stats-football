//
//  ButtonDragged.swift
//  stats-football
//
//  Created by grobinson on 9/27/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

extension Tracker {
    
    // BUTTON DRAGGED
    // ========================================================
    // ========================================================
    func buttonDragged(sender: UIPanGestureRecognizer){
        
        let t = sender.translationInView(field)
        
        let b: PointBTN = sender.view as! PointBTN
        
        let s = game.sequences[index]
        
        let play = s.plays[b.index]
        
        let pos_right = posRight(s)
        
        // BEGAN
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if sender.state == UIGestureRecognizerState.Began {
            
            bLast = sender.view?.center
            
        }
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        // CHANGED
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if sender.state == UIGestureRecognizerState.Changed {
            
            let min = ratio
            let max = 119 * ratio
            let vmin = b.bounds.height / 2
            let vmax = field.bounds.height - (b.bounds.height / 2)
            
            var x = round((t.x + bLast.x) / ratio) * ratio
            var ly = t.y + bLast.y
            var y = ly
            
            if x < min { x = min }
            if x > max { x = max }
            if y < vmin { y = vmin }
            if y > vmax { y = vmax }
            
            sender.view?.center.x = x
            sender.view?.center.y = y
            
            play.endX = Yardline(x: x, pos_right: pos_right)
            play.endY = Int(round((y / field.bounds.height) * 100))
            if pos_right { play.endY = 100 - play.endY! }
            
            field.showCrosses()
            field.crossV.center.x = x
            field.crossH.center.y = y
            
            if b.index == 0 {
                
                var pct: CGFloat {
                    
                    return y / field.bounds.height
                    
                }
                
                switch play.key as Key {
                case .Run:
                    
                    let r = settings.runSections
                    let ss = settings.sectionSize(pct: pct, height: field.bounds.height, sections: r)
                    
                    let _frame = CGRect(x: 0, y: ss[0], width: field.bounds.width, height: ss[1])
                    field.highlight.backgroundColor = Filters.colors(.Run, alpha: 1)
                    field.highlight.frame = _frame
                    field.highlight.hidden = false
                    
                case .Pass:
                    
                    let r = settings.passSections
                    let ss = settings.sectionSize(pct: pct, height: field.bounds.height, sections: r)
                    
                    let _frame = CGRect(x: 0, y: ss[0], width: field.bounds.width, height: ss[1])
                    field.highlight.backgroundColor = Filters.colors(.Pass, alpha: 1)
                    field.highlight.frame = _frame
                    field.highlight.hidden = false
                    
                default: ()
                }
                
            }
            
            let ip = NSIndexPath(forRow: b.index, inSection: 0)
            JP("INDEX: \(ip.row)")
            playTBL.reloadRowsAtIndexPaths([ip], withRowAnimation: .None)
            
            field.setNeedsDisplay()
            
        }
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        // ENDED
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if sender.state == UIGestureRecognizerState.Ended {
            
            play.save(nil)
            
            field.hideCrosses()
            field.highlight.hidden = true
            
            updateScore()
            
        }
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
    }
    // ========================================================
    // ========================================================
    
}