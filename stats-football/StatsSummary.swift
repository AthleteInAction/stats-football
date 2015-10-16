//
//  StatsSummary.swift
//  stats-football
//
//  Created by grobinson on 10/13/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension Game {
    
    func sendStats(team _team: Team,email _email: String,completion: CoreDataCompletion?){
        
        var c = completion
        
        let _final = [
            "email": _email,
            "away": [
                "name": away.name,
                "short": away.short
            ],
            "home": [
                "name": home.name,
                "short": home.name
            ],
            "team": [
                "name": _team.name,
                "short": _team.short
            ],
            "team_passing": _team.teamPassing.serialize(),
            "passing": _team.passing.map { t in return t.serialize() },
            "team_rushing": _team.teamRushing.serialize(),
            "rushing": _team.rushing.map { t in return t.serialize() },
            "team_receiving": _team.teamReceiving.serialize(),
            "receiving": _team.receiving.map { t in return t.serialize() },
            "team_kick_returns": _team.teamKickReturns.serialize(),
            "kick_returns": _team.kickReturns.map { t in return t.serialize() },
            "team_punt_returns": _team.teamPuntReturns.serialize(),
            "punt_returns": _team.puntReturns.map { t in return t.serialize() }
        ]
        
        let s = domain + "/api/v1/stats.json"
        
        Alamofire.request(.POST, s, parameters: ["stats":_final], encoding: .JSON)
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