// ========================================================
// ========================================================
//  Play.swift
//  stats-football
//
//  Created by grobinson on 9/14/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import Foundation
// ========================================================
// ========================================================
class Setting {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var key: String!
    var value: AnyObject!
    
    init(key _key: String){
        
        key = _key
        
        if let item: AnyObject = defaults.valueForKey(_key) {
            
            value = item
            
        } else {
            
            // DEFAULT VALUES
            switch _key {
            case "kickoff_yardline": value = 40
            case "touchback_yardline": value = 20
            default: value = ""
            }
            
            setValue(value)
            
        }
        
    }
    
    func setValue(item: AnyObject){
        
        value = item
        
        defaults.setObject(item, forKey: key)
        
    }
    
    func string() -> String { return value as! String }
    func int() -> Int { return value as! Int }
    func bool() -> Bool { return value as! Bool }
    
}
// ========================================================
// ========================================================