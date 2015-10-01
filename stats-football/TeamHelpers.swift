//
//  TeamHelpers.swift
//  stats-football
//
//  Created by grobinson on 9/30/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit

extension Game {
    
    // PLAYER STATS
    // =================================================================
    // =================================================================
    func getPlayerStats(){
    
        let objects = object.sequences.allObjects as! [SequenceObject]
        
        var _sequences: [Sequence] = objects.map { o in
            
            let sequence = Sequence(sequence: o)
            
            return sequence
            
        }
        
        _sequences.sort({ $0.created_at.compare($1.created_at) == NSComparisonResult.OrderedDescending })
        
        var tmp: [Stat] = []
        
        for _sequence in _sequences {
            
            _sequence.getPlays()
            _sequence.getPenalties()
            
            tmp += Stats.player(sequence: _sequence)
            
        }
        
        playerStats = tmp
    
    }
    // =================================================================
    // =================================================================
    
    
    // STAT TOTALS
    // =================================================================
    // =================================================================
    func getTotals(){
        
        getPlayerStats()
        
        // HOME
        var _passingHome = [String:PassingTotal]()
        home.teamPassing = PassingTotal()
        
        var _receivingHome = [String:ReceivingTotal]()
        home.teamReceiving = ReceivingTotal()
        
        var _rushingHome = [String:RushingTotal]()
        home.teamRushing = RushingTotal()
        
        var _puntReturnsHome = [String:ReturnTotal]()
        home.teamPuntReturns = ReturnTotal()
        
        var _kickReturnsHome = [String:ReturnTotal]()
        home.teamKickReturns = ReturnTotal()
        
        // AWAY
        var _passingAway = [String:PassingTotal]()
        away.teamPassing = PassingTotal()
        
        var _receivingAway = [String:ReceivingTotal]()
        away.teamReceiving = ReceivingTotal()
        
        var _rushingAway = [String:RushingTotal]()
        away.teamRushing = RushingTotal()
        
        var _puntReturnsAway = [String:ReturnTotal]()
        away.teamPuntReturns = ReturnTotal()
        
        var _kickReturnsAway = [String:ReturnTotal]()
        away.teamKickReturns = ReturnTotal()
        
        for _stat in playerStats {
            
            switch _stat.key {
            case "completion","incompletion":
                
                if _stat.team.object.isEqual(home.object) {
                    
                    if _stat.playtype == "down" {
                        
                        if _passingHome[_stat.player.string()] == nil {
                            
                            _passingHome[_stat.player.string()] = PassingTotal(player: _stat.player)
                            
                        }
                        
                        _passingHome[_stat.player.string()]?.add(stat: _stat)
                        
                        home.teamPassing.add(stat: _stat)
                        
                    }
                    
                } else {
                    
                    if _stat.playtype == "down" {
                        
                        if _passingAway[_stat.player.string()] == nil {
                            
                            _passingAway[_stat.player.string()] = PassingTotal(player: _stat.player)
                            
                        }
                        
                        _passingAway[_stat.player.string()]?.add(stat: _stat)
                        
                        away.teamPassing.add(stat: _stat)
                        
                    }
                    
                }
                
            case "reception":
                
                if _stat.team.object.isEqual(home.object) {
                    
                    if _stat.playtype == "down" {
                        
                        if _receivingHome[_stat.player.string()] == nil {
                            
                            _receivingHome[_stat.player.string()] = ReceivingTotal(player: _stat.player)
                            
                        }
                        
                        _receivingHome[_stat.player.string()]?.add(stat: _stat)
                        
                        home.teamReceiving.add(stat: _stat)
                        
                    }
                    
                } else {
                    
                    if _stat.playtype == "down" {
                        
                        if _receivingAway[_stat.player.string()] == nil {
                            
                            _receivingAway[_stat.player.string()] = ReceivingTotal(player: _stat.player)
                            
                        }
                        
                        _receivingAway[_stat.player.string()]?.add(stat: _stat)
                        
                        away.teamReceiving.add(stat: _stat)
                        
                    }
                    
                }
                
            case "run":
                
                if _stat.team.object.isEqual(home.object) {
                    
                    if _stat.playtype == "down" {
                        
                        if _rushingHome[_stat.player.string()] == nil {
                            
                            _rushingHome[_stat.player.string()] = RushingTotal(player: _stat.player)
                            
                        }
                        
                        _rushingHome[_stat.player.string()]?.add(stat: _stat)
                        
                        home.teamRushing.add(stat: _stat)
                        
                    }
                    
                } else {
                    
                    if _stat.playtype == "down" {
                        
                        if _rushingAway[_stat.player.string()] == nil {
                            
                            _rushingAway[_stat.player.string()] = RushingTotal(player: _stat.player)
                            
                        }
                        
                        _rushingAway[_stat.player.string()]?.add(stat: _stat)
                        
                        away.teamRushing.add(stat: _stat)
                        
                    }
                    
                }
                
            case "punt_return":
                
                if _stat.team.object.isEqual(home.object) {
                    
                    if _stat.playtype == "down" {
                        
                        if _puntReturnsHome[_stat.player.string()] == nil {
                            
                            _puntReturnsHome[_stat.player.string()] = ReturnTotal(player: _stat.player)
                            
                        }
                        
                        _puntReturnsHome[_stat.player.string()]?.add(stat: _stat)
                        
                        home.teamPuntReturns.add(stat: _stat)
                        
                    }
                    
                } else {
                    
                    if _stat.playtype == "down" {
                        
                        if _puntReturnsAway[_stat.player.string()] == nil {
                            
                            _puntReturnsAway[_stat.player.string()] = ReturnTotal(player: _stat.player)
                            
                        }
                        
                        _puntReturnsAway[_stat.player.string()]?.add(stat: _stat)
                        
                        away.teamPuntReturns.add(stat: _stat)
                        
                    }
                    
                }
                
            case "kick_return":
                
                if _stat.team.object.isEqual(home.object) {
                    
                    if _stat.playtype == "kickoff" || _stat.playtype == "freekick" {
                        
                        if _kickReturnsHome[_stat.player.string()] == nil {
                            
                            _kickReturnsHome[_stat.player.string()] = ReturnTotal(player: _stat.player)
                            
                        }
                        
                        _kickReturnsHome[_stat.player.string()]?.add(stat: _stat)
                        
                        home.teamKickReturns.add(stat: _stat)
                        
                    }
                    
                } else {
                    
                    if _stat.playtype == "kickoff" || _stat.playtype == "freekick" {
                        
                        if _kickReturnsAway[_stat.player.string()] == nil {
                            
                            _kickReturnsAway[_stat.player.string()] = ReturnTotal(player: _stat.player)
                            
                        }
                        
                        _kickReturnsAway[_stat.player.string()]?.add(stat: _stat)
                        
                        away.teamKickReturns.add(stat: _stat)
                        
                    }
                    
                }
                
            default:
                ()
            }
            
        }
        
        // PASSING
        // ------------------------------------------------
        var tmpp: [PassingTotal] = []
        for (key,val) in _passingHome { tmpp.append(val) }
        home.passing = tmpp
        home.passing.sort({ $0.att > $1.att })
        
        tmpp.removeAll(keepCapacity: true)
        for (key,val) in _passingAway { tmpp.append(val) }
        away.passing = tmpp
        away.passing.sort({ $0.att > $1.att })
        // ------------------------------------------------
        
        // RECEIVING
        // ------------------------------------------------
        var tmprec: [ReceivingTotal] = []
        for (key,val) in _receivingHome { tmprec.append(val) }
        home.receiving = tmprec
        home.receiving.sort({ $0.rec > $1.rec })
        
        tmprec.removeAll(keepCapacity: true)
        for (key,val) in _receivingAway { tmprec.append(val) }
        away.receiving = tmprec
        away.receiving.sort({ $0.rec > $1.rec })
        // ------------------------------------------------
        
        // RUSHING
        // ------------------------------------------------
        var tmpr: [RushingTotal] = []
        for (key,val) in _rushingHome { tmpr.append(val) }
        home.rushing = tmpr
        home.rushing.sort({ $0.att > $1.att })
        
        tmpr.removeAll(keepCapacity: true)
        for (key,val) in _rushingAway { tmpr.append(val) }
        away.rushing = tmpr
        away.rushing.sort({ $0.att > $1.att })
        // ------------------------------------------------
        
        // PUNT RETURNS
        // ------------------------------------------------
        var tmppunt: [ReturnTotal] = []
        for (key,val) in _puntReturnsHome { tmppunt.append(val) }
        home.puntReturns = tmppunt
        home.puntReturns.sort({ $0.att > $1.att })
        
        tmppunt.removeAll(keepCapacity: true)
        for (key,val) in _puntReturnsAway { tmppunt.append(val) }
        away.puntReturns = tmppunt
        away.puntReturns.sort({ $0.att > $1.att })
        // ------------------------------------------------
        
        // KICK RETURNS
        // ------------------------------------------------
        var tmpkick: [ReturnTotal] = []
        for (key,val) in _kickReturnsHome { tmpkick.append(val) }
        home.kickReturns = tmpkick
        home.kickReturns.sort({ $0.att > $1.att })
        
        tmpkick.removeAll(keepCapacity: true)
        for (key,val) in _kickReturnsAway { tmpkick.append(val) }
        away.kickReturns = tmpkick
        JP("AWAY KICK RETURNS: \(away.kickReturns.count)")
        away.kickReturns.sort({ $0.att > $1.att })
        // ------------------------------------------------
        
    }
    // =================================================================
    // =================================================================
    
}