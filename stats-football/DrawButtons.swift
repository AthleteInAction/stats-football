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
    func drawButtons(z: Bool){
        
        let s = game.sequences[index]
        
        let pos_right = posRight(s)
        
        for v in field.subviews {
            
            if v.tag >= 0 { v.removeFromSuperview() }
            
        }
        
        
        
        var x = s.startX.toX(pos_right)
        var y = s.startY.toP() * field.bounds.height
        if pos_right { y = (100 - s.startY).toP() * field.bounds.height }
        
        var team = s.team
        
        for (i,play) in enumerate(s.plays) {
            
            switch play.key as Key {
            case .Fumble,.FumbledSnap,.BadSnap: if let t = play.team { team = t }
            case .Recovery: team = game.oppositeTeam(team: team)
            default: ()
            }
            
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
                    
                    switch play.key as Key {
                    case .Pass,.Incomplete,.Interception,.Punt,.Kick,.BadSnap,.FumbledSnap:
                        
                        var _key: Key!
                        switch play.key as Key {
                        case .Pass,.Interception,.Incomplete: _key = .Throw
                        default: _key = play.key
                        }
                        
                        let o = PointVW(number: play.player_a, key: _key, team: team)
                        o.center = CGPoint(x: x, y: CGFloat(y))
                        o.userInteractionEnabled = false
                        o.backgroundColor = UIColor.clearColor()
                        field.addSubview(o)
                        
                    case .FGA,.FGM,.Sacked:
                        
                        ()
                        
                    default:
                        
                        let o = UIButton.buttonWithType(.Custom) as! UIButton
                        o.frame = CGRectMake(0,0,16,16)
                        o.layer.cornerRadius = 0.3 * o.bounds.size.width
                        o.backgroundColor = Filters.colors(play.key, alpha: 1)
                        o.center = CGPoint(x: x, y: y)
                        o.userInteractionEnabled = false
                        field.addSubview(o)
                        
                    }
                    
                }
                
                x = endX.toX(pos_right)
                y = play.endY!.toP() * field.bounds.height
                if pos_right { y = (100 - play.endY!).toP() * field.bounds.height }
                
                if !z {
                    
                    switch play.key as Key {
                    case .Kick,.Punt:
                        
                        let button = UIButton.buttonWithType(.Custom) as! UIButton
                        button.frame = CGRectMake(0,0,20,20)
                        button.layer.cornerRadius = 0.3 * button.bounds.size.width
                        button.titleLabel?.font = UIFont.systemFontOfSize(14)
                        button.tag = i
                        button.center = CGPoint(x: x, y: CGFloat(y))
                        button.backgroundColor = Filters.colors(play.key, alpha: 1.0)
                        
                        var pan = UIPanGestureRecognizer()
                        pan.addTarget(self, action: "buttonDragged:")
                        
                        var tap2 = UITapGestureRecognizer()
                        tap2.numberOfTapsRequired = 2
                        tap2.addTarget(self, action: "button2Tapped:")
                        
                        button.addGestureRecognizer(pan)
                        button.addGestureRecognizer(tap2)
                        
                        field.addSubview(button)
                        
                    default:
                        
                        var _n = play.player_a
                        if let p = play.player_b { _n = p }
                        
                        var _key = play.key
                        
                        var _team = team
                        
                        switch play.key as Key {
                        case .Pass:
                            _key = .Reception
                        case .BadSnap,.FumbledSnap:
                            _key = .Recovery
                        case .Interception:
                            _team = game.oppositeTeam(team: team)
                        default:
                            _key = play.key
                        }
                        
                        let button = PointVW(number: _n, key: _key, team: _team)
                        button.center = CGPoint(x: x, y: CGFloat(y))
                        button.tag = i
                        button.userInteractionEnabled = true
                        button.backgroundColor = UIColor.clearColor()
                        
                        var pan = UIPanGestureRecognizer()
                        pan.addTarget(self, action: "buttonDragged:")
                        
//                        var tap2 = UITapGestureRecognizer()
                        var tap2 = UILongPressGestureRecognizer()
                        tap2.addTarget(self, action: "button2Tapped:")
                        
                        button.addGestureRecognizer(pan)
                        button.addGestureRecognizer(tap2)
                        
                        field.addSubview(button)
                        
                    }
                    
                }
                
            }
            
            switch play.key as Key {
            case .Kick,.Punt,.Interception: team = game.oppositeTeam(team: team)
            default: ()
            }
            
        }
        
        for (i,penalty) in enumerate(s.penalties) {
            
            if let _x = penalty.endX {
                
                let dir = posRight2(penalty.object.team)
                
                switch penalty.enforcement as Key {
                case .Declined,.Offset,.OnKick:
                    
                    var v = PenaltyVW(penalty: penalty)
                    v.backgroundColor = UIColor.clearColor()
                    v.index = i
                    
                    var xx = _x.toX(pos_right)
                    var yy = penalty.endY!.toP() * field.bounds.height
                    if pos_right { yy = (100 - penalty.endY!).toP() * field.bounds.height }
                    
                    v.center = CGPoint(x: xx, y: yy)
                    
                    var pan = UIPanGestureRecognizer()
                    pan.addTarget(self, action: "blankPenaltyDragged:")
                    
                    v.addGestureRecognizer(pan)
                    
                    field.addSubview(v)
                    
                default:
                    
                    var v = PenaltyMKR(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                    v.tracker = self
                    v.index = i
                    v.dir = dir
                    v.setMKR(_x)
                    
                    field.addSubview(v)
                    
                }
                
            }
            
        }
        
    }
    // ========================================================
    // ========================================================
    
}