//
//  DownFilter.swift
//  stats-football
//
//  Created by grobinson on 9/10/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

extension Filters {
    
    static func score(s: Sequence) -> [Scores] {
        
        if s.replay { return [.None,.None] }
        
        var score = 0
        
        var pos_right = s.team.object.isEqual(s.game.home.object)
        
        let pos_right_original = s.team.object.isEqual(s.game.home.object)
        
        // IF KICK WITH NO RETURN
        // =======================================================
        // =======================================================
        if s.plays.count == 1 && (s.plays.first?.key == .Kick || s.plays.first?.key == .Punt) {
            
            return [.None,.None]
            
        }
        // =======================================================
        // =======================================================
        
        
        // LOOP THROUGH PLAYS
        // =======================================================
        // =======================================================
        // #######################################################
        var lastPossessionOutsideEndzone: Bool?
        var lastSpot: Yardline?
        var possessionChanged: Bool = false
        var fgm: Bool = false
        var fga: Bool = false
        var recovery: Bool = false
        // #######################################################
        for (i,play) in enumerate(s.plays) {
            
            if play.key == .FGM { fgm = true }
            if play.key == .FGA { fga = true }
            if play.key == .Recovery { recovery = true }
            
            // CHECK FOR CHANGE IN POSSESSION
            // ++++++++++++++++++++++++++++++++
            switch play.key as Key {
            case .Punt,.Kick,.Interception,.Recovery: pos_right = !pos_right
            case .Fumble: if let team = play.team { pos_right = team.object.isEqual(s.game.home.object) }
            default: ()
            }
            // ++++++++++++++++++++++++++++++++
            
            // LAST POSSESSION OUTSIDE ENDZONE
            // ++++++++++++++++++++++++++++++++
            if play.endX?.spot > 0 && play.endX?.spot < 100 {
                
                lastPossessionOutsideEndzone = pos_right
                
            }
            // ++++++++++++++++++++++++++++++++
            
            if let x = play.endX {
                
                if play.key != .Incomplete { lastSpot = x }
            
            }
            
            if pos_right != pos_right_original { possessionChanged = true }
            
        }
        // =======================================================
        // =======================================================
        
        
        // PENALTIES
        // =======================================================
        // =======================================================
        for penalty in reverse(s.penalties) {
            
            if let x = penalty.endX {
                
                lastSpot = x
                
                break
                
            }
            
        }
        // =======================================================
        // =======================================================
        
        
        // CHECK IF BALL ENDED IN ENDZONE
        // =======================================================
        // =======================================================
        var td = false
        var safety = false
        var extraPoint = false
        var conversion = false
        
        if let x = lastSpot {
            
            // RETURN TEAM ENDZONE
            // ++++++++++++++++++++++++++++++++
            if x.spot >= 100 {
                
                // IF KICKING TEAM HAS BALL
                // ------------------------------------
                if pos_right_original == pos_right {
                    
                    JP("SCORE TOUCHDOWN A")
                    
                    var z: Scores = .Touchdown
                    if s.key == Playtype.PAT {
                        
                        z = .Conversion
                        
                    }
                    
                    if pos_right {
                        return [.None,z]
                    } else {
                        return [z,.None]
                    }
                    
                } else {
                    
                    // CHECK IF SAFETY OR TOUCHBACK
                    // ====================================
                    if let l = lastPossessionOutsideEndzone {
                        
                        if l == pos_right {
                            
                            JP("SCORE SAFETY A")
                            
                            if pos_right {
                                return [.Safety,.None]
                            } else {
                                return [.None,.Safety]
                            }
                            
                        } else {
                            
                            JP("SCORE TOUCHBACK A")
                            
                        }
                        
                    } else {
                        
                        JP("SCORE TOUCHBACK B")
                        
                    }
                    // ====================================
                    
                }
                // ------------------------------------
                
            }
            // ++++++++++++++++++++++++++++++++
            
            
            // RETURN TEAM ENDZONE
            // ++++++++++++++++++++++++++++++++
            if x.spot <= 0 {
                
                // IF KICKING TEAM HAS BALL
                // ------------------------------------
                if pos_right_original != pos_right {
                    
                    JP("SCORE TOUCHDOWN B")
                    
                    var z: Scores = .Touchdown
                    if s.key == .PAT {
                        
                        z = .Conversion
                        
                    }
                    
                    if pos_right {
                        return [.None,z]
                    } else {
                        return [z,.None]
                    }
                    
                } else {
                    
                    // CHECK IF SAFETY OR TOUCHBACK
                    // ====================================
                    if let l = lastPossessionOutsideEndzone {
                        
                        if l == pos_right {
                            
                            JP("SCORE SAFETY B")
                            
                            if pos_right {
                                return [.Safety,.None]
                            } else {
                                return [.None,.Safety]
                            }
                            
                        } else {
                            
                            JP("SCORE TOUCHBACK A")
                            
                        }
                        
                    } else {
                        
                        JP("SCORE TOUCHBACK B")
                        
                    }
                    // ====================================
                    
                }
                // ------------------------------------
                
            }
            // ++++++++++++++++++++++++++++++++
            
        }
        // =======================================================
        // =======================================================
        
        if fgm {
            
            var z: Scores = .FieldGoal
            if s.key == .PAT {
                
                z = .ExtraPoint
                
            }
            
            if pos_right {
                return [.None,z]
            } else {
                return [z,.None]
            }
            
        }
        
        return [.None,.None]
        
    }
    
}