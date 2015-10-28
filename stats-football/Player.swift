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
    
    @NSManaged var id: String?
    @NSManaged var number: String
    @NSManaged var first_name: String?
    @NSManaged var last_name: String?
    @NSManaged var used: String
    @NSManaged var is_qb: Bool
    @NSManaged var is_rb: Bool
    @NSManaged var is_rec: Bool
    @NSManaged var is_k: Bool
    @NSManaged var team: TeamObject?
    @NSManaged var game: GameObject
    @NSManaged var created_at: NSDate?
    
}
// =================================================================================
// =================================================================================
class Player {
    
    var id: Int?
    var number: Int!
    var first_name: String?
    var last_name: String?
    var used: Int = 0
    var is_qb: Bool = false
    var is_rb: Bool = false
    var is_rec: Bool = false
    var is_k: Bool = false
    var team: Team!
    var game: Game!
    var object: PlayerObject!
    var created_at: NSDate!
    
    init(game _g: Game,number _number: Int){
        
        var entity = NSEntityDescription.entityForName("Players", inManagedObjectContext: context)
        var item = PlayerObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        game = _g
        number = _number
        object = item
        created_at = NSDate()
        
    }
    
    init(object _object: PlayerObject){
        
        if let i = _object.id { id = i.toInt()! }
        game = Game(game: _object.game)
        number = _object.number.toInt()!
        if let n = _object.first_name { first_name = n }
        if let n = _object.last_name { last_name = n }
        used = _object.used.toInt()!
        object = _object
        if let date = _object.created_at { created_at = date } else { created_at = NSDate() }
        is_qb = object.is_qb
        is_rb = object.is_rb
        is_rec = object.is_rec
        is_k = object.is_k
        
    }
    
    func save(completion: CoreDataCompletion?){
        
        var c = completion
        
        var error: NSError?
        
        if let i = id { object.id = i.string() }
        object.number = number.string()
        object.first_name = first_name
        object.last_name = last_name
        object.used = used.string()
        object.game = game.object
        object.created_at = created_at
        object.is_qb = is_qb
        object.is_rb = is_rb
        object.is_rec = is_rec
        object.is_k = is_k
        
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            JP("PLAYER SAVE ERROR!")
            JP(e)
            
        } else {
            
            JP(object)
            JP("PLAYER SAVED!")
            
        }
        
        c?(error: error)
        
    }
    
    func delete(completion: CoreDataCompletion?){
        
        var c = completion
        
        var error: NSError?
        
        object.managedObjectContext?.deleteObject(object)
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            JP("DELETE PLAYER ERROR!")
            JP(e)
            
        } else {
            
            JP("PLAYER DELETED!")
            
        }
        
        c?(error: error)
        
    }
    
}
// =================================================================================
// =================================================================================