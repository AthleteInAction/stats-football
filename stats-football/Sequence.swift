//
//  Sequence.swift
//  stats-football
//
//  Created by grobinson on 8/27/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit

class Sequence {
    
    var pos_id: Int!
    var qtr: Int!
    var key: String!
    var down: Int?
    var fd: Int?
    var startX: Int!
    var startY: Int = 50
    var replay: Bool = false
    var plays: [Play] = []
    
    init(){
        
        
        
    }
    
}


class Play {
    
    var key: String!
    var endX: Int?
    var endY: Int?
    var player_a: Int!
    var player_b: Int?
    var penaltyKey: String?
    var penaltyDistance: Int?
    var pos_id: Int?
    var score: Int?
    var touchback: Bool = false
    var tackles: [Int] = []
    var sacks: [Int] = []
    
    init(){
        
        
        
    }
    
}