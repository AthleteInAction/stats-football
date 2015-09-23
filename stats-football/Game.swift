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
    @NSManaged var sequences: NSSet
    
}
// =================================================================================
// =================================================================================
class Game {
    
    var id: Int?
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
        
        if let i = game.id { id = i.toInt()! }
        away = Team(team: game.away)
        home = Team(team: game.home)
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
        
        if let i = id { object.id = i.string() }
        object.away = away.object
        object.home = home.object
        
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            println("GAME SAVE ERROR!")
            println(e)
            
        } else {
            
            println(object)
            println("GAME SAVED!")
//            if home.id != nil && away.id != nil { saveRemote(nil) }
            
        }
        
        c?(error: error)
        
    }
    
    func saveRemote(completion: Completion?){
        
        var c = completion
        
        var s = "\(domain)"
        var method = Method.PUT
        var successCode = 200
        
        if let id = id {
            
            s += "/api/v1/games/\(id).json"
            method = Method.PUT
            successCode = 200
            
        } else {
            
            s += "/api/v1/games.json"
            method = Method.POST
            successCode = 201
            
        }
        
        let game = [
            "game":[
                "home_id": home.id!,
                "away_id": away.id!
            ]
        ]
        
        Alamofire.request(method, s, parameters: game,encoding: .JSON)
            .responseJSON { request, response, data, error in
                
                if error == nil {
                    
                    if response?.statusCode == successCode {
                        
                        var json = JSON(data!)
                        
                        if let id = self.id {
                            
                        } else {
                            
                            self.id = json["game"]["id"].intValue
                            self.object.id = self.id?.string()
                            self.object.managedObjectContext?.save(nil)
                            
                        }
                        
                    } else {
                        
                        println("Status Code Error: \(response?.statusCode)")
                        println(request)
                        
                    }
                    
                } else {
                    
                    println("Error!")
                    println(error)
                    println(request)
                    
                }
                
                c?(error: error)
                
        }
        
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