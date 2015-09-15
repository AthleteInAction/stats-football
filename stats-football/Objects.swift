//
//  Team.swift
//  stats-football
//
//  Created by grobinson on 9/7/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import SwiftyJSON
import CoreData

@objc(PenaltyObject)
class PenaltyObject: NSManagedObject {
    
    @NSManaged var sequence: SequenceObject
    @NSManaged var team: TeamObject
    @NSManaged var distance: NSString
    @NSManaged var endX: NSString?
    @NSManaged var enforcement: NSString?
    @NSManaged var player: NSString?
    
}

@objc(PlayerObject)
class PlayerObject: NSManagedObject {
    
    @NSManaged var team: TeamObject
    @NSManaged var number: NSString
    @NSManaged var first_name: NSString?
    @NSManaged var last_name: NSString?
    
}

class Penalty {
    
    var id: Int?
    var game_id: Int!
    var sequence_id: Int64!
    var pos_id: Int!
    var distance: Int!
    var endX: Int?
    var enforcement: String?
    var player: Int?
    
    init(){
        
        
        
    }
    
}

class Player {
    
    var number: Int!
    var used: Int = 0
    
    init(n: Int){
        
        number = n
        
    }
    
}