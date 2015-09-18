//
//  PenaltyObject.swift
//  
//
//  Created by grobinson on 9/15/15.
//
//

import Foundation
import CoreData

@objc(PenaltyObject)
class PenaltyObject: NSManagedObject {

    @NSManaged var distance: String
    @NSManaged var endX: String?
    @NSManaged var enforcement: String
    @NSManaged var player: String?
    @NSManaged var sequence: SequenceObject
    @NSManaged var team: TeamObject
    @NSManaged var created_at: NSDate

}