// ========================================================
// ========================================================
//  Sequence.swift
//  stats-football
//
//  Created by grobinson on 8/27/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import CoreData
// ========================================================
// ========================================================
class Sequence {
    
    var game: Game!
    var team: Team!
    var qtr: Int!
    var key: String!
    var down: Int?
    var fd: Int?
    var startX: Int!
    var startY: Int!
    var replay: Bool = false
    var plays: [Play] = []
    var penalties: [Penalty] = []
    var created_at: NSDate!
    var object: SequenceObject!
    
    init(){
        
        var entity = NSEntityDescription.entityForName("Sequences", inManagedObjectContext: context)
        var o = SequenceObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        object = o
        startY = 50
        created_at = NSDate()
        
    }
    
    init(sequence: SequenceObject){
        
        created_at = sequence.created_at
        team = Team(team: sequence.team)
        game = Game(game: sequence.game)
        qtr = sequence.qtr.toInt()!
        key = sequence.key
        if let d = sequence.down { down = d.toInt()! }
        if let f = sequence.fd { fd = f.toInt()! }
        startX = sequence.startX.toInt()!
        startY = sequence.startY.toInt()!
        replay = sequence.replay
        object = sequence
        
    }
    
    typealias Completion = (error: NSError?) -> Void
    
    func delete(completion: Completion?){
        
        var c = completion
        
        var error: NSError?
        
        object.managedObjectContext?.deleteObject(object)
        object.managedObjectContext?.save(&error)
        
        // DELETE CHILDREN
        for play in plays { play.delete(nil) }
        for penalty in penalties { penalty.delete(nil) }
        
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
        
        object.created_at = created_at
        object.game = game.object
        object.key = key
        object.team = team.object
        object.qtr = "\(qtr)"
        if let d = down { object.down = "\(d)" } else { object.down = nil }
        if let f = fd { object.fd = "\(f)" } else { object.fd = nil }
        object.startX = "\(startX)"
        object.startY = "\(startY)"
        object.replay = replay
        
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