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
class Penalty {
    
    // PROPERTIES
    // --------------------------------------
    // --------------------------------------
    var team: Team!
    var distance: Int!
    var endX: Int?
    var enforcement: String!
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
        if let x = penalty.endX { endX = x.toInt()! }
        enforcement = penalty.enforcement
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
        
        object.sequence = sequence
        object.created_at = created_at
        object.distance = distance.string()
        if let x = endX { object.endX = x.string() } else { object.endX = nil }
        object.enforcement = enforcement
        if let p = player { object.player = p.string() } else { object.player = nil }
        object.team = team.object
        
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            println("PENALTY SAVE ERROR!")
            println(e)
            
        } else {
            
            println(object)
            println("PENALTY SAVED!")
            
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
            
            println("DELETE PENALTY ERROR!")
            println(e)
            
        } else {
            
            println("PENALTY DELETED!")
            
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