//
//  Yardline.swift
//  stats-football
//
//  Created by grobinson on 9/27/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit

class Yardline {
    
    var spot: Int!
    
    init(spot _spot: Int){ spot = _spot }
    
    init(x _x: CGFloat,pos_right _pos_right: Bool){
        
        spot = Int(round(_x / ratio)) - 10
        
        if _pos_right { spot = 100 - spot }
        
    }
    
    func toShort() -> Int {
        
        switch spot {
        case 51...99:
            
            return 100 - spot
            
        default:
            
            return spot
            
        }
        
    }
    
    func toX(right: Bool) -> CGFloat {
        
        var final = spot + 10
        
        if right { final = 120 - final }
        
        return CGFloat(final) * ratio
        
    }
    
    func increment(i: Int) -> Yardline {
        
        var s = spot
        
        s = s + i
        
        if s > 99 { s = 100 }
        if s < 1 { s = 0 }
        
        return Yardline(spot: s)
        
    }
    
    func penaltyPlus(distance: Int) -> Yardline {
        
        var s = spot
        
        let half = 100 - distance * 2
        
        if s > half {
            
            let dtg = 100 - s
            
            s = 100 - (dtg / 2)
            
        } else {
            
            s = s + distance
            
        }
        
        return Yardline(spot: s)
        
    }
    
    func penaltyMinus(distance: Int) -> Yardline {
        
        var s = spot
        
        let half = distance * 2
        
        if s < half {
            
            s = s / 2
            
        } else {
            
            s = s - distance
            
        }
        
        return Yardline(spot: s)
        
    }
    
    func opposite() -> Yardline {
        
        let s = 100 - spot
        
        return Yardline(spot: s)
        
    }
    
}