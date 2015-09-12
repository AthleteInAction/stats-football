//
//  Sequence.swift
//  stats-football
//
//  Created by grobinson on 8/27/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

class Sequence {
    
    var id: Int?
    var game_id: Int!
    var pos_id: Int!
    var qtr: Int!
    var key: String!
    var down: Int?
    var fd: Int?
    var startX: Int!
    var startY: Int = 50
    var replay: Bool = false
    var plays: [Play] = []
    var ind = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    init(){
        
        ind.hidesWhenStopped = true
        ind.stopAnimating()
        
    }
    
    func save(completion: (s: Bool) -> Void){
        
//        ind.startAnimating()
//        
//        if let ID = id {
//            
//            println("UPDATE")
//            
//            let s = "\(domain)/api/v1/sequences/\(ID).json"
//            
//            var sequence: JSON = [
//                "sequence":[
//                    "game_id": game_id,
//                    "pos_id": pos_id,
//                    "key": key,
//                    "qtr": qtr,
//                    "start_x": startX,
//                    "start_y": startY,
//                    "replay": replay
//                ]
//            ]
//            
//            if let d = down { sequence["sequence"]["down"].intValue = d }
//            if let d = fd { sequence["sequence"]["fd"].intValue = d }
//            
//            println(sequence)
//            
//            Alamofire.request(.PUT, s, parameters: sequence.dictionaryObject, encoding: .JSON)
//                .responseJSON { (request, response, data, error) in
//                    
//                    if error == nil {
//                        
//                        if response?.statusCode == 200 {
//                            
//                            var json = JSON(data!)
//                            
//                        } else {
//                            
//                            println("Status Code Error: \(response?.statusCode)")
//                            println(request)
//                            
//                        }
//                        
//                    } else {
//                        
//                        println("Error!")
//                        println(error)
//                        println(request)
//                        
//                    }
//                    
//                    completion(s: (error == nil))
//                    self.ind.stopAnimating()
//                    
//            }
//            
//        } else {
//            
//            println("NEW")
//            
//            let s = "\(domain)/api/v1/sequences.json"
//            
//            var pp: [JSON] = []
//            
//            for play in plays {
//                
//                var o: JSON = [
//                    "key": play.key,
//                    "player_a": play.player_a,
//                    "penaltyOffset": play.penaltyOffset,
//                    "tackles": [],
//                    "sacks": []
//                ]
//                
//                if let v = play.endX { o["end_x"].intValue = v }
//                if let v = play.endY { o["end_y"].intValue = v }
//                if let v = play.player_b { o["player_b"].intValue = v }
//                if let v = play.penaltyKey { o["penaltyKey"].stringValue = v }
//                if let v = play.penaltyDistance { o["penaltyDistance"].intValue = v }
//                if let v = play.pos_id { o["pos_id"].intValue = v }
//                
//                pp.append(o)
//                
//            }
//            
//            var sequence: JSON = [
//                "sequence":[
//                "game_id": game_id,
//                "pos_id": pos_id,
//                "key": key,
//                "qtr": qtr,
//                "start_x": startX,
//                "start_y": startY,
//                "replay": replay,
//                "plays": pp
//                ]
//            ]
//            
//            if let d = down { sequence["sequence"]["down"].intValue = d }
//            if let d = fd { sequence["sequence"]["fd"].intValue = d }
//            
//            println(sequence)
//            
//            Alamofire.request(.POST, s, parameters: sequence.dictionaryObject, encoding: .JSON)
//                .responseJSON { (request, response, data, error) in
//                    
//                    if error == nil {
//                        
//                        if response?.statusCode == 201 {
//                            
//                            var json = JSON(data!)
//                            
//                            self.id = json["sequence"]["id"].intValue
//                            
//                        } else {
//                            
//                            println("Status Code Error: \(response?.statusCode)")
//                            println(request)
//                            
//                        }
//                        
//                    } else {
//                        
//                        println("Error!")
//                        println(error)
//                        println(request)
//                        
//                    }
//                    
//                    completion(s: (error == nil))
//                    self.ind.stopAnimating()
//                    
//            }
//            
//        }
        
    }
    
}


class Play {
    
    var id: Int?
    var key: String!
    var endX: Int?
    var endY: Int?
    var player_a: Int!
    var player_b: Int?
    var penaltyKey: String?
    var penaltyDistance: Int?
    var penaltyOffset: Bool = false
    var pos_id: Int?
    var tackles: [Int] = []
    var sacks: [Int] = []
    
    init(){
        
        
        
    }
    
}

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}