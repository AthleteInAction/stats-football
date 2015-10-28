//
//  TrackerHelpers.swift
//  stats-football
//
//  Created by grobinson on 9/27/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit

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
        hideScoreboard()
        
    }
    func hideScoreboard(){
        
        panel.hidden = true
        
    }
    func enableScoreboard(){
        
        panel.hidden = false
        
    }
    func disableErase(){
        
        eraseBTN.alpha = 0.3
        eraseBTN.userInteractionEnabled = false
        
    }
    func enableErase(){
        
        eraseBTN.alpha = 1
        eraseBTN.userInteractionEnabled = true
        
    }
    // ===============================================================
    // ===============================================================
    
}
