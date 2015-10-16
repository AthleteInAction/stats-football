// ========================================================
// ========================================================
//  Play.swift
//  stats-football
//
//  Created by grobinson on 9/14/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import CoreData
import Alamofire
import SwiftyJSON
// ========================================================
// ========================================================
@objc(PlayObject)
class PlayObject: NSManagedObject {
    
    @NSManaged var id: String?
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
    
    var id: Int?
    var key: Key!
    var endX: Yardline?
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
        
        if let i = play.id { id = i.toInt()! }
        key = play.key.toKey()
        if let x = play.endX { endX = Yardline(spot: x.toInt()!) }
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
            
            JP("DELETE PLAY ERROR!")
            JP(e)
            
        } else {
            
            JP("PLAY DELETED!")
            
        }
        
        c?(error: error)
        
    }
    
    func save(completion: CoreDataCompletion?){
        
        var c = completion
        
        var error: NSError?
        
        if let i = id { object.id = i.string() }
        object.sequence = sequence
        object.created_at = created_at
        object.key = key.string
        if let x = endX { object.endX = x.spot.string() } else { object.endX = nil }
        if let y = endY { object.endY = y.string() } else { object.endY = nil }
        object.player_a = player_a.string()
        if let b = player_b { object.player_b = b.string() } else { object.player_b = nil }
        if let t = team { object.team = t.object } else { object.team = nil }
        
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            JP("PLAY SAVE ERROR!")
            JP(e)
            
        } else {
            
            JP(object)
            JP("PLAY SAVED!")
            
        }
        
        c?(error: error)
        
    }
    
    func remoteSave(completion: CoreDataCompletion?) -> Bool {
        
        var c = completion
        
        if sequence.id == nil {
            
            var e = NSError(domain: "Sequence must be saved remotely first : \(sequence.id)", code: 0, userInfo: nil)
            JP2(e)
            c?(error: e)
            
            return false
            
        }
        
        if sequence.game.id == nil {
            
            var e = NSError(domain: "Game must be saved remotely first : \(sequence.game.id)", code: 0, userInfo: nil)
            JP2(e)
            c?(error: e)
            
            return false
            
        }
        
        var loc = ""
        var successCode = 201
        var method = Method.POST
        
        if let i = id {
            
            loc = "/\(i)"
            successCode = 200
            method = .PUT
            
        }
        
        var _item: [String:AnyObject] = [
            "game_id": sequence.game.id!,
            "sequence_id": sequence.id!,
            "key": key.string,
            "player_a": player_a,
            "created_at": dbDate.stringFromDate(created_at)
        ]
        
        if let i = team {
            
            if i.id == nil {
                
                var e = NSError(domain: "Team must be saved remotely first : \(i.id)", code: 0, userInfo: nil)
                JP2(e)
                c?(error: e)
                
                return false
                
            }
            
            _item["team_id"] = i.id!
            
        }
        if let x = endX { _item["end_x"] = x.spot }
        if let x = endY { _item["end_y"] = x }
        if let n = player_b { _item["player_b"] = n }
        
        let _final = ["play": _item]
        
        let s = "\(domain)/api/v1/plays\(loc).json"
        
        Alamofire.request(method, s, parameters: _final, encoding: .JSON)
            .responseJSON { request, response, data, error in
                
                var e: NSError?
                
                if error == nil {
                    
                    if response?.statusCode == successCode {
                        
                        var json = JSON(data!)
                        
                        self.id = json["play"]["id"].intValue
                        self.save(nil)
                        
                    } else {
                        
                        JP2("Status Code Error: \(response?.statusCode)")
                        JP2(_final)
                        JP2(request)
                        
                        e = NSError(domain: "Bad status code", code: 99, userInfo: nil)
                        
                    }
                    
                } else {
                    
                    JP2("Error!")
                    JP2(_final)
                    JP2(error)
                    JP2(request)
                    
                    e = error
                    
                }
                
                c?(error: e)
                
        }
        
        return true
        
    }
    
}

extension Play {
    
    func serialize() -> [String:AnyObject] {
        
        var final: [String:AnyObject] = [
            "qtr": object.sequence.qtr,
            "key": key.string,
            "playtype": object.sequence.key
        ]
        
        if let d = object.sequence.down { final["down"] = d.toInt()! }
        if let d = object.sequence.fd {
            
            final["fd"] = d.toInt()!
            
            var los = object.sequence.startX.toInt()!
            var fd2 = d.toInt()!
            
            final["togo"] = fd2 - los
            
        }
        if let x = endX { final["endX"] = x.spot }
        if let y = endY { final["endY"] = y }
        
        return final
        
    }
    
}