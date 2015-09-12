//
//  Team.swift
//  stats-football
//
//  Created by grobinson on 9/7/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import SwiftyJSON

class Team {
    
    var id: Int!
    var name: String!
    var short: String!
    var roster: [Player] = []
    
    init(json: JSON){
        
        id = json["id"].intValue
        name = json["name"].stringValue
        short = json["short"].stringValue
        
        if let players = json["roster"].array {
            
            var tmp: [Player] = []
            
            for player in players {
                
                let p = Player(n: player.intValue)
                
                tmp.append(p)
                
            }
            
            roster = tmp
            
        }
        
    }
    
    init(){
        
        
        
    }
    
}

class Game {
    
    var id: Int!
    var start_time: NSDate!
    var away_id: Int!
    var away: Team!
    var home_id: Int!
    var home: Team!
    
    init(json: JSON){
        
        id = json["id"].intValue
        away_id = json["away_id"].intValue
        away = Team(json: json["away"])
        home_id = json["home_id"].intValue
        home = Team(json: json["home"])
        
    }
    
}

class Player {
    
    var number: Int!
    var used: Int = 0
    
    init(n: Int){
        
        number = n
        
    }
    
}