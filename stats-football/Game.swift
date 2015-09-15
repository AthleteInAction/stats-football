// =================================================================================
// =================================================================================
//  Game.swift
//  stats-football
//
//  Created by grobinson on 9/14/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit
import CoreData
// =================================================================================
// =================================================================================
class Game {
    
    var away: Team!
    var home: Team!
    var object: GameObject!
    
    init(away _away: Team,home _home: Team){
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
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
    
}
// =================================================================================
// =================================================================================
@objc(GameObject)
class GameObject: NSManagedObject {
    
    @NSManaged var away: TeamObject
    @NSManaged var home: TeamObject
    @NSManaged var sequences: NSSet
    
}
// =================================================================================
// =================================================================================