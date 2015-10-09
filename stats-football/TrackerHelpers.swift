//
//  TrackerHelpers.swift
//  stats-football
//
//  Created by grobinson on 9/27/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

extension Tracker {
    
    func posRight(s: Sequence) -> Bool {
        
        return (s.team.object!.isEqual(game.home.object!) && game.right_home) || (s.team.object!.isEqual(game.away.object!) && !game.right_home)
        
    }
    
    func posRight2(team: TeamObject) -> Bool {
        
        return (team.isEqual(game.home.object!) && game.right_home) || (team.isEqual(game.away.object!) && !game.right_home)
        
    }
    
    func opTeam(team: Team) -> Team {
        
        if team.object.isEqual(game.home.object) {
            
            return game.away
            
        } else {
            
            return game.home
            
        }
        
    }
    
    // SWITCHES
    // ===============================================================
    // ===============================================================
    func disablePlayLog(){
        
        sequenceTBL.alpha = 0.3
        sequenceTBL.userInteractionEnabled = false
        
    }
    func enablePlayLog(){
        
        sequenceTBL.alpha = 1
        sequenceTBL.userInteractionEnabled = true
        
    }
    func disableField(){
        
        field.alpha = 0.3
        fimg.alpha = 0.3
        field.userInteractionEnabled = false
        
    }
    func enableField(){
        
        field.alpha = 1
        fimg.alpha = 1
        field.userInteractionEnabled = true
        
    }
    func disableTables(){
        
        penaltyTBL.alpha = 0.3
        sequenceTBL.alpha = 0.3
        penaltyTBL.userInteractionEnabled = false
        sequenceTBL.userInteractionEnabled = false
        
    }
    func enableTables(){
        
        penaltyTBL.alpha = 1
        sequenceTBL.alpha = 1
        penaltyTBL.userInteractionEnabled = true
        sequenceTBL.userInteractionEnabled = true
        
    }
    func disablePenaltyButton(){
        
        rightPTY.alpha = 0.3
        rightPTY.userInteractionEnabled = false
        leftPTY.alpha = 0.3
        leftPTY.userInteractionEnabled = false
        
    }
    func enablePenaltyButton(){
        
        rightPTY.alpha = 1
        rightPTY.userInteractionEnabled = true
        leftPTY.alpha = 1
        leftPTY.userInteractionEnabled = true
        
    }
    func spot(){
        
        enableField()
        disableTables()
        hideScoreboard()
        
    }
    func hideScoreboard(){
        
        scoreboard.hidden = true
        
    }
    func enableScoreboard(){
        
        scoreboard.hidden = false
        
    }
    // ===============================================================
    // ===============================================================
    
}
