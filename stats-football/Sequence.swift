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
    @NSManaged var score_time: String?
    @NSManaged var score: String
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
    var score_time: String = ""
    var score: Scores = .None
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
        if let st = sequence.score_time { score_time = st }
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
            
            JP("DELETE SEQUENCE ERROR!")
            JP(e)
            
        } else {
            
            JP("SEQUENCE DELETED!")
            
        }
        
        c?(error: error)
        
    }
    
    func scoreSave(completion: Completion?){
        
        JP2("SCORE SAVE")
        
        var c = completion
        
        let scores = Filters.score(self)
        
        score = .None
        
        if scores[0] != .None { score = scores[0] }
        if scores[1] != .None { score = scores[1] }
        
        save { (error) -> Void in
            
            c?(error: error)
            
        }
        
    }
    
    func save(completion: Completion?){
        
        JP2("SAVE")
        
        var c = completion
        
        var error: NSError?
        
        if let i = id { object.id = i.string() }
        object.created_at = created_at
        object.game = game.object
        object.key = key.string
        object.team = team.object
        object.qtr = qtr.string()
        if let d = down { object.down = d.string() } else { object.down = nil }
        if let f = fd { object.fd = f.spot.string() } else { object.fd = nil }
        object.score_time = score_time
        object.score = score.string
        object.startX = startX.spot.string()
        object.startY = startY.string()
        object.flagged = flagged.description
        object.replay = replay.description
        
        object.managedObjectContext?.save(&error)
        
        if let e = error {
            
            JP("SEQUENCE SAVE ERROR!")
            JP(e)
            
        } else {
            
            JP(object)
            
        }
        
        c?(error: error)
        
    }
    
    func getPlays(){
        
        JP("++++++++++ GET PLAYS START ++++++++++")
        var playObjects = object.plays.allObjects as! [PlayObject]
        
        plays = playObjects.map { o in
         
            let play = Play(play: o)
            
            return play
            
        }
        
        plays.sort({ $0.created_at.compare($1.created_at) == NSComparisonResult.OrderedAscending })
        JP("++++++++++ GET PLAYS END ++++++++++")
        
    }
    
    func getPenalties(){
        
        JP("++++++++++ GET PENALTIES START ++++++++++")
        var penaltyObjects = object.penalties.allObjects as! [PenaltyObject]
        
        penalties = penaltyObjects.map { o in
            
            let penalty = Penalty(penalty: o)
            
            return penalty
            
        }
        
        penalties.sort({ $0.created_at.compare($1.created_at) == NSComparisonResult.OrderedAscending })
        JP("++++++++++ GET PENALTIES END ++++++++++")
        
    }
    
    func remoteSave(completion: Completion?) -> Bool {
        
        var c = completion
        
        if game.id == nil {
            
            var e = NSError(domain: "Game must be saved remotely first : \(game.id)", code: 0, userInfo: nil)
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
                "game_id": game.id!,
                "team_id": team.id!,
                "qtr": qtr,
                "key": key.string,
                "start_x": startX.spot,
                "start_y": startY,
                "replay": replay,
                "flagged": flagged,
                "created_at": dbDate.stringFromDate(created_at)
        ]
        
        if let d = down { _item["down"] = d }
        if let d = fd { _item["fd"] = d.spot }
        
        let _final = ["sequence": _item]
        
        let s = "\(domain)/api/v1/sequences\(loc).json"
        
        Alamofire.request(method, s, parameters: _final, encoding: .JSON)
            .responseJSON { request, response, data, error in
                
                var e: NSError?
                
                if error == nil {
                    
                    if response?.statusCode == successCode {
                        
                        var json = JSON(data!)
                        
                        self.id = json["sequence"]["id"].intValue
                        self.save(nil)
                        
                    } else {
                        
                        JP2("Status Code Error: \(response?.statusCode)")
                        JP2(request)
                        
                        e = NSError(domain: "Bad status code", code: 99, userInfo: nil)
                        
                    }
                    
                } else {
                    
                    JP2("Error!")
                    JP2(error)
                    JP2(request)
                    
                    e = error
                    
                }
                
                c?(error: e)
                
        }
        
        return true
        
    }
    
}

extension String {
    
    func toBool() -> Bool { return self == "true" }
    
}