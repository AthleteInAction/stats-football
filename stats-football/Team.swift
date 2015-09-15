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
class Team {
    
    var name: String!
    var short: String!
    var object: TeamObject!
    
    init(name _name: String,short _short: String){
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        var entity = NSEntityDescription.entityForName("Teams", inManagedObjectContext: context)
        var item = TeamObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        name = _name
        short = _short
        object = item
        
    }
    
    init(team: TeamObject){
        
        name = String(team.name)
        short = String(team.short)
        object = team
//        0x7caa4d30
        
    }
    
    typealias Completion = (error: NSError?) -> Void
    
    func save(completion: Completion?){
        
        var c = completion
        
        var error: NSError?
        
        object.name = name
        object.short = short
        
        object.managedObjectContext?.save(&error)
        
        c?(error: error)
        
    }
    
}
// =================================================================================
// =================================================================================
@objc(TeamObject)
class TeamObject: NSManagedObject {
    
    @NSManaged var name: NSString
    @NSManaged var short: NSString
    @NSManaged var players: NSSet
    
}
// =================================================================================
// =================================================================================