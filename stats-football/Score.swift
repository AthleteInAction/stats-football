//
//  DownFilter.swift
//  stats-football
//
//  Created by grobinson on 9/10/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

extension Filters {
    
    static func score(s: Sequence) -> [Scores] {
        
        var score = 0
        
        var pos_right = s.team.object.isEqual(s.game.home.object)
        
        let pos_right_original = s.team.object.isEqual(s.game.home.object)
        
        s.getPlays()
        s.getPenalties()
        
        // IF KICK WITH NO RETURN
        // =======================================================
        // =======================================================
        if s.plays.count == 1 && (s.plays.first?.key == "kick" || s.plays.first?.key == "punt") {
            
            return [.None,.None]
            
        }
        // =======================================================
        // =======================================================
        
        
        // LOOP THROUGH PLAYS
        // =======================================================
        // =======================================================
        // #######################################################
        var lastPossessionOutsideEndzone: Bool?
        var lastSpot: Int?
        var possessionChanged: Bool = false
        var fgm: Bool = false
        var fga: Bool = false
        var recovery: Bool = false
        // #######################################################
        for (i,play) in enumerate(s.plays) {
            
            if play.key == "field goal made" { fgm = true }
            if play.key == "field goal attempted" { fga = true }
            if play.key == "recovery" { recovery = true }
            
            // CHECK FOR CHANGE IN POSSESSION
            // ++++++++++++++++++++++++++++++++
            switch play.key {
            case "punt","kick":
                
                pos_right = !pos_right
                
            case "fumble":
                
                if let team = play.team { pos_right = team.object.isEqual(s.game.home.object) }
                
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
            
            if let x = play.endX { lastSpot = x }
            
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
            if x >= 100 {
                
                // IF KICKING TEAM HAS BALL
                // ------------------------------------
                if pos_right_original == pos_right {
                    
                    println("SCORE TOUCHDOWN A")
                    
                    var z: Scores = .Touchdown
                    if s.key == "pat" {
                        
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
                            
                            println("SCORE SAFETY A")
                            
                            if pos_right {
                                return [.Safety,.None]
                            } else {
                                return [.None,.Safety]
                            }
                            
                        } else {
                            
                            println("SCORE TOUCHBACK A")
                            
                        }
                        
                    } else {
                        
                        println("SCORE TOUCHBACK B")
                        
                    }
                    // ====================================
                    
                }
                // ------------------------------------
                
            }
            // ++++++++++++++++++++++++++++++++
            
            
            // RETURN TEAM ENDZONE
            // ++++++++++++++++++++++++++++++++
            if x <= -100 {
                
                // IF KICKING TEAM HAS BALL
                // ------------------------------------
                if pos_right_original != pos_right {
                    
                    println("SCORE TOUCHDOWN B")
                    
                    var z: Scores = .Touchdown
                    if s.key == "pat" {
                        
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
                            
                            println("SCORE SAFETY B")
                            
                            if pos_right {
                                return [.Safety,.None]
                            } else {
                                return [.None,.Safety]
                            }
                            
                        } else {
                            
                            println("SCORE TOUCHBACK A")
                            
                        }
                        
                    } else {
                        
                        println("SCORE TOUCHBACK B")
                        
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
            if s.key == "pat" {
                
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

enum Scores {
    
    case Touchdown
    case Safety
    case FieldGoal
    case ExtraPoint
    case Conversion
    case None
    
    var string: String {
        
        switch self {
        case .Touchdown:
            return "touchdown"
        case .Safety:
            return "safety"
        case .FieldGoal:
            return "fieldgoal"
        case .ExtraPoint:
            return "extrapoint"
        case .Conversion:
            return "conversion"
        default:
            return ""
        }
        
    }
    
    var value: Int {
        
        switch self {
        case .Touchdown:
            return 6
        case .Safety:
            return 2
        case .FieldGoal:
            return 3
        case .ExtraPoint:
            return 1
        case .Conversion:
            return 2
        default:
            return 0
        }
        
    }
    
}