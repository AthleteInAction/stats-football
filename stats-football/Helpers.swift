//
//  Helpers.swift
//  stats-football
//
//  Created by grobinson on 9/27/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit

extension String {
    
    var toPlaytype: Playtype {
        
        switch self {
        case "kickoff": return .Kickoff
        case "freekick": return .Freekick
        case "pat": return .PAT
        default: return .Down
        }
        
    }
    
}


extension Int {
    
    func toP() -> CGFloat {
        
        return CGFloat(self) / 100
        
    }
    
}