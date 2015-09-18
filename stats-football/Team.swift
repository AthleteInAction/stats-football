// =================================================================================
// =================================================================================
//  Team.swift
//  stats-football
//
//  Created by grobinson on 9/14/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit
import CoreData
// =================================================================================
// =================================================================================
@objc(TeamObject)
class TeamObject: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var short: String
    @NSManaged var color: String
    @NSManaged var away_games: NSSet
    @NSManaged var home_games: NSSet
    @NSManaged var sequences: NSSet
    @NSManaged var plays: NSSet
    @NSManaged var penalties: NSSet
    @NSManaged var roster: NSSet
    
}
// =================================================================================
// =================================================================================
class Team {
    
    var name: String!
    var short: String!
    var color: UIColor!
    var roster: [Player] = []
    var object: TeamObject!
    
    init(name _name: String,short _short: String){
        
        var entity = NSEntityDescription.entityForName("Teams", inManagedObjectContext: context)
        var item = TeamObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        name = _name
        short = _short
        color = UIColor.blackColor()
        object = item
        
    }
    
    init(team: TeamObject){
        
        name = team.name
        short = team.short
        object = team
        color = getColor(object.color)
        
    }
    
    private func getColor(s: String) -> UIColor {
        
        let c = split(s){$0 == ","}.map { o in
            
            CGFloat(String(o).toInt()!) / 100
            
        }
        
        return UIColor(red: c[0], green: c[1], blue: c[2], alpha: 1)
        
    }
    private func colorText(color: UIColor) -> String {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
            
            return "\(Int(r*100)),\(Int(g*100)),\(Int(b*100))"
            
        }
        
        return "0,0,0"
        
    }
    
    typealias Completion = (error: NSError?) -> Void
    
    func save(completion: Completion?){
        
        var c = completion
        
        var error: NSError?
        
        object.name = name
        object.short = short
        object.color = colorText(color)
        
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            println("TEAM SAVE ERROR!")
            println(e)
            
        } else {
            
            println(object)
            println("TEAM SAVED!")
            
        }
        
        c?(error: error)
        
    }
    
    func delete(completion: Completion?){
        
        var c = completion
        
        var error: NSError?
        
        let players = object.roster.allObjects as! [PlayerObject]
        
        for o in players {
            
            let player = Player(object: o)
            
            player.delete(nil)
            
        }
        
        object.managedObjectContext?.deleteObject(object)
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            println("DELETE GAME ERROR!")
            println(e)
            
        } else {
            
            println("GAME DELETED!")
            
        }
        
        c?(error: error)
        
    }
    
    func getRoster(){
        
        let playerObjects = object.roster.allObjects as! [PlayerObject]
        
        var tmp: [Player] = []
        
        for o in playerObjects {
            
            let player = Player(object: o)
            
            tmp.append(player)
            
        }
        
        roster = tmp
        
    }
    
}