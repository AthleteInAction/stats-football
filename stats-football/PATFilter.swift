//
//  PATFilter.swift
//  stats-football
//
//  Created by grobinson on 9/10/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

class PATFilter {
    
    static func run(tracker: TrackerCTRL,original: Sequence) -> Sequence {
        
        var s = Sequence()
        s.game_id = tracker.game.id
        
        var pos_right: Bool = (original.pos_id == tracker.game.home.id && tracker.rightHome) || (original.pos_id == tracker.game.away.id && !tracker.rightHome)
        
        let pos_right_original: Bool = (original.pos_id == tracker.game.home.id && tracker.rightHome) || (original.pos_id == tracker.game.away.id && !tracker.rightHome)
        
        s.pos_id = original.pos_id
        s.startX = original.startX
        s.startY = 50
        s.qtr = original.qtr
        
        // REPLAY DOWN
        // =======================================================
        // =======================================================
        if original.replay || original.plays.count == 0 {
            
            s.key = original.key
            
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
        
        s.key = "kickoff"
        s.startX = -40
        
        return s
        
    }
    
}
