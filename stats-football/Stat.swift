//
//  Stat.swift
//  stats-football
//
//  Created by grobinson on 9/25/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

class Stat {
    
    var key: String!
    var player: Int!
    var value: Int?
    var playtype: String!
    var team: Team!
    var score: Scores?
    
}

class PassingTotal {
    
    var att: Int = 0
    var comp: Int = 0
    var yds: Int = 0
    var td: Int = 0
    var int: Int = 0
    
    init(){
        
        
        
    }
    
    func add(stat _stat: Stat){
        
        if _stat.key == "completion" {
            att++
            comp++
        }
        
        if _stat.key == "incompletion" {
            att++
        }
        
        if _stat.key == "int_thrown" {
            att++
        }
        
        if let v = _stat.value {
            yds += v
        }
        
        if let s = _stat.score {
            
            if s == .Touchdown { td++ }
            
        }
        
    }
    
}