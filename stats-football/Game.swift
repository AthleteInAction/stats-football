// =================================================================================
// =================================================================================
//  Game.swift
//  stats-football
//
//  Created by grobinson on 9/14/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import CoreData
import Alamofire
import SwiftyJSON
// =================================================================================
// =================================================================================
@objc(GameObject)
class GameObject: NSManagedObject {
    
    @NSManaged var id: String?
    @NSManaged var away: TeamObject
    @NSManaged var home: TeamObject
    @NSManaged var right_home: String
    @NSManaged var created_at: NSDate?
    @NSManaged var players: NSSet
    @NSManaged var sequences: NSSet
    
}
// =================================================================================
// =================================================================================
class Game {
    
    var id: Int?
    var away: Team!
    var home: Team!
    var right_home: Bool = true
    var created_at: NSDate!
    var players: [Player] = []
    var sequences: [Sequence] = []
    var playerStats: [Stat] = []
    var object: GameObject!
    
    init(away _away: Team,home _home: Team){
        
        var entity = NSEntityDescription.entityForName("Games", inManagedObjectContext: context)
        var item = GameObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        away = _away
        home = _home
        object = item
        created_at = NSDate()
        
    }
    
    init(game: GameObject){
        
        if let i = game.id { id = i.toInt()! }
        away = Team(team: game.away)
        home = Team(team: game.home)
        right_home = game.right_home.toBool()
        if let date = game.created_at { created_at = date } else { created_at = NSDate() }
        object = game
        
    }
    
    typealias Completion = (error: NSError?) -> Void
    
    func delete(completion: Completion?){
        
        var c = completion
        
        var error: NSError?
        
        let sequences = object.sequences.allObjects as! [SequenceObject]
        for object in sequences {
            
            let p = object.plays.allObjects as! [PlayObject]
            for o in p { o.managedObjectContext?.deleteObject(o) }
            
            let pe = object.penalties.allObjects as! [PenaltyObject]
            for o in pe { o.managedObjectContext?.deleteObject(o) }
            
            object.managedObjectContext?.deleteObject(object)
            
        }
        
        object.managedObjectContext?.deleteObject(object)
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            JP("DELETE GAME ERROR!")
            JP(e)
            
        } else {
            
            JP("GAME DELETED!")
            
        }
        
        c?(error: error)
        
    }
    
    func save(completion: Completion?){
        
        var c = completion
        
        var error: NSError?
        
        if let i = id { object.id = i.string() }
        object.away = away.object
        object.home = home.object
        object.right_home = right_home.description
        object.created_at = created_at
        
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            JP("GAME SAVE ERROR!")
            JP(e)
            
        } else {
            
            JP(object)
            JP("GAME SAVED!")
            
        }
        
        c?(error: error)
        
    }
    
    func getPlayers(){
        
        var objects = object.players.allObjects as! [PlayerObject]
        
        players = objects.map { o in
            
            let player = Player(object: o)
            
            return player
            
        }
        
        players.sort({ $0.number < $1.number })
        
    }
    
    func getSequences(){
        
        JP("++++++++++ GET SEQUENCES START ++++++++++")
        var sequenceObjects = object.sequences.allObjects as! [SequenceObject]
        
        sequences = sequenceObjects.map { o in
            
            let sequence = Sequence(sequence: o)
            
            return sequence
            
        }
        
        sequences.sort({ $0.created_at.compare($1.created_at) == NSComparisonResult.OrderedDescending })
        JP("++++++++++ GET SEQUENCES END ++++++++++")
        
    }
    
    func oppositeTeam(team _team: Team) -> Team {
        
        if _team.object.isEqual(home.object) {
            
            return away
            
        } else {
            
            return home
        }
        
    }
    
}