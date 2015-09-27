// ========================================================
// ========================================================
//  Play.swift
//  stats-football
//
//  Created by grobinson on 9/14/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import CoreData
// ========================================================
// ========================================================
@objc(PlayObject)
class PlayObject: NSManagedObject {
    
    @NSManaged var key: String
    @NSManaged var endX: String?
    @NSManaged var endY: String?
    @NSManaged var player_a: String
    @NSManaged var player_b: String?
    @NSManaged var team: TeamObject?
    @NSManaged var sequence: SequenceObject
    @NSManaged var created_at: NSDate
    
}
// ========================================================
// ========================================================
class Play {
    
    var key: String!
    var endX: Int?
    var endY: Int?
    var player_a: Int!
    var player_b: Int?
    var team: Team?
    var tackles: [Int] = []
    var sacks: [Int] = []
    var object: PlayObject!
    var created_at: NSDate!
    
    private var sequence: SequenceObject!
    
    init(s: Sequence){
        
        var entity = NSEntityDescription.entityForName("Plays", inManagedObjectContext: context)
        var o = PlayObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        object = o
        sequence = s.object
        created_at = NSDate()
        
    }
    
    init(play: PlayObject){
        
        key = play.key
        if let x = play.endX { endX = x.toInt()! }
        if let y = play.endY { endY = y.toInt()! }
        player_a = play.player_a.toInt()!
        if let b = play.player_b { player_b = b.toInt()! }
        if let t = play.team { team = Team(team: t) }
        object = play
        sequence = play.sequence
        created_at = play.created_at
        
    }
    
    func delete(completion: CoreDataCompletion?){
        
        var c = completion
        
        var error: NSError?
        
        object.managedObjectContext?.deleteObject(object)
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            println("DELETE PLAY ERROR!")
            println(e)
            
        } else {
            
            println("PLAY DELETED!")
            
        }
        
        c?(error: error)
        
    }
    
    func save(completion: CoreDataCompletion?){
        
        var c = completion
        
        var error: NSError?
        
        object.sequence = sequence
        object.created_at = created_at
        object.key = key
        if let x = endX { object.endX = "\(x)" } else { object.endX = nil }
        if let y = endY { object.endY = "\(y)" } else { object.endY = nil }
        object.player_a = "\(player_a)"
        if let b = player_b { object.player_b = "\(b)" } else { object.player_b = nil }
        if let t = team { object.team = t.object } else { object.team = nil }
        
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            println("PLAY SAVE ERROR!")
            println(e)
            
        } else {
            
            println(object)
            println("PLAY SAVED!")
            
        }
        
        c?(error: error)
        
    }
    
}

extension Play {
    
    func serialize() -> [String:AnyObject] {
        
        var final: [String:AnyObject] = [
            "qtr": object.sequence.qtr,
            "key": key,
            "playtype": object.sequence.key
        ]
        
        if let d = object.sequence.down { final["down"] = d.toInt()! }
        if let d = object.sequence.fd {
            
            final["fd"] = d.toInt()!
            
            var los = object.sequence.startX.toInt()!
            var fd2 = d.toInt()!
            
            if los < 0 {
                los = los * -1
            } else {
                los = 100 - los
            }
            if fd2 < 0 {
                fd2 = fd2 * -1
            } else {
                fd2 = 100 - fd2
            }
            
            final["togo"] = fd2 - los
            
        }
        if let x = endX { final["endX"] = x }
        if let y = endY { final["endY"] = y }
        
        return final
        
    }
    
}