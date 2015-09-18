// =================================================================================
// =================================================================================
//  Game.swift
//  stats-football
//
//  Created by grobinson on 9/14/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import CoreData
// =================================================================================
// =================================================================================
class Game {
    
    var away: Team!
    var home: Team!
    var sequences: [Sequence] = []
    var object: GameObject!
    
    init(away _away: Team,home _home: Team){
        
        var entity = NSEntityDescription.entityForName("Games", inManagedObjectContext: context)
        var item = GameObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        away = _away
        home = _home
        object = item
        
    }
    
    init(game: GameObject){
        
        away = Team(team: game.away)
        home = Team(team: game.home)
        object = game
        
    }
    
    func addSequence(s: Sequence){
        
        object.mutableSetValueForKey("sequences").addObject(s.object)
        
    }
    
    func removeSequence(s: Sequence){
        
        object.mutableSetValueForKey("sequences").removeObject(s.object)
        
    }
    
    typealias Completion = (error: NSError?) -> Void
    
    func delete(completion: Completion?){
        
        var c = completion
        
        var error: NSError?
        
        let sequences = object.sequences.allObjects as! [SequenceObject]
        
        for object in sequences {
            
            let sequence = Sequence(sequence: object)
            
            sequence.delete(nil)
            
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
    
    func save(completion: Completion?){
        
        var c = completion
        
        var error: NSError?
        
        object.away = away.object
        object.home = home.object
        
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            println("GAME SAVE ERROR!")
            println(e)
            
        } else {
            
            println(object)
            println("GAME SAVED!")
            
        }
        
        c?(error: error)
        
    }
    
    func getSequences(){
        
        var sequenceObjects = object.sequences.allObjects as! [SequenceObject]
        
        sequences = sequenceObjects.map { o in
            
            let sequence = Sequence(sequence: o)
            
            return sequence
            
        }
        
        sequences.sort({ $0.created_at.compare($1.created_at) == NSComparisonResult.OrderedDescending })
        
    }
    
}