//
//  DataDisplayFunctions.swift
//  stats-football
//
//  Created by grobinson on 10/2/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit

extension DataDisplay {
    
    func gameData(data _data: [String : AnyObject]) -> TeamData {
        
        var _final = TeamData()
        
        var _plays = _data["plays"] as! [[String:AnyObject]]
        
        for play in _plays {
            
            switch play["playtype"] as! String {
            case "down":
                
                switch play["key"] as! String {
                case "run":
                    
                    _final.run++
                    _final.runSection(play["endY"] as! Int)
                    
                case "pass":
                    
                    _final.pass++
                    _final.passSection(play["endY"] as! Int)
                    
                default: ()
                }
                
            default: ()
            }
            
        }
        
        return _final
        
    }
    
}

class TeamData {
    
    private var runSections: [Int] = settings.runSections
    private var passSections: [Int] = settings.passSections
    
    var run: Int = 0
    var runs: [Int] = []
    
    var pass: Int = 0
    var passes: [Int] = []
    
    init(){
        
        for _ in runSections { runs.append(0) }
        for _ in passSections { passes.append(0) }
        
    }
    
    func runSection(y: Int){
        
        let r = runSections
        
        switch y {
        case 0 ... r[0]: runs[0]++
        case r[0] ... r[1]: runs[1]++
        case r[1] ... r[2]: runs[2]++
        case r[2] ... r[3]: runs[3]++
        default: runs[4]++
        }
        
    }
    
    func passSection(y: Int){
        
        let r = passSections
        
        switch y {
        case 0 ... r[0]: passes[0]++
        case r[0] ... r[1]: passes[1]++
        case r[1] ... r[2]: passes[2]++
        case r[2] ... r[3]: passes[3]++
        default: passes[4]++
        }
        
    }
    
    func runPercent() -> CGFloat {
        
        if CGFloat(run+pass) == 0 { return 0 }
        
        return CGFloat(run) / CGFloat(run+pass)
        
    }
    
    func passPercent() -> CGFloat {
        
        if CGFloat(run+pass) == 0 { return 0 }
        
        return CGFloat(pass) / CGFloat(run+pass)
        
    }
    
}