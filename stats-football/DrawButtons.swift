//
//  DrawButtons.swift
//  stats-football
//
//  Created by grobinson on 9/27/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit

extension Tracker {
    
    // DRAW BUTTONS
    // ========================================================
    // ========================================================
    func drawButtons(){
        
        let s = game.sequences[index]
        
        for v in field.subviews {
            
            if v.tag == -1 || v.tag == -3 { v.removeFromSuperview() }
            
        }
        
        for (i,penalty) in enumerate(s.penalties) {
            
            if let x = penalty.endX {
                
                let dir = posRight2(penalty.object.team)
                
                var v = PenaltyMKR(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                v.tracker = self
                v.index = i
                v.tag = -3
                v.dir = dir
                v.setMKR(x)
                
                var tap2 = UITapGestureRecognizer()
                tap2.numberOfTapsRequired = 2
                tap2.addTarget(self, action: "penalty2Tapped:")
                v.addGestureRecognizer(tap2)
                
                field.addSubview(v)
                
            }
            
        }
        
        for (i,play) in enumerate(s.plays) {
            
            if let endX = play.endX {
                
                let pos_right = posRight(s)
                
                var button = PointBTN.buttonWithType(.Custom) as! PointBTN
                button.frame = CGRectMake(0,0,30,30)
                button.layer.cornerRadius = 0.5 * button.bounds.size.width
                button.titleLabel?.font = UIFont.systemFontOfSize(14)
                button.tag = -1
                button.index = i
                
                var x = play.endX!.toX(pos_right)
                var y = play.endY!.toP() * field.bounds.height
                if posRight(s) { y = (100 - play.endY!).toP() * field.bounds.height }
                
                button.center = CGPoint(x: x, y: CGFloat(y))
                
                var color = Filters.colors(play.key, alpha: 1.0)
                var textColor = Filters.textColors(play.key, alpha: 1.0)
                
                button.setTitleColor(textColor, forState: UIControlState.Normal)
                button.backgroundColor = color
                
                if play.key == Key.Fumble {
                    
                    if let r = play.team {
                        
                        button.backgroundColor = r.primary
                        
                    }
                    
                }
                
                if let p = play.player_b {
                    button.setTitle(p.string(), forState: UIControlState.Normal)
                } else {
                    button.setTitle(play.player_a.string(), forState: UIControlState.Normal)
                }
                
                var pan = UIPanGestureRecognizer()
                pan.addTarget(self, action: "buttonDragged:")
                
                var tap2 = UITapGestureRecognizer()
                tap2.numberOfTapsRequired = 2
                tap2.addTarget(self, action: "button2Tapped:")
                
                button.addGestureRecognizer(pan)
                button.addGestureRecognizer(tap2)
                
                field.addSubview(button)
                
            }
            
        }
        
    }
    // ========================================================
    // ========================================================
    
}