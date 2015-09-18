//
//  PlayObject.swift
//  
//
//  Created by grobinson on 9/15/15.
//
//

import Foundation
import CoreData

@objc(PlayObject)
class PlayObject: NSManagedObject {

    @NSManaged var key: String
    @NSManaged var endX: String?
    @NSManaged var endY: String?
    @NSManaged var player_a: String
    @NSManaged var player_b: String?
    @NSManaged var team: TeamObject?
    @NSManaged var sequence: SequenceObject
    @NSManaged var created_at: NSDate

}