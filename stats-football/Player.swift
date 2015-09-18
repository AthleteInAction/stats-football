// =================================================================================
// =================================================================================
//  Roster.swift
//  stats-football
//
//  Created by grobinson on 9/7/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import CoreData
// =================================================================================
// =================================================================================
@objc(PlayerObject)
class PlayerObject: NSManagedObject {
    
    @NSManaged var number: String
    @NSManaged var first_name: String?
    @NSManaged var last_name: String?
    @NSManaged var used: String
    @NSManaged var team: TeamObject
    @NSManaged var created_at: NSDate
    
}
// =================================================================================
// =================================================================================
class Player {
    
    var number: Int!
    var first_name: String?
    var last_name: String?
    var used: Int = 0
    var team: Team!
    var object: PlayerObject!
    var created_at: NSDate!
    
    init(team _t: Team,number _number: Int){
        
        var entity = NSEntityDescription.entityForName("Players", inManagedObjectContext: context)
        var item = PlayerObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        team = _t
        number = _number
        object = item
        created_at = NSDate()
        
    }
    
    init(object _object: PlayerObject){
        
        team = Team(team: _object.team)
        number = _object.number.toInt()!
        if let n = _object.first_name { first_name = n }
        if let n = _object.last_name { last_name = n }
        used = _object.used.toInt()!
        object = _object
        created_at = _object.created_at
        
    }
    
    func save(completion: CoreDataCompletion?){
        
        var c = completion
        
        var error: NSError?
        
        object.number = number.string()
        object.first_name = first_name
        object.last_name = last_name
        object.used = used.string()
        object.team = team.object
        object.created_at = created_at
        
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            println("PLAYER SAVE ERROR!")
            println(e)
            
        } else {
            
            println(object)
            println("PLAYER SAVED!")
            
        }
        
        c?(error: error)
        
    }
    
    func delete(completion: CoreDataCompletion?){
        
        var c = completion
        
        var error: NSError?
        
        object.managedObjectContext?.deleteObject(object)
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            println("DELETE PLAYER ERROR!")
            println(e)
            
        } else {
            
            println("PLAYER DELETED!")
            
        }
        
        c?(error: error)
        
    }
    
}
// =================================================================================
// =================================================================================