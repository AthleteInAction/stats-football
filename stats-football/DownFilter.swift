//
//  DownFilter.swift
//  stats-football
//
//  Created by grobinson on 9/10/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

class DownFilter {
    
    static func run(tracker: TrackerCTRL,original: Sequence) -> Sequence {
        
        var s = Sequence()
        
        var pos_right = tracker.posRight(original)
        
        let pos_right_original = tracker.posRight(original)
        
        s.team = original.team
        s.startX = original.startX
        s.startY = 50
        s.qtr = original.qtr
        s.down = original.down
        s.fd = original.fd
        
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
                    
                    return s
                    
                }
                
            }
            
            return s
            
        }
        // =======================================================
        // =======================================================
        
        
        // IF PUNT WITH NO RETURN
        // =======================================================
        // =======================================================
        if original.plays.count == 1 && original.plays.first?.key == "punt" {
            
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
        var possessionChanged: Bool = false
        var fgm: Bool = false
        var fga: Bool = false
        var recovery: Bool = false
        // #######################################################
        for (i,play) in enumerate(original.plays) {
            
            if play.key == "field goal made" { fgm = true }
            if play.key == "field goal attempted" { fga = true }
            if play.key == "recovery" { recovery = true }
            
            // CHECK FOR CHANGE IN POSSESSION
            // ++++++++++++++++++++++++++++++++
            switch play.key {
            case "punt":
                
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
            
            if pos_right != pos_right_original { possessionChanged = true }
            
        }
        // =======================================================
        // =======================================================
        
        
        // PENALTIES
        // =======================================================
        // =======================================================
        for penalty in reverse(original.penalties) {
            
            if let x = penalty.endX {
                
                lastSpot = Play()
                lastSpot?.endX = x
                
                break
                
            }
            
        }
        // =======================================================
        // =======================================================
        
        
        if fgm {
            
            s.key = "kickoff"
            s.startX = -40
            s.fd = nil
            s.team = original.team
            
            return s
            
        }
        
        if fga && !possessionChanged && !recovery {
            
            s.key = "down"
            if let spot = lastSpot {
                
                s.startX = lastSpot?.endX?.flipSpot()
                
            }
            s.down = 1
            s.fd = s.startX.plus(10)
            
            if original.team.object!.isEqual(tracker.game.home.object!) {
                s.team = tracker.game.away
            } else {
                s.team = tracker.game.home
            }
            
            return s
            
        }
        
        
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
                    s.fd = nil
                    
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
                
                return s
                
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
                    s.fd = nil
                    
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
                
                return s
                
            }
            // ++++++++++++++++++++++++++++++++
            
        }
        // =======================================================
        // =======================================================
        
        
        // NORMAL
        // =======================================================
        // =======================================================
        s.key = "down"
        if let play = lastSpot { s.startX = play.endX }
        // Was there a possession change
        if possessionChanged {
            
            println("POSSESSION CHANGED")
            
            s.down = 1
            
            if pos_right == pos_right_original {
                
                s.fd = s.startX.plus(10)
                
            } else {
            
                s.startX = s.startX.flipSpot()
                s.fd = s.startX.plus(10)
                if tracker.game.home.object!.isEqual(original.team.object!) {
                    s.team = tracker.game.away
                } else {
                    s.team = tracker.game.home
                }
                
            }
            
        } else {
            
            if s.startX.isFirstDown(original.fd!) {
                
                s.down = 1
                s.fd = s.startX.plus(10)
                
            } else {
                
                println("INCREMENT DOWN")
                
                s.down! += 1
                
            }
            
            if s.down > 4 {
                
                println("TURNOVER ON DOWNS")
                
                s.down = 1
                
                if tracker.game.home.object!.isEqual(original.team.object!) {
                    s.team = tracker.game.away
                } else {
                    s.team = tracker.game.home
                }
                
                s.startX = s.startX.flipSpot()
                s.fd = s.startX.plus(10)
                
            }
            
        }
        // =======================================================
        // =======================================================
        
        return s
        
    }
    
}

extension Int {
    
    func isFirstDown(fd: Int) -> Bool {
        
        let f = fd.yardToFull(false)
        let l = self.yardToFull(false)
        
        return (l >= f)
    
    }
    
}