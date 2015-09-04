//
//  kickoffFilter.swift
//  stats-football
//
//  Created by grobinson on 9/3/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

class KickoffFilter {
    
    static func run(original: Sequence) -> Sequence {
        
        var s = Sequence()
        
        s.home = original.home
        s.away = original.away
        s.pos_id = original.pos_id
        s.pos_right = original.pos_right
        s.qtr = original.qtr
        s.startX = original.startX
        s.key = original.key
        
        // REPLAY DOWN
        // =======================================================
        // =======================================================
        if original.replay {
            
            for play in original.plays {
                
                if let x = play.endX {
                    
                    s.startX = x
                    
                    break
                    
                }
                
            }
            
            s.key = original.key
            s.down = original.down
            s.fd = original.fd
            s.startX = original.startX
            s.startY = original.startY
            
            return s
            
        }
        // =======================================================
        // =======================================================
        
        s.pos_right = !s.pos_right
        
        
        // LOOP THROUGH PLAYS
        // =======================================================
        // =======================================================
        var prevPlay: Play?
        var lastPlayWithSpot: Play?
        var lastPlayWithoutPenalty: Play?
        for (i,play) in enumerate(original.plays) {
            
            // GET LAST SPOT
            // ++++++++++++++++++++++++++++++++
            if let x = play.endX {
                
                if lastPlayWithSpot == nil {
                    
                    s.startX = x
                    lastPlayWithSpot = play
                    
                }
                
                if lastPlayWithoutPenalty == nil {
                    
                    if play.key != "penalty" { lastPlayWithoutPenalty = play }
                    
                }
                
            }
            // ++++++++++++++++++++++++++++++++
            
            // CHECK FOR CHANGE IN POSSESSION
            // ++++++++++++++++++++++++++++++++
            switch play.key {
            case "fumble":
                
                if play.player_b != nil && play.pos_id == original.pos_id { s.pos_right = !s.pos_right }
                
                
            case "interception","recovery":
                
                s.pos_right = !s.pos_right
                
            default:
                
                ()
                
            }
            // ++++++++++++++++++++++++++++++++
            
            prevPlay = play
            
        }
        // =======================================================
        // =======================================================
        
        if s.pos_right != original.pos_right {
            
            s.startX = s.startX.flipSpot()
            
            if original.pos_id == original.home {
                
                s.pos_id = original.away
                
            } else {
                
                s.pos_id = original.away
                
            }
            
        }
        
        s.key = "down"
        s.down = 1
        
        let y = s.startX.yardToFull(s.pos_right)
        
        if s.pos_right == true {
            
            var n = (y - 10)
            
            if n <= 0 { n = 0 }
            
            s.fd = n.fullToYard(true)
            
        } else {
            
            var n = (y + 10)
            
            if n >= 100 { n = 100 }
            
            s.fd = n.fullToYard(false)
            
        }
        
        // SCORE
        // =======================================================
        // =======================================================
        if s.pos_right != original.pos_right {
            
            if let l = lastPlayWithoutPenalty {
                
                // TOUCHDOWN FOR RETURN TEAM
                if l.endX <= -100 {
                    
                    
                    
                }
                
            }
            
        }
        // =======================================================
        // =======================================================
        
        return s
        
    }
    
}