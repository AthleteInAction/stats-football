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
    var roster: [Int] = []
    
    init(json: JSON){
        
        id = json["id"].intValue
        name = json["name"].stringValue
        short = json["short"].stringValue
        
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