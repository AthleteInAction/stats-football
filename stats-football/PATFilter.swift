////
////  PATFilter.swift
////  stats-football
////
////  Created by grobinson on 9/10/15.
////  Copyright (c) 2015 Wambl. All rights reserved.
////
//
//class PATFilter {
//    
//    static func run(tracker: Tracker,original: Sequence) -> Sequence {
//        
//        var s = Sequence()
//        
//        var pos_right = tracker.posRight(original)
//        
//        let pos_right_original = tracker.posRight(original)
//        
//        s.team = original.team
//        s.startX = original.startX
//        s.startY = 50
//        s.qtr = original.qtr
//        
//        // REPLAY DOWN
//        // =======================================================
//        // =======================================================
//        if original.replay || original.plays.count == 0 {
//            
//            s.key = original.key
//            
//            for penalty in reverse(original.penalties) {
//                
//                if let x = penalty.endX {
//                    
//                    s.startX = x
//                    
//                    return s
//                    
//                }
//                
//            }
//            
//            return s
//            
//        }
//        // =======================================================
//        // =======================================================
//        
//        s.key = "kickoff"
//        s.startX = -40
//        
//        return s
//        
//    }
//    
//}