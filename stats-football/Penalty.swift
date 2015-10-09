// ========================================================
// ========================================================
//  Penalty.swift
//  stats-football
//
//  Created by grobinson on 9/14/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import CoreData
// ========================================================
// ========================================================
@objc(PenaltyObject)
class PenaltyObject: NSManagedObject {
    
    @NSManaged var id: String?
    @NSManaged var distance: String
    @NSManaged var endX: String?
    @NSManaged var enforcement: String
    @NSManaged var player: String?
    @NSManaged var sequence: SequenceObject
    @NSManaged var team: TeamObject
    @NSManaged var created_at: NSDate
    
}
// ========================================================
// ========================================================
class Penalty {
    
    // PROPERTIES
    // --------------------------------------
    // --------------------------------------
    var id: Int?
    var team: Team!
    var distance: Int!
    var endX: Yardline?
    var enforcement: Key!
    var player: Int?
    var created_at: NSDate!
    var object: PenaltyObject!
    
    private var sequence: SequenceObject!
    // --------------------------------------
    // --------------------------------------
    
    
    // INIT
    // iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
    // iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
    init(s: Sequence){
        
        var entity = NSEntityDescription.entityForName("Penalties", inManagedObjectContext: context)
        var o = PenaltyObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        object = o
        sequence = s.object
        created_at = NSDate()
        
    }
    init(penalty: PenaltyObject){
        
        distance = penalty.distance.toInt()!
        if let x = penalty.endX { endX = Yardline(spot: x.toInt()!) }
        enforcement = penalty.enforcement.toKey()
        if let p = penalty.player { player = p.toInt()! }
        team = Team(team: penalty.team)
        created_at = penalty.created_at
        sequence = penalty.sequence
        object = penalty
        
    }
    // iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
    // iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
    
    
    // SAVE
    // ++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++
    func save(completion: CoreDataCompletion?){
        
        var done = completion
        var error: NSError?
        
        if let i = id { object.id = i.string() }
        object.sequence = sequence
        object.created_at = created_at
        object.distance = distance.string()
        if let x = endX { object.endX = x.spot.string() } else { object.endX = nil }
        object.enforcement = enforcement.string
        if let p = player { object.player = p.string() } else { object.player = nil }
        object.team = team.object
        
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            JP("PENALTY SAVE ERROR!")
            JP(e)
            
        } else {
            
            JP(object)
            JP("PENALTY SAVED!")
            
        }
        
        done?(error: error)
    
    }
    // ++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++
    
    
    // DELETE
    // --------------------------------------
    // --------------------------------------
    func delete(completion: CoreDataCompletion?){
        
        var done = completion
        
        var error: NSError?
        
        object.managedObjectContext?.deleteObject(object)
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            JP("DELETE PENALTY ERROR!")
            JP(e)
            
        } else {
            
            JP("PENALTY DELETED!")
            
        }
        
        done?(error: error)
        
    }
    // --------------------------------------
    // --------------------------------------
    
}
// ========================================================
// ========================================================

extension Int {
    
    func string() -> String { return "\(self)" }
    
}