//
//  Summaries.swift
//  stats-football
//
//  Created by grobinson on 10/10/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

extension Game {
    
    // QTR BY QTR
    // ================================================================
    // ================================================================
    func qtrScoring() -> [Int] {
        
        var qtrs = [
            "1": true,
            "2": true,
            "3": true,
            "4": true
        ]
        
        var awayScores: [Int] = []
        var homeScores: [Int] = []
        
        for _sequence in sequences { if qtrs[_sequence.qtr.string()] == nil { qtrs[_sequence.qtr.string()] = true } }
        
        for _qtr in qtrs {
            
            awayScores.append(0)
            homeScores.append(0)
            
        }
        
        for _sequence in sequences {
            
            let scores = Filters.score(_sequence)
            
            if scores[0] != .None { awayScores[_sequence.qtr-1] += scores[0].value }
            if scores[1] != .None { homeScores[_sequence.qtr-1] += scores[1].value }
            
        }
        
        return awayScores + homeScores
        
    }
    // ================================================================
    // ================================================================
    
    
    // SCORING SUMMARY
    // ================================================================
    // ================================================================
    func scoringSummary() -> [String:[[String:AnyObject]]] {
        
        var _final = [String:[[String:AnyObject]]]()
        
        for _sequence in reverse(sequences) {
            
            var _item = [String:AnyObject]()
            
            let scores = Filters.score(_sequence)
            
            var player_a: Int?
            var player_b: Int?
            var key: Key?
            
            if scores[0] != .None || scores[1] != .None {
                
                for _play in reverse(_sequence.plays) {
                    
                    if let x = _play.endX {
                        
                        key = _play.key
                        
                        player_a = _play.player_a
                        
                        if let b = _play.player_b {
                            
                            player_b = b
                            
                        }
                        
                        break
                        
                    }
                    
                }
                
            }
            
            var S: Scores?
            var team: Team!
            
            if scores[0] != .None {
                
                S = scores[0]
                team = away
                
            }
            
            if scores[1] != .None {
                
                S = scores[1]
                team = home
                
            }
            
            if let ss = S {
                
                _item["team"] = [
                    "name": team.name,
                    "short": team.short
                ]
                
                _item["type"] = ss.display
                _item["qtr"] = _sequence.qtr
                _item["time"] = _sequence.score_time
                
                if let k = key { _item["key"] = k.string }
                if let a = player_a { _item["player_a"] = player_a }
                if let b = player_b { _item["player_b"] = player_b }
                
                if player_a != nil || player_b != nil {
                    
                    let _stat = Stats.player(sequence: _sequence)
                    
                    if let stat = _stat.last {
                        
                        switch stat.key {
                        case "int_return","punt_return","kick_return":
                            _item["key"] = stat.key
                        default: ()
                        }
                        
                        if let v = stat.value {
                            
                            _item["gain"] = v
                            
                        }
                        
                    }
                    
                }
                
                if _final[_sequence.qtr.string()] == nil {
                    _final[_sequence.qtr.string()] = []
                }
                
                _final[_sequence.qtr.string()]!.append(_item)
                
            }
            
        }
        
        return _final
        
    }
    // ================================================================
    // ================================================================
    
    func sendSummary(email _email: String,completion: CoreDataCompletion?){
        
        var c = completion
        
        let qtr = qtrScoring()
        let scoring = scoringSummary()
        
        let _final: [String:AnyObject] = [
            "email": _email,
            "home": [
                "name": home.name,
                "short": home.short
            ],
            "away": [
                "name": away.name,
                "short": away.short
            ],
            "qtr": qtr,
            "scoring": scoring
        ]
        
        let s = domain + "/api/v1/summary.json"
        
        Alamofire.request(.POST, s, parameters: ["summary":_final], encoding: .JSON)
            .responseJSON { request, response, data, error in
                
                var e: NSError?
                
                if error == nil {
                    
                    if response?.statusCode == 200 {
                        
                        var json = JSON(data!)
                        
                        println(json)
                        
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
        
    }
    
}