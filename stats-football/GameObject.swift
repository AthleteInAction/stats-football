//
//  GameObject.swift
//  
//
//  Created by grobinson on 9/15/15.
//
//

import Foundation
import CoreData

@objc(GameObject)
class GameObject: NSManagedObject {
    
    @NSManaged var away: TeamObject
    @NSManaged var home: TeamObject
    @NSManaged var sequences: NSSet
    
}
