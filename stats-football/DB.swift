//
//  DB.swift
//  stats-football
//
//  Created by grobinson on 9/10/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import Alamofire
import SwiftyJSON
import CoreData

class DB {
    
    // TEAMS
    // ============================================================================================================
    // ============================================================================================================
    class teams {
        
        // CORE DATA (LOCAL)
        // LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
        // LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
        class local {
            
            // GET
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            static func get(completion: (s: Bool,items: [Team]) -> Void){
                
                var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                var context: NSManagedObjectContext = appDel.managedObjectContext!
                
                var request = NSFetchRequest(entityName: "Teams")
                
                var error: NSError?
                
                var results: NSArray = context.executeFetchRequest(request, error: &error)!
                
                if let e = error {
                    
                    println("ERROR:")
                    println(e)
                    
                    completion(s: false,items: [])
                    
                } else {
                    
                    var tmp: [Team] = []
                    
                    for item in results {
                        
                        let o = item as! NSManagedObject
                        
                        let team = Team(item: o)
                        println(team.name)
                        println("ObjectID: \(o.objectID)")
                        tmp.append(team)
                        
                    }
                    
                    completion(s: true,items: tmp)
                    
                }
                
            }
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            
        }
        // LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
        // LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
        
    }
    // ============================================================================================================
    // ============================================================================================================
    
}
