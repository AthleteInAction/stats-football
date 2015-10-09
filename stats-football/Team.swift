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
import Alamofire
import SwiftyJSON
// =================================================================================
// =================================================================================
@objc(TeamObject)
class TeamObject: NSManagedObject {
    
    @NSManaged var id: String?
    @NSManaged var name: String
    @NSManaged var short: String
    @NSManaged var primary: String
    @NSManaged var secondary: String
    @NSManaged var created_at: NSDate?
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
    
    var id: Int?
    var name: String!
    var short: String!
    var primary: UIColor!
    var secondary: UIColor!
    var created_at: NSDate!
    var roster: [Player] = []
    var object: TeamObject!
    var score: Int = 0
    var passing: [PassingTotal] = []
    var teamPassing = PassingTotal()
    var rushing: [RushingTotal] = []
    var teamRushing = RushingTotal()
    var receiving: [ReceivingTotal] = []
    var teamReceiving = ReceivingTotal()
    var puntReturns: [ReturnTotal] = []
    var teamPuntReturns = ReturnTotal()
    var kickReturns: [ReturnTotal] = []
    var teamKickReturns = ReturnTotal()
    var MPCPlays: [[String:AnyObject]] = []
    
    init(name _name: String,short _short: String){
        
        var entity = NSEntityDescription.entityForName("Teams", inManagedObjectContext: context)
        var item = TeamObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        name = _name
        short = _short
        primary = UIColor.blackColor()
        secondary = UIColor.whiteColor()
        object = item
        created_at = NSDate()
        
    }
    
    init(team: TeamObject){
        
        if let i = team.id { id = i.toInt()! }
        name = team.name
        short = team.short
        if let date = team.created_at { created_at = date } else { created_at = NSDate() }
        object = team
        primary = getColor(object.primary)
        secondary = getColor(object.secondary)
        
    }
    
    private func getColor(s: String) -> UIColor {
        
        let c = split(s){$0 == ","}.map { o in
            
            CGFloat(String(o).toInt()!) / 255
            
        }
        
        return UIColor(red: c[0], green: c[1], blue: c[2], alpha: 1)
        
    }
    private func colorText(color: UIColor) -> String {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
            
            return "\(Int(round(r * 255))),\(Int(round(g * 255))),\(Int(round(b * 255)))"
            
        }
        
        return "0,0,0"
        
    }
    
    typealias Completion = (error: NSError?) -> Void
    
    func save(completion: Completion?){
        
        var c = completion
        
        var error: NSError?
        
        if let i = id { object.id = i.string() }
        object.name = name
        object.short = short
        object.created_at = created_at
        object.primary = colorText(primary)
        object.secondary = colorText(secondary)
        
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            JP("TEAM SAVE ERROR!")
            JP(e)
            
        } else {
            
            JP(object)
            JP("TEAM SAVED!")
            
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
            
            JP("DELETE GAME ERROR!")
            JP(e)
            
        } else {
            
            JP("GAME DELETED!")
            
        }
        
        c?(error: error)
        
    }
    
}