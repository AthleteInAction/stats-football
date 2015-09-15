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
    var object: SequenceObject!
    
    init(){
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        var entity = NSEntityDescription.entityForName("Sequences", inManagedObjectContext: context)
        var o = SequenceObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        object = o
        startY = 50
        
    }
    
    init(sequence: SequenceObject){
        
        println("[][][][]")
        println(sequence)
        println("[][][][]")
        
        team = Team(team: sequence.team)
        game = Game(game: sequence.game)
        qtr = String(sequence.qtr).toInt()
        key = String(sequence.key)
        if let d = sequence.down { down = String(d).toInt() }
        if let f = sequence.fd { fd = String(f).toInt() }
        startX = String(sequence.startX).toInt()
        startY = String(sequence.startY).toInt()
        replay = sequence.replay
        object = sequence
        
    }
    
    typealias Completion = (error: NSError?) -> Void
    
    func delete(completion: Completion?){
        
        var c = completion
        
        var error: NSError?
        
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
        
        object.game = game.object
        object.key = key
        object.team = team.object
        object.qtr = "\(qtr)"
        if let d = down { object.down = "\(d)" }
        if let f = fd { object.fd = "\(f)" }
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
    
}
// ========================================================
// ========================================================
@objc(SequenceObject)
class SequenceObject: NSManagedObject {
    
    @NSManaged var game: GameObject
    @NSManaged var team: TeamObject
    @NSManaged var qtr: NSString
    @NSManaged var key: NSString
    @NSManaged var down: NSString?
    @NSManaged var fd: NSString?
    @NSManaged var startX: NSString
    @NSManaged var startY: NSString
    @NSManaged var replay: Bool
    @NSManaged var plays: NSSet
    @NSManaged var penalties: NSSet
    
}
// ========================================================
// ========================================================