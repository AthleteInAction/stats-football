//
//  Stat.swift
//  stats-football
//
//  Created by grobinson on 9/25/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit

class Stat {
    
    var key: String!
    var player: Int!
    var value: Int?
    var playtype: String!
    var team: Team!
    var score: Scores?
    var attempt: Bool = false
    
}

class ReturnTotal {
    
    var player: Int!
    var att: Int = 0
    var yds: Int = 0
    var long: Int = 0
    var td: Int = 0
    
    init(){}
    
    init(player _player: Int){ player = _player }
    
    func add(stat _stat: Stat){
        
        if _stat.attempt { att++ }
        
        if let v = _stat.value {
            
            yds += v
            
            if v > long { long = v }
            
        }
        
        if let score = _stat.score {
            
            if score == .Touchdown { td++ }
            
        }
        
    }
    
    func yardsPerReturn() -> Float {
        
        if att > 0 {
            
            return round((Float(yds) / Float(att) * 10)) / 10
            
        } else {
            
            return 0.0
            
        }
        
    }
    
}

class ReceivingTotal {
    
    var player: Int!
    var rec: Int = 0
    var yds: Int = 0
    var long: Int = 0
    var td: Int = 0
    
    init(){}
    
    init(player _player: Int){ player = _player }
    
    func add(stat _stat: Stat){
        
        if _stat.attempt { rec++ }
        
        if let v = _stat.value {
            
            yds += v
            
            if v > long { long = v }
        
        }
        
        if let score = _stat.score {
            
            if score == .Touchdown { td++ }
            
        }
        
    }
    
    func yardsPerCatch() -> Float {
        
        if rec > 0 {
            
            return round((Float(yds) / Float(rec) * 10)) / 10
            
        } else {
            
            return 0.0
            
        }
        
    }
    
}

class RushingTotal {
    
    var player: Int!
    var att: Int = 0
    var yds: Int = 0
    var td: Int = 0
    var long: Int = 0
    
    init(){}
    
    init(player _player: Int){ player = _player }
    
    func add(stat _stat: Stat){
        
        if _stat.attempt { att++ }
        
        if let v = _stat.value {
            
            yds += v
            
            if v > long { long = v }
        
        }
        
        if let score = _stat.score {
            
            if score == .Touchdown { td++ }
            
        }
        
    }
    
    func yardsPerAttempt() -> Float {
        
        if att > 0 {
            
            return round((Float(yds) / Float(att) * 10)) / 10
            
        } else {
            
            return 0.0
            
        }
        
    }
    
}

class PassingTotal {
    
    var player: Int!
    var att: Int = 0
    var comp: Int = 0
    var yds: Int = 0
    var td: Int = 0
    var int: Int = 0
    var long: Int = 0
    
    init(){}
    
    init(player _player: Int){
        
        player = _player
        
    }
    
    func add(stat _stat: Stat){
        
        if _stat.key == "completion" {
            
            att++
            comp++
            
            if let v = _stat.value {
                
                if v > long { long = v }
                
            }
            
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
    
    func passerRating() -> Float {
        
        if att == 0 { return 0.0 }
        
        var a: Float = ((Float(comp) / Float(att)) - 0.3) * 5
        var b: Float = ((Float(yds) / Float(att)) - 3) * 0.25
        var c: Float = (Float(td) / Float(att)) * 20
        var d: Float = 2.375 - ((Float(int) / Float(att)) * 25)
        
        if a > 2.375 { a = 2.375 }
        if b > 2.375 { b = 2.375 }
        if c > 2.375 { c = 2.375 }
        if d > 2.375 { d = 2.375 }
        
        return round((((a + b + c + d) / 6) * 100) * 10) / 10
        
    }
    
    func completionPercentage() -> Float {
        
        if att > 0 {
            
            return round((Float(comp) / Float(att)) * 1000) / 10
            
        } else {
            
            return 0.0
            
        }
        
    }
    
    func yardsPerAttempt() -> Float {
        
        if att > 0 {
            
            return round((Float(yds) / Float(att) * 10)) / 10
            
        } else {
            
            return 0.0
            
        }
        
    }
    
}