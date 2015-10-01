//
//  Filters.swift
//  stats-football
//
//  Created by grobinson on 9/9/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class Filters {
    
    static func colors(key: Key,alpha: CGFloat) -> UIColor {
        
        switch key as Key {
        case .Run,.Return:
            
            return UIColor(red: 57/255, green: 140/255, blue: 183/255, alpha: alpha)
            
        case .Pass:
            
            return UIColor(red: 127/255, green: 255/255, blue: 155/255, alpha: alpha)
            
        case .Kick,.Punt:
            
            return UIColor(red: 255/255, green: 120/255, blue: 0, alpha: alpha)
            
        case .Penalty:
            
            return UIColor(red: 255/255, green: 228/255, blue: 0, alpha: alpha)
            
        case .Interception:
            
            return UIColor(red: 255/255, green: 47/255, blue: 47/255, alpha: alpha)
            
        case .Lateral:
            
            return UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: alpha)
            
        case .Fumble:
            
            return UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: alpha)
            
        default:
            
            return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: alpha)
            
        }
        
    }
    static func textColors(key: Key,alpha: CGFloat) -> UIColor {
        
        switch key as Key {
        case .Pass:
            
            return UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: alpha)
            
        default:
            
            return UIColor.whiteColor()
            
        }
        
    }
    
    static func keys(sequence: Sequence,type: String) -> [Key] {
        
        // PENALTIES
        // ============================================================
        // ============================================================
        switch type {
        case "penalty_distance":
            
            return [.Five,.Ten,.Fifteen]
            
        case "penalty_options":
            
            return [.PreviousSpot,.SpotOfFoul,.DeadBallSpot]
            
        case "penalty_enforcement":
            
            return [.Spot,.Declined,.Offset,.OnKick]
            
        default:
            
            ()
            
        }
        // ============================================================
        // ============================================================
        
        
        // KEYS
        // ============================================================
        // ============================================================
        var prev: Play?
        for play in sequence.plays { prev = play }
        switch sequence.key as Playtype {
        case .Kickoff:
            
            if let play = prev {
                
                return [.Return,.Lateral]
                
            } else {
                
                return [.Kick]
                
            }
            
        case .Down,.PAT:
            
            if let play = prev {
                
                switch play.key as Key {
                case .Interception,.Punt: return [.Return,.Lateral]
                default: return [.Run,.Lateral]
                }
                
            } else {
                
                return [.Run,.Pass,.Incomplete,.Interception,.Punt,.FGA,.FGM]
                
            }
            
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