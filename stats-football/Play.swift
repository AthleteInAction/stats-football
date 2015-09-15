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
    
    init(){
        
        
        
    }
    
    init(play: PlayObject){
        
        key = String(play.key)
        if let x = play.endX { endX = String(x).toInt() }
        if let y = play.endY { endY = String(y).toInt() }
        player_a = String(play.player_a).toInt()
        if let b = play.player_b { player_b = String(b).toInt() }
        if let t = play.team { team = Team(team: t) }
        object = play
        
    }
    
    typealias Completion = (error: NSError?) -> Void
    
    func save(completion: Completion?){
        
        var c = completion
        
        var error: NSError?
        
        if let o = object {
            
            o.key = key
            if let x = endX {  o.endX = "\(x)" }
            if let y = endY {  o.endY = "\(y)" }
            o.player_a = "\(player_a)"
            if let b = player_b { o.player_b = "\(b)" }
            if let t = team { o.team = t.object }
            
            o.managedObjectContext?.save(&error)
            
            c?(error: error)
            
        } else {
            
//            var entity = NSEntityDescription.entityForName("Plays", inManagedObjectContext: context)
//            
//            var o = PlayObject(entity: entity!, insertIntoManagedObjectContext: context)
//            
//            o.key = key
//            if let x = endX {  o.endX = "\(x)" }
//            if let y = endY {  o.endY = "\(y)" }
//            o.player_a = "\(player_a)"
//            if let b = player_b { o.player_b = "\(b)" }
//            if let t = team { o.team = t.object }
//            
//            context.save(&error)
//            
//            if error == nil { object = o }
//            
//            c?(error: error)
            
        }
        
    }
    
}
// ========================================================
// ========================================================
@objc(PlayObject)
class PlayObject: NSManagedObject {
    
    @NSManaged var sequence: SequenceObject
    @NSManaged var team: TeamObject?
    @NSManaged var key: NSString
    @NSManaged var endX: NSString?
    @NSManaged var endY: NSString?
    @NSManaged var player_a: NSString
    @NSManaged var player_b: NSString?
    
}
// ========================================================
// ========================================================