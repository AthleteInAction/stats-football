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
                
                var x = play.endX!.toX(pos_right)
                var y = play.endY!.toP() * field.bounds.height
                if posRight(s) { y = (100 - play.endY!).toP() * field.bounds.height }
                
                if i == 0 {
                    
                    var ox: CGFloat!
                    switch play.key as Key {
                    case .Run,.FumbledSnap:
                        
                        ox = Yardline(spot: s.startX.spot - 3).toX(pos_right)
                        
                    case .Pass,.Incomplete,.Interception:
                        
                        ox = Yardline(spot: s.startX.spot - 4).toX(pos_right)
                        
                    case .Punt:
                        
                        ox = Yardline(spot: s.startX.spot - 12).toX(pos_right)
                        
                    default:
                        
                        ox = s.startX.toX(pos_right)
                        
                    }
                    
                    var oy = s.startY.toP() * field.bounds.height
                    if posRight(s) { oy = (100 - s.startY).toP() * field.bounds.height }
                    
                    switch play.key as Key {
                    case .Pass,.Punt,.Kick,.BadSnap,.FumbledSnap,.Incomplete,.Interception:
                        
                        let obutton = UIButton.buttonWithType(.Custom) as! UIButton
                        obutton.frame = CGRectMake(0,0,26,26)
                        obutton.layer.cornerRadius = 0.3 * obutton.bounds.size.width
                        obutton.titleLabel?.font = UIFont.systemFontOfSize(14)
                        obutton.backgroundColor = Filters.colors(play.key, alpha: 1)
                        obutton.setTitleColor(Filters.textColors(play.key, alpha: 1), forState: .Normal)
                        obutton.setTitle(play.player_a.string(), forState: .Normal)
                        obutton.center = CGPoint(x: ox, y: oy)
                        obutton.tag = -1
                        obutton.userInteractionEnabled = false
                        field.addSubview(obutton)
                        
                    case .FGM,.FGA: ()
                    default:
                        
                        let obutton = UIButton.buttonWithType(.Custom) as! UIButton
                        obutton.frame = CGRectMake(0,0,16,16)
                        obutton.layer.cornerRadius = 0.3 * obutton.bounds.size.width
                        obutton.backgroundColor = Filters.colors(play.key, alpha: 1)
                        obutton.setTitleColor(Filters.textColors(play.key, alpha: 1), forState: .Normal)
                        obutton.center = CGPoint(x: ox, y: oy)
                        obutton.tag = -1
                        obutton.userInteractionEnabled = false
                        field.addSubview(obutton)
                        
                    }
                    
                }
                
                var button = PointBTN.buttonWithType(.Custom) as! PointBTN
                
                switch play.key as Key {
                case .Kick,.Punt:
                    
                    button.frame = CGRectMake(0,0,20,20)
                    
                default:
                    
                    button.frame = CGRectMake(0,0,26,26)
                    
                    if let p = play.player_b {
                        button.setTitle(p.string(), forState: UIControlState.Normal)
                    } else {
                        button.setTitle(play.player_a.string(), forState: UIControlState.Normal)
                    }
                    
                }
                
                button.layer.cornerRadius = 0.3 * button.bounds.size.width
                button.titleLabel?.font = UIFont.systemFontOfSize(14)
                button.tag = -1
                button.index = i
                button.center = CGPoint(x: x, y: CGFloat(y))
                button.setTitleColor(Filters.textColors(play.key, alpha: 1.0), forState: UIControlState.Normal)
                button.backgroundColor = Filters.colors(play.key, alpha: 1.0)
                
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