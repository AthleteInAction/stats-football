//
//  Stats.swift
//  stats-football
//
//  Created by grobinson on 9/21/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit
import CoreData

class Stats {
    
    static func compileAnalytics(game _game: [String:AnyObject],playtype: String?,downs: [Int]?,togo: Int?,threshold: Int?) -> [String:AnyObject] {
        println("++++++")
        println(playtype)
        println(downs)
        println("++++++")
        var data: [String:AnyObject] = [
            "run": 0,
            "run_pct": 50.0,
            "run_1": 0,
            "run_2": 0,
            "run_3": 0,
            "run_4": 0,
            "run_5": 0,
            "pass_1": 0,
            "pass_2": 0,
            "pass_3": 0,
            "pass_4": 0,
            "pass_5": 0
        ]
        
        var run = 0
        var runDir: [Int] = [0,0,0,0,0]
        var pass = 0
        var passDir: [Int] = [0,0,0,0,0]
        
        let plays = _game["plays"] as! [[String:AnyObject]]
        
        for play in plays {
            play
            var doit = true
            
            if let p = playtype { if p != play["playtype"] as! String { doit = false } }
            
            if let ds = downs {
                
                doit = false
                
                for down in ds {
                    
                    if play["down"] != nil {
                        
                        let n = play["down"] as! Int
                        
                        if n == down { doit = true }
                        
                    }
                    
                }
                
            }
            
            if let go = togo {
                
                if play["playtype"] != nil {
                    
                    if play["playtype"] as! String == "down" {
                        
                        let t = play["togo"] as! Int
                        
                        switch t {
                        case (go-threshold!) ... (go+threshold!):
                            ()
                        default:
                            doit = false
                        }
                        
                    }
                    
                }
                
            }
            
            if doit {
                
                switch play["key"] as! String {
                case "run":
                    
                    if play["endY"] != nil {
                        
                        let Y = play["endY"] as! Int
                        
                        switch Y {
                        case 15:
                            runDir[0]++
                        case 36:
                            runDir[1]++
                        case 50:
                            runDir[2]++
                        case 64:
                            runDir[3]++
                        case 85:
                            runDir[4]++
                        default:
                            ()
                        }
                        
                    }
                    
                    run++
                    
                case "pass":
                    
                    if play["endY"] != nil {
                        
                        let Y = play["endY"] as! Int
                        
                        let section = Int(ceil(CGFloat(Y)/20))
                        
                        passDir[section-1]++
                        
                    }
                    
                    pass++
                    
                default:
                    ()
                }
                
            }
            
        }
        
        for (i,val) in enumerate(runDir) {
            
            data["run_\(i+1)"] = val
            
        }
        for (i,val) in enumerate(passDir) {
            
            data["pass_\(i+1)"] = val
            
        }
        
        data["run"] = run
        data["pass"] = pass
        
        return data
        
    }
    
    static func compileScore(game _game: Game) -> [Int] {
        
        var homeScore = 0
        var awayScore = 0
        
        _game.getSequences()
        
        for sequence in _game.sequences {
            
            if !sequence.replay {
                
                let score = Filters.score(sequence)
                
                homeScore += score[1].value
                awayScore += score[0].value
                
            }
            
        }
        
        return [awayScore,homeScore]
        
    }
    
}
