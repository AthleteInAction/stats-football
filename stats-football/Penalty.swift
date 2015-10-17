// ========================================================
// ========================================================
//  Penalty.swift
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
@objc(PenaltyObject)
class PenaltyObject: NSManagedObject {
    
    @NSManaged var id: String?
    @NSManaged var distance: String
    @NSManaged var endX: String?
    @NSManaged var endY: String?
    @NSManaged var enforcement: String
    @NSManaged var fd: Bool
    @NSManaged var replay: Bool
    @NSManaged var player: String?
    @NSManaged var sequence: SequenceObject
    @NSManaged var team: TeamObject
    @NSManaged var created_at: NSDate
    
}
// ========================================================
// ========================================================
class Penalty {
    
    // PROPERTIES
    // --------------------------------------
    // --------------------------------------
    var id: Int?
    var team: Team!
    var distance: Int!
    var endX: Yardline?
    var endY: Int?
    var enforcement: Key!
    var fd: Bool = false
    var replay: Bool = false
    var player: Int?
    var created_at: NSDate!
    var object: PenaltyObject!
    
    private var sequence: SequenceObject!
    // --------------------------------------
    // --------------------------------------
    
    
    // INIT
    // iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
    // iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
    init(s: Sequence){
        
        var entity = NSEntityDescription.entityForName("Penalties", inManagedObjectContext: context)
        var o = PenaltyObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        object = o
        sequence = s.object
        endY = 50
        created_at = NSDate()
        
    }
    init(penalty: PenaltyObject){
        
        distance = penalty.distance.toInt()!
        if let x = penalty.endX { endX = Yardline(spot: x.toInt()!) }
        enforcement = penalty.enforcement.toKey()
        if let p = penalty.player { player = p.toInt()! }
        team = Team(team: penalty.team)
        created_at = penalty.created_at
        sequence = penalty.sequence
        object = penalty
        
        replay = penalty.replay
        fd = penalty.fd
        if let y = penalty.endY { endY = y.toInt()! } else { endY = 50 }
        
    }
    // iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
    // iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
    
    
    // SAVE
    // ++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++
    func save(completion: CoreDataCompletion?){
        
        var done = completion
        var error: NSError?
        
        if let i = id { object.id = i.string() }
        object.sequence = sequence
        object.created_at = created_at
        object.distance = distance.string()
        if let x = endX { object.endX = x.spot.string() } else { object.endX = nil }
        object.enforcement = enforcement.string
        if let p = player { object.player = p.string() } else { object.player = nil }
        object.team = team.object
        
        object.replay = replay
        object.fd = fd
        if let y = endY { object.endY = y.string() }
        
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            JP("PENALTY SAVE ERROR!")
            JP(e)
            
        } else {
            
            JP(object)
            JP("PENALTY SAVED!")
            
        }
        
        done?(error: error)
    
    }
    // ++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++
    
    
    // DELETE
    // --------------------------------------
    // --------------------------------------
    func delete(completion: CoreDataCompletion?){
        
        var done = completion
        
        var error: NSError?
        
        object.managedObjectContext?.deleteObject(object)
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            JP("DELETE PENALTY ERROR!")
            JP(e)
            
        } else {
            
            JP("PENALTY DELETED!")
            
        }
        
        done?(error: error)
        
    }
    // --------------------------------------
    // --------------------------------------
    
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
        
        if team.id == nil {
            
            var e = NSError(domain: "Team must be saved remotely first : \(team.id)", code: 0, userInfo: nil)
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
            "team_id": team.id!,
            "distance": distance,
            "enforcement": enforcement.string,
            "created_at": dbDate.stringFromDate(created_at)
        ]
        
        if let x = endX { _item["end_x"] = x.spot }
        if let p = player { _item["player"] = p }
        
        let _final = ["penalty": _item]
        
        let s = "\(domain)/api/v1/penaltys\(loc).json"
        
        Alamofire.request(method, s, parameters: _final, encoding: .JSON)
            .responseJSON { request, response, data, error in
                
                var e: NSError?
                
                if error == nil {
                    
                    if response?.statusCode == successCode {
                        
                        var json = JSON(data!)
                        
                        self.id = json["penalty"]["id"].intValue
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
// ========================================================
// ========================================================

extension Int {
    
    func string() -> String { return "\(self)" }
    
}