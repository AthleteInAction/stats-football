//
//  Filters.swift
//  stats-football
//
//  Created by grobinson on 9/9/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class Filters {
    
    static func colors(key: String,alpha: CGFloat) -> UIColor {
        
        switch key {
        case "run","return":
            
            return UIColor(red: 57/255, green: 140/255, blue: 183/255, alpha: alpha)
            
        case "pass":
            
            return UIColor(red: 127/255, green: 255/255, blue: 155/255, alpha: alpha)
            
        case "kick","punt":
            
            return UIColor(red: 255/255, green: 120/255, blue: 0, alpha: alpha)
            
        case "penalty":
            
            return UIColor(red: 255/255, green: 228/255, blue: 0, alpha: alpha)
            
        case "interception":
            
            return UIColor(red: 255/255, green: 47/255, blue: 47/255, alpha: alpha)
            
        case "lateral":
            
            return UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: alpha)
            
        case "fumble":
            
            return UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: alpha)
            
        default:
            
            return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: alpha)
            
        }
        
    }
    static func textColors(key: String,alpha: CGFloat) -> UIColor {
        
        switch key {
        case "pass":
            
            return UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: alpha)
            
        default:
            
            return UIColor.whiteColor()
            
        }
        
    }
    
    static func keys(sequence: Sequence,type: String) -> [String] {
        
        // PENALTIES
        // ============================================================
        // ============================================================
        switch type {
        case "penalty_type":
            
            return ["holding","facemask","offside","personal foul"]
            
        case "penalty_distance":
            
            return ["5","10","15"]
            
        case "penalty_options":
            
            return ["spot","declined","offset","kick"]
            
        default:
            
            ()
            
        }
        // ============================================================
        // ============================================================
        
        
        // KEYS
        // ============================================================
        // ============================================================
        switch sequence.key {
        case "kickoff":
            
            if sequence.plays.count == 0 {
                
                return ["kick"]
                
            } else {
                
                return ["return","lateral"]
                
            }
            
        case "down","pat":
            
            return ["run","pass","incomplete","interception","punt","lateral","field goal attempted","field goal made","block","recovery"]
            
        default:
            
            return []
            
        }
        // ============================================================
        // ============================================================
        
    }
    
    func sentence(penalty: Penalty) -> String {
        
        var final: String!
        
        switch penalty.distance {
        default:
            
            final = "\(penalty.distance) yard Penalty"
            
        }
        
        return final
        
    }
    
}