//
//  GameHelpers.swift
//  stats-football
//
//  Created by grobinson on 9/29/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

extension Game {
    
    // Score
    // ============================================================
    // ============================================================
    func getScore(){
        
        var sequenceObjects = object.sequences.allObjects as! [SequenceObject]
        
        var _sequences: [Sequence] = sequenceObjects.map { o in
            
            let sequence = Sequence(sequence: o)
            
            return sequence
            
        }
        
        _sequences.sort({ $0.created_at.compare($1.created_at) == NSComparisonResult.OrderedDescending })
        
        var awayScore = 0
        var homeScore = 0
        
        for _sequence in _sequences {
            
            _sequence.getPlays()
            _sequence.getPenalties()
            
            let score = Filters.score(_sequence)
            
            awayScore += score[0].value
            homeScore += score[1].value
            
        }
        
        away.score = awayScore
        home.score = homeScore
        
    }
    // ============================================================
    // ============================================================
    
    
    // Passing 
    
}