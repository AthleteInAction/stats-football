//
//  SequenceObject.swift
//  
//
//  Created by grobinson on 9/15/15.
//
//

import Foundation
import CoreData

@objc(SequenceObject)
class SequenceObject: NSManagedObject {
    
    @NSManaged var qtr: String
    @NSManaged var key: String
    @NSManaged var down: String?
    @NSManaged var fd: String?
    @NSManaged var startX: String
    @NSManaged var startY: String
    @NSManaged var replay: Bool
    @NSManaged var game: GameObject
    @NSManaged var team: TeamObject
    @NSManaged var plays: NSSet
    @NSManaged var penalties: NSSet
    @NSManaged var created_at: NSDate
    
}