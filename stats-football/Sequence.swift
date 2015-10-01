// ========================================================
// ========================================================
//  Sequence.swift
//  stats-football
//
//  Created by grobinson on 8/27/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit
import CoreData
import Alamofire
import SwiftyJSON
// ========================================================
// ========================================================
@objc(SequenceObject)
class SequenceObject: NSManagedObject {
    
    @NSManaged var id: String?
    @NSManaged var qtr: String
    @NSManaged var key: String
    @NSManaged var down: String?
    @NSManaged var fd: String?
    @NSManaged var startX: String
    @NSManaged var startY: String
    @NSManaged var replay: String
    @NSManaged var game: GameObject
    @NSManaged var team: TeamObject
    @NSManaged var plays: NSSet
    @NSManaged var penalties: NSSet
    @NSManaged var flagged: String
    @NSManaged var created_at: NSDate
    
}
// ========================================================
// ========================================================
class Sequence {
    
    var id: Int?
    var game: Game!
    var team: Team!
    var qtr: Int!
    var key: Playtype!
    var down: Int?
    var fd: Yardline?
    var startX: Yardline!
    var startY: Int!
    var replay: Bool = false
    var plays: [Play] = []
    var penalties: [Penalty] = []
    var flagged: Bool = false
    var created_at: NSDate!
    var object: SequenceObject!
    
    init(game _game: Game){
        
        var entity = NSEntityDescription.entityForName("Sequences", inManagedObjectContext: context)
        var o = SequenceObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        object = o
        game = _game
        startY = 50
        created_at = NSDate()
        
    }
    
    init(sequence: SequenceObject){
        
        if let i = sequence.id { id = i.toInt()! }
        created_at = sequence.created_at
        team = Team(team: sequence.team)
        game = Game(game: sequence.game)
        qtr = sequence.qtr.toInt()!
        key = sequence.key.toPlaytype
        if let d = sequence.down { down = d.toInt()! }
        if let f = sequence.fd { fd = Yardline(spot: f.toInt()!) }
        startX = Yardline(spot: sequence.startX.toInt()!)
        startY = sequence.startY.toInt()!
        replay = sequence.replay.toBool()
        flagged = sequence.flagged.toBool()
        object = sequence
        
    }
    
    typealias Completion = (error: NSError?) -> Void
    
    func delete(completion: Completion?){
        
        var c = completion
        
        var error: NSError?
        
        let p = object.plays.allObjects as! [PlayObject]
        for o in p {
            o.managedObjectContext?.deleteObject(o)
            o.managedObjectContext?.save(nil)
        }
        let pe = object.penalties.allObjects as! [PenaltyObject]
        for o in pe {
            o.managedObjectContext?.deleteObject(o)
            o.managedObjectContext?.save(nil)
        }
        
        object.managedObjectContext?.deleteObject(object)
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            println("DELETE SEQUENCE ERROR!")
            println(e)
            
        } else {
            
            println("SEQUENCE DELETED!")
            
        }
        
        c?(error: error)
        
    }
    
    func save(completion: Completion?){
        
        var c = completion
        
        var error: NSError?
        
        if let i = id { object.id = i.string() }
        object.created_at = created_at
        object.game = game.object
        object.key = key.string
        object.team = team.object
        object.qtr = "\(qtr)"
        if let d = down { object.down = d.string() } else { object.down = nil }
        if let f = fd { object.fd = f.spot.string() } else { object.fd = nil }
        object.startX = startX.spot.string()
        object.startY = startY.string()
        object.flagged = flagged.description
        object.replay = replay.description
        
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            println("SEQUENCE SAVE ERROR!")
            println(e)
            
        } else {
            
            println(object)
            println("SEQUENCE SAVED!")
            
        }
        
        c?(error: error)
        
    }
    
    func getPlays(){
        
        var playObjects = object.plays.allObjects as! [PlayObject]
        
        plays = playObjects.map { o in
         
            let play = Play(play: o)
            
            return play
            
        }
        
        plays.sort({ $0.created_at.compare($1.created_at) == NSComparisonResult.OrderedAscending })
        
    }
    
    func getPenalties(){
        
        var penaltyObjects = object.penalties.allObjects as! [PenaltyObject]
        
        penalties = penaltyObjects.map { o in
            
            let penalty = Penalty(penalty: o)
            
            return penalty
            
        }
        
        penalties.sort({ $0.created_at.compare($1.created_at) == NSComparisonResult.OrderedAscending })
        
    }
    
}

extension String {
    
    func toBool() -> Bool { return self == "true" }
    
}