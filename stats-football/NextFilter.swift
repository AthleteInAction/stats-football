//
//  KickFilter.swift
//  stats-football
//
//  Created by grobinson on 9/28/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class NextFilter {
    
    static func run(sequence _sequence: Sequence) -> Sequence {
        
        let S = Sequence(game: _sequence.game)
        
        S.qtr = _sequence.qtr
        
        let pos_original = true
        
        var pos = true
        
        // LOOP THROUGH PENALTIES
        // ==========================================
        // ==========================================
        var lastSpot: Yardline?
        var hasPenaltySpot = false
        _sequence.getPenalties()
        for penalty in reverse(_sequence.penalties) {
            
            if let spot = penalty.endX {
                
                lastSpot = spot
                
                hasPenaltySpot = true
                
                break
                
            }
            
        }
        // ==========================================
        // ==========================================
        
        
        // REPLAY DOWN
        // ==========================================
        // ==========================================
        if _sequence.replay || _sequence.plays.count == 0 {
            
            S.team = _sequence.team
            S.qtr = _sequence.qtr
            S.key = _sequence.key
            S.startX = _sequence.startX
            S.down = _sequence.down
            S.fd = _sequence.fd
            if let x = lastSpot { S.startX = x }
            
            return S
            
        }
        // ==========================================
        // ==========================================
        
        
        // KICK WITH NO RETURN
        // ==========================================
        // ==========================================
        if _sequence.plays.count == 1 && (_sequence.plays.first?.key == Key.Kick || _sequence.plays.first?.key == Key.Punt) {
            
            if let play = _sequence.plays.first {
                
                S.team = _sequence.game.oppositeTeam(team: _sequence.team)
                S.key = .Down
                S.down = 1
                
                if play.endX!.spot < 100 {
                    
                    S.startX = play.endX!.opposite()
                    
                } else {
                    
                    // TOUCHBACK
                    S.startX = Yardline(spot: 20)
                    
                }
                
                S.fd = S.startX.increment(10)
                
                return S
                
            }
            
        }
        // ==========================================
        // ==========================================
        
        
        // LOOP THROUGH PLAYS
        // ==========================================
        // ==========================================
        var lastPossessionOutsideEndzone: Bool?
        var possessionChanged = false
        var recovery = false
        var fgm = false
        var fga = false
        for play in _sequence.plays {
            
            switch play.key as Key {
            case .Kick,.Punt,.Interception,.Recovery: pos = !pos
            case .Fumble: if let team = play.team { pos = team.object.isEqual(_sequence.team.object) }
            case .FGA: fga = true
            case .FGM: fgm = true
            case .Recovery: recovery = true
            default: ()
            }
            
            // LAST POSSESSION OUTSIDE ENDZONE
            // ++++++++++++++++++++++++++++++++
            if let x = play.endX {
                
                if x.spot > 0 &&  x.spot < 100 {
                    
                    lastPossessionOutsideEndzone = pos
                    
                }
                
                if !hasPenaltySpot {
                    
                    if play.key != .Incomplete { lastSpot = x }
                
                }
                
            }
            // ++++++++++++++++++++++++++++++++
            
            if pos != pos_original { possessionChanged = true }
            
        }
        // ==========================================
        // ==========================================
        
        
        // PAT
        // ==========================================
        // ==========================================
        if _sequence.key == Playtype.PAT {
            
            S.qtr = _sequence.qtr
            S.team = _sequence.team
            S.key = .Kickoff
            S.startX = Yardline(spot: 40)
            
            return S
            
        }
        // ==========================================
        // ==========================================
        
        
        // FIELD GOALS
        // ==========================================
        // ==========================================
        if fgm {
            
            S.qtr = _sequence.qtr
            S.startX = Yardline(spot: 40)
            S.team = _sequence.team
            S.key = .Kickoff
            
            return S
            
        }
        
        if fga && !possessionChanged && !recovery {
            
            S.qtr = _sequence.qtr
            S.team = _sequence.game.oppositeTeam(team: _sequence.team)
            S.key = .Down
            S.startX = lastSpot!.opposite()
            S.down = 1
            S.fd = S.startX.increment(10)
            
            return S
            
        }
        // ==========================================
        // ==========================================
        
        
        // CHECK IF IN ENDZONE
        // ==========================================
        // ==========================================
        if let x = lastSpot {
            
            // RETURN TEAM ENDZONE
            if x.spot >= 100 {
                
                // IF KICKING TEAM HAS BALL
                if pos_original == pos {
                    
                    JP("TOUCHDOWN A")
                    
                    S.team = _sequence.team
                    S.qtr = _sequence.qtr
                    S.key = .PAT
                    S.startX = Yardline(spot: 97)
                    
                    return S
                    
                } else {
                    
                    // SAFETY OR TOUCHBACK
                    if let l = lastPossessionOutsideEndzone {
                        
                        if l == pos {
                            
                            JP("SAFETY A")
                            
                            S.team = _sequence.game.oppositeTeam(team: _sequence.team)
                            S.qtr = _sequence.qtr
                            S.key = .Freekick
                            S.startX = Yardline(spot: 40)
                            
                            return S
                            
                        }
                        
                    }
                    
                    JP("TOUCHBACK A")
                    
                    S.team = _sequence.game.oppositeTeam(team: _sequence.team)
                    S.qtr = _sequence.qtr
                    S.key = .Down
                    S.down = 1
                    S.startX = Yardline(spot: 20)
                    S.fd = S.startX.increment(10)
                    
                    return S
                    
                }
                
            }
            
            // KICKING TEAM ENDZONE
            if x.spot <= 0 {
                
                // IF RETURN TEAM HAS BALL
                if pos_original != pos {
                    
                    JP("TOUCHDOWN B")
                    
                    S.team = _sequence.game.oppositeTeam(team: _sequence.team)
                    S.qtr = _sequence.qtr
                    S.key = .PAT
                    S.startX = Yardline(spot: 97)
                    
                    return S
                    
                } else {
                    
                    // SAFETY OR TOUCHBACK
                    if let l = lastPossessionOutsideEndzone {
                        
                        if l == pos {
                            
                            JP("SAFETY B")
                            
                            S.team = _sequence.team
                            S.qtr = _sequence.qtr
                            S.key = .Freekick
                            S.startX = Yardline(spot: 40)
                            
                            return S
                            
                        }
                        
                    }
                    
                    JP("TOUCHBACK B")
                    
                    S.team = _sequence.team
                    S.qtr = _sequence.qtr
                    S.key = .Down
                    S.down = 1
                    S.startX = Yardline(spot: 20)
                    S.fd = S.startX.increment(10)
                    
                    return S
                    
                }
                
            }
            
        }
        // ==========================================
        // ==========================================
        
        
        
        // PLAYTYPES
        // ==========================================
        // ==========================================
        switch _sequence.key as Playtype {
        case .Kickoff,.Freekick:
            
            S.qtr = 1
            if pos == pos_original {
                
                S.team = _sequence.team
                S.startX = lastSpot!
                
            } else {
                
                S.team = _sequence.game.oppositeTeam(team: _sequence.team)
                S.startX = lastSpot!.opposite()
                
            }
            S.key = .Down
            S.down = 1
            S.fd = S.startX.increment(10)
            
            return S
            
        default:
            
            S.qtr = _sequence.qtr
            S.key = .Down
            
            if possessionChanged {
                
                S.down = 1
                
                if pos == pos_original {
                    
                    S.team = _sequence.team
                    S.startX = lastSpot!
                    
                } else {
                    
                    S.team = _sequence.game.oppositeTeam(team: _sequence.team)
                    S.startX = lastSpot!.opposite()
                    
                }
                
                S.fd = S.startX.increment(10)
                
            } else {
                
                if let last_spot = lastSpot {
                    
                    S.startX = last_spot
                    
                } else {
                    
                    S.startX = _sequence.startX
                    
                }
                
                S.team = _sequence.team
                
                if lastSpot?.spot >= _sequence.fd?.spot {
                    
                    S.down = 1
                    S.fd = S.startX.increment(10)
                    
                } else {
                    
                    S.down = _sequence.down
                    S.fd = _sequence.fd
                    if let d = S.down { S.down = d + 1 }
                    
                }
                
                if S.down > 4 {
                    
                    S.down = 1
                    S.team = _sequence.game.oppositeTeam(team: _sequence.team)
                    S.startX = S.startX.opposite()
                    S.fd = S.startX.increment(10)
                    
                }
                
            }
            
            return S
            
        }
        // ==========================================
        // ==========================================
        
    }
    
}