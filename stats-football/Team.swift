//
//  Team.swift
//  stats-football
//
//  Created by grobinson on 9/7/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import SwiftyJSON
import CoreData

class Team {
    
    var id: Int!
    var name: String!
    var short: String!
    var roster: [Player] = []
    
    init(json: JSON){
        
        id = json["id"].int
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
        
        id = Int(round(NSDate().timeIntervalSinceReferenceDate))
        
    }
    
    init(item: NSManagedObject){
        
        name = item.valueForKey("name") as! String
        short = item.valueForKey("short") as! String
        
    }
    
    func save(completion: (s: Bool) -> Void){
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        
        var team: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Teams", inManagedObjectContext: context) as! NSManagedObject
        
        team.setValue(name, forKey: "name")
        team.setValue(short, forKey: "short")
        
        var error: NSError?
        
        context.save(&error)
        
        if let e = error {
            
            println(e)
            
            
            completion(s: false)
            
        } else {
            
            println("SAVED!")
            
            completion(s: true)
            
        }
        
    }
    
}

class Game {
    
    var id: Int!
    var start_time: NSDate!
    var away_id: Int64!
    var home_id: Int64!
    var away: Team!
    var home: Team!
    
    init(json: JSON){
        
        id = json["id"].intValue
        away_id = json["away_id"].int64Value
        home_id = json["home_id"].int64Value
        away = Team(json: json["away"])
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