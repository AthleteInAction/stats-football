//
//  kickoffFilter.swift
//  stats-football
//
//  Created by grobinson on 9/3/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

class KickFilter {
    
    static func run(tracker: TrackerCTRL,original: Sequence) -> Sequence {
        
        var s = Sequence()
        
        var pos_right = tracker.posRight(original)
        
        let pos_right_original = tracker.posRight(original)
        
        s.team = original.team
        s.startX = original.startX
        s.startY = 50
        s.qtr = original.qtr
        s.key = original.key
        
        // REPLAY DOWN
        // =======================================================
        // =======================================================
        if original.replay || original.plays.count == 0 {
            
            s.startX = original.startX
            s.key = original.key
            s.down = original.down
            s.fd = original.fd
            s.startY = original.startY
            
            for penalty in reverse(original.penalties) {
                
                if let x = penalty.endX {
                    
                    s.startX = x
                    
                    println("A")
                    return s
                    
                }
                
            }
            
            println("B")
            return s
            
        }
        // =======================================================
        // =======================================================
        
        
        // IF KICK WITH NO RETURN
        // =======================================================
        // =======================================================
        if original.plays.count == 1 && original.plays.first?.key == "kick" {
            
            if let p = original.plays.first {
                
                if (p.endX > 0 && p.endX <= 50) || (p.endX < 0 && p.endX > -50) {
                    
                    if tracker.game.home.object!.isEqual(original.team.object!) {
                        s.team = tracker.game.away
                    } else {
                        s.team = tracker.game.home
                    }
                    s.key = "down"
                    s.down = 1
                    s.startX = p.endX!.flipSpot()
                    s.fd = s.startX.plus(10)
                    
                    println("C")
                    return s
                    
                }
                
            }
            
        }
        // =======================================================
        // =======================================================
        
        
        // LOOP THROUGH PLAYS
        // =======================================================
        // =======================================================
        // #######################################################
        var lastPossessionOutsideEndzone: Bool?
        var lastSpot: Play?
        // #######################################################
        for (i,play) in enumerate(original.plays) {
            
            // CHECK FOR CHANGE IN POSSESSION
            // ++++++++++++++++++++++++++++++++
            switch play.key {
            case "kick":
                
                pos_right = !pos_right
                
            case "fumble":
                
                if let player = play.player_b {
                    
                    pos_right = tracker.posRightPlay(play)
                    
                }
                
            case "interception","recovery":
                
                pos_right = !pos_right
                
            default:
                
                ()
                
            }
            // ++++++++++++++++++++++++++++++++
            
            // LAST POSSESSION OUTSIDE ENDZONE
            // ++++++++++++++++++++++++++++++++
            if (play.endX >= 1 && play.endX <= 50) || (play.endX >= -49 && play.endX <= -1) {
                
                lastPossessionOutsideEndzone = pos_right
                
            }
            // ++++++++++++++++++++++++++++++++
            
            if let x = play.endX { lastSpot = play }
            
        }
        // =======================================================
        // =======================================================
        
        // PENALTIES
        // =======================================================
        // =======================================================
        for penalty in reverse(original.penalties) {
            
            if let x = penalty.endX {
                
                lastSpot = Play(s: s)
                lastSpot?.endX = x
                
                break
                
            }
            
        }
        // =======================================================
        // =======================================================
        
        s.key = "down"
        s.down = 1
        if pos_right_original == pos_right {
            if tracker.game.home.object!.isEqual(original.team.object!) {
                s.team = tracker.game.home
            } else {
                s.team = tracker.game.away
            }
            s.startX = lastSpot!.endX
        } else {
            if tracker.game.home.object!.isEqual(original.team.object!) {
                s.team = tracker.game.away
            } else {
                s.team = tracker.game.home
            }
            s.startX = lastSpot!.endX?.flipSpot()
        }
        s.fd = s.startX.plus(10)
        
        
        // CHECK IF BALL ENDED IN ENDZONE
        // =======================================================
        // =======================================================
        if let play = lastSpot {
            
            // RETURN TEAM ENDZONE
            // ++++++++++++++++++++++++++++++++
            if play.endX! >= 100 {
                
                // IF KICKING TEAM HAS BALL
                // ------------------------------------
                if pos_right_original == pos_right {
                    
                    println("TOUCHDOWN")
                    s.team = original.team
                    s.key = "pat"
                    s.startX = 3
                    
                } else {
                    
                    // CHECK IF SAFETY OR TOUCHBACK
                    // ====================================
                    if let l = lastPossessionOutsideEndzone {
                        
                        if l == pos_right {
                            
                            println("SAFETY")
                            if tracker.game.home.object!.isEqual(original.team.object!) {
                                s.team = tracker.game.away
                            } else {
                                s.team = tracker.game.home
                            }
                            s.key = "freekick"
                            s.startX = 3
                            
                        } else {
                            
                            println("TOUCHBACK A")
                            if tracker.game.home.object!.isEqual(original.team.object!) {
                                s.team = tracker.game.away
                            } else {
                                s.team = tracker.game.home
                            }
                            s.key = "down"
                            s.startX = -20
                            s.fd = -30
                            
                        }
                        
                    } else {
                        
                        println("TOUCHBACK B")
                        if tracker.game.home.object!.isEqual(original.team.object!) {
                            s.team = tracker.game.away
                        } else {
                            s.team = tracker.game.home
                        }
                        s.key = "down"
                        s.startX = -20
                        s.fd = -30
                        
                    }
                    // ====================================
                    
                }
                // ------------------------------------
                
            }
            // ++++++++++++++++++++++++++++++++
            
            
            // RETURN TEAM ENDZONE
            // ++++++++++++++++++++++++++++++++
            if play.endX! <= -100 {
                
                // IF KICKING TEAM HAS BALL
                // ------------------------------------
                if pos_right_original != pos_right {
                    
                    println("TOUCHDOWN")
                    s.team = original.team
                    s.key = "pat"
                    s.startX = 3
                    
                } else {
                    
                    // CHECK IF SAFETY OR TOUCHBACK
                    // ====================================
                    if let l = lastPossessionOutsideEndzone {
                        
                        if l == pos_right {
                            
                            println("SAFETY")
                            if tracker.game.home.object!.isEqual(original.team.object!) {
                                s.team = tracker.game.away
                            } else {
                                s.team = tracker.game.home
                            }
                            s.key = "freekick"
                            s.startX = 3
                            
                        } else {
                            
                            println("TOUCHBACK A")
                            if tracker.game.home.object!.isEqual(original.team.object!) {
                                s.team = tracker.game.away
                            } else {
                                s.team = tracker.game.home
                            }
                            s.key = "down"
                            s.startX = -20
                            s.fd = -30
                            
                        }
                        
                    } else {
                        
                        println("TOUCHBACK B")
                        if tracker.game.home.object!.isEqual(original.team.object!) {
                            s.team = tracker.game.away
                        } else {
                            s.team = tracker.game.home
                        }
                        s.key = "down"
                        s.startX = -20
                        s.fd = -30
                        
                    }
                    // ====================================
                    
                }
                // ------------------------------------
                
            }
            // ++++++++++++++++++++++++++++++++
            
        }
        // =======================================================
        // =======================================================
        
        println("D")
        return s
        
    }
    
}

extension Int {
    
    func plus(inc: Int) -> Int {
        
        var full = self
        
        if self >= 1 && self <= 50 {
            
            full = 100 - self
            
        }
        
        if self <= -1 && self >= -49 {
            
            full = self * -1
            
        }
        
        full += inc
        
        if full >= 100 {
            
            full = 100
            
        }
        
        switch full {
        case 51...99:
            
            full = 100 - full
            break
            
        case 1...49:
            
            full = full * -1
            break
            
        case 0:
            
            full = 100
            break
            
        default:
            
            break
            
        }
        
        return full
        
    }
    
}