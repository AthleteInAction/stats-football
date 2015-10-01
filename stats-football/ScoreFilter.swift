//
//  DownFilter.swift
//  stats-football
//
//  Created by grobinson on 9/10/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

class ScoreFilter {
    
    static func run(s: Sequence) -> [Int] {
        
//        var score = 0
//        
//        var pos_right = s.team.object.isEqual(s.game.home.object)
//        
//        let pos_right_original = s.team.object.isEqual(s.game.home.object)
//        
//        s.getPlays()
//        s.getPenalties()
//        
//        // IF KICK WITH NO RETURN
//        // =======================================================
//        // =======================================================
//        if s.plays.count == 1 && (s.plays.first?.key == "kick" || s.plays.first?.key == "punt") {
//            
//            return [0,0]
//            
//        }
//        // =======================================================
//        // =======================================================
//        
//        
//        // LOOP THROUGH PLAYS
//        // =======================================================
//        // =======================================================
//        // #######################################################
//        var lastPossessionOutsideEndzone: Bool?
//        var lastSpot: Yardline?
//        var possessionChanged: Bool = false
//        var fgm: Bool = false
//        var fga: Bool = false
//        var recovery: Bool = false
//        // #######################################################
//        for (i,play) in enumerate(s.plays) {
//            
//            if play.key == "field goal made" { fgm = true }
//            if play.key == "field goal attempted" { fga = true }
//            if play.key == "recovery" { recovery = true }
//            
//            // CHECK FOR CHANGE IN POSSESSION
//            // ++++++++++++++++++++++++++++++++
//            switch play.key {
//            case "punt","kick":
//                
//                pos_right = !pos_right
//                
//            case "fumble":
//                
//                if let team = play.team { pos_right = team.object.isEqual(s.game.home.object) }
//                
//            case "interception","recovery":
//                
//                pos_right = !pos_right
//                
//            default:
//                
//                ()
//                
//            }
//            // ++++++++++++++++++++++++++++++++
//            
//            // LAST POSSESSION OUTSIDE ENDZONE
//            // ++++++++++++++++++++++++++++++++
////            if (play.endX >= 1 && play.endX <= 50) || (play.endX >= -49 && play.endX <= -1) {
////                
////                lastPossessionOutsideEndzone = pos_right
////                
////            }
////            // ++++++++++++++++++++++++++++++++
////            
////            if let x = play.endX { lastSpot = x }
//            
//            if pos_right != pos_right_original { possessionChanged = true }
//            
//        }
//        // =======================================================
//        // =======================================================
//        
//        
//        // PENALTIES
//        // =======================================================
//        // =======================================================
//        for penalty in reverse(s.penalties) {
//            
//            if let x = penalty.endX {
//                
//                lastSpot = x
//                
//                break
//                
//            }
//            
//        }
//        // =======================================================
//        // =======================================================
//        
//        
//        // CHECK IF BALL ENDED IN ENDZONE
//        // =======================================================
//        // =======================================================
//        var td = false
//        var safety = false
//        var extraPoint = false
//        var conversion = false
//        
//        if let x = lastSpot {
//            
//            // RETURN TEAM ENDZONE
//            // ++++++++++++++++++++++++++++++++
//            if x >= 100 {
//                
//                // IF KICKING TEAM HAS BALL
//                // ------------------------------------
//                if pos_right_original == pos_right {
//                    
//                    println("SCORE FILTER TOUCHDOWN A")
//                    
//                    if s.key == Playtype.PAT {
//                        
//                        score = 2
//                        
//                    } else {
//                        
//                        score = 6
//                        
//                    }
//                    
//                    if pos_right {
//                        return [0,score]
//                    } else {
//                        return [score,0]
//                    }
//                    
//                } else {
//                    
//                    // CHECK IF SAFETY OR TOUCHBACK
//                    // ====================================
//                    if let l = lastPossessionOutsideEndzone {
//                        
//                        if l == pos_right {
//                            
//                            println("SCORE FILTER SAFETY A")
//                            
//                            if pos_right {
//                                return [2,0]
//                            } else {
//                                return [0,2]
//                            }
//                            
//                        } else {
//                            
//                            println("SCORE FILTER TOUCHBACK A")
//                            
//                        }
//                        
//                    } else {
//                        
//                        println("SCORE FILTER TOUCHBACK B")
//                        
//                    }
//                    // ====================================
//                    
//                }
//                // ------------------------------------
//                
//            }
//            // ++++++++++++++++++++++++++++++++
//            
//            
//            // RETURN TEAM ENDZONE
//            // ++++++++++++++++++++++++++++++++
//            if x <= -100 {
//                
//                // IF KICKING TEAM HAS BALL
//                // ------------------------------------
//                if pos_right_original != pos_right {
//                    
//                    println("SCORE FILTER TOUCHDOWN B")
//                    
//                    if s.key == Playtype.PAT {
//                        
//                        score = 2
//                        
//                    } else {
//                        
//                        score = 6
//                        
//                    }
//                    
//                    if pos_right {
//                        return [0,score]
//                    } else {
//                        return [score,0]
//                    }
//                    
//                } else {
//                    
//                    // CHECK IF SAFETY OR TOUCHBACK
//                    // ====================================
//                    if let l = lastPossessionOutsideEndzone {
//                        
//                        if l == pos_right {
//                            
//                            println("SCORE FILTER SAFETY B")
//                            
//                            if pos_right {
//                                return [2,0]
//                            } else {
//                                return [0,2]
//                            }
//                            
//                        } else {
//                            
//                            println("SCORE FILTER TOUCHBACK A")
//                            
//                        }
//                        
//                    } else {
//                        
//                        println("SCORE FILTER TOUCHBACK B")
//                        
//                    }
//                    // ====================================
//                    
//                }
//                // ------------------------------------
//                
//            }
//            // ++++++++++++++++++++++++++++++++
//            
//        }
//        // =======================================================
//        // =======================================================
//        
//        if fgm {
//            
//            if s.key == Playtype.PAT {
//                
//                score = 1
//                
//            } else {
//                
//                score = 3
//                
//            }
//            
//            if pos_right {
//                return [0,score]
//            } else {
//                return [score,0]
//            }
//            
//        }
        
        return [0,0]
        
    }
    
}