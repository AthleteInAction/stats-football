//
//  Settings.swift
//  stats-football
//
//  Created by grobinson on 10/2/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit

class Settings {
    
    var runSections: [Int] = [29,43,57,71,100]
    var passSections: [Int] = [20,40,60,80,100]
    
    func sectionSize(pct _pct: CGFloat,height _height: CGFloat,sections _sections: [Int]) -> [CGFloat] {
        
        JP(_pct)
        
        switch _pct {
        case _sections[0].percent() ... _sections[1].percent():
            
            let height = (_sections[1].percent() - _sections[0].percent()) * _height
            
            return [_sections[0].percent() * _height,height]
            
        case _sections[1].percent() ... _sections[2].percent():
            
            let height = (_sections[2].percent() - _sections[1].percent()) * _height
            
            return [_sections[1].percent() * _height,height]
            
        case _sections[2].percent() ... _sections[3].percent():
            
            let height = (_sections[3].percent() - _sections[2].percent()) * _height
            
            return [_sections[2].percent() * _height,height]
            
        case _sections[3].percent() ... _sections[4].percent():
            
            let height = (_sections[4].percent() - _sections[3].percent()) * _height
            
            return [_sections[3].percent() * _height,height]
            
        default:
            
            return [0,(_sections[0].percent()*_height)]
            
        }
        
    }
    
}

extension Int {
    
    func percent() -> CGFloat {
        
        return CGFloat(self) / 100
        
    }
    
}