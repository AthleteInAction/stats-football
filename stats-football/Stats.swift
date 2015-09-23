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
    
    static func compileAnalytics(game _game: [[String:AnyObject]]) -> [String:AnyObject] {
        
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
        
        for play in _game {
            
            println(play)
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
    
}
