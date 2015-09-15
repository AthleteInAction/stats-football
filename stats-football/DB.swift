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
    class sequences {
        
        // CORE DATA (LOCAL)
        // LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
        // LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
        class local {
            
            // FIND
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            static func find(game: Game,completion: (s: Bool,items: [Sequence]) -> Void){
                
                var error: NSError?
                
                var request = NSFetchRequest(entityName: "Sequences")
                
                let p = NSPredicate(format: "game in %@", argumentArray: [game.object!])
                
                request.predicate = p
                
                var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                var context: NSManagedObjectContext = appDel.managedObjectContext!
                var results: NSArray = context.executeFetchRequest(request, error: &error)!
                
                if let e = error {
                    
                    println("ERROR:")
                    println(e)
                    
                    completion(s: false,items: [])
                    
                } else {
                    
                    var tmp: [Sequence] = []
                    
                    for team in results {
                        
                        let t = team as! SequenceObject
                        t.game = game.object!
                        
                        let final = Sequence(sequence: t)
                        
                        tmp.append(final)
                        
                    }
                    
                    completion(s: true,items: tmp)
                    
                }
                
            }
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            
            
            // GET
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            static func get(completion: (s: Bool,items: [Sequence]) -> Void){
                
                var request = NSFetchRequest(entityName: "Sequences")
                
                var error: NSError?
                
                var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                var context: NSManagedObjectContext = appDel.managedObjectContext!
                var results: NSArray = context.executeFetchRequest(request, error: &error)!
                
                if let e = error {
                    
                    println("ERROR:")
                    println(e)
                    
                    completion(s: false,items: [])
                    
                } else {
                    
                    var tmp: [Sequence] = []
                    
                    for team in results {
                        
                        let t = team as! SequenceObject
                        
                        let final = Sequence(sequence: t)
                        
                        tmp.append(final)
                        
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
    
    
    
    // TEAMS
    // ============================================================================================================
    // ============================================================================================================
    class teams {
        
        // CORE DATA (LOCAL)
        // LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
        // LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
        class local {
            
            static func create(name _name: String,short _short: String,completion: (s: Bool,team: TeamObject) -> Void){
                
                var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                var context: NSManagedObjectContext = appDel.managedObjectContext!
                var entity = NSEntityDescription.entityForName("Teams", inManagedObjectContext: context)
                var item = TeamObject(entity: entity!, insertIntoManagedObjectContext: context)
                
                item.name = _name
                item.short = _short
                
                var error: NSError?
                
                context.save(&error)
                
                if let e = error {
                    
                    println("Error!")
                    println(e)
                    completion(s: false, team: item)
                    
                } else {
                    
                    completion(s: true, team: item)
                    
                }
                
            }
            
            // GET
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            static func get(completion: (s: Bool,items: [Team]) -> Void){
                
                var request = NSFetchRequest(entityName: "Teams")
                
                var error: NSError?
                
                var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                var context: NSManagedObjectContext = appDel.managedObjectContext!
                var results: NSArray = context.executeFetchRequest(request, error: &error)!
                
                if let e = error {
                    
                    println("ERROR:")
                    println(e)
                    
                    completion(s: false,items: [])
                    
                } else {
                    
                    var tmp: [Team] = []
                    
                    for team in results {
                        
                        let t = team as! TeamObject
                        
                        let final = Team(team: t)
                        
                        tmp.append(final)
                        
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
    
    
    
    // GAMES
    // ============================================================================================================
    // ============================================================================================================
    class games {
        
        // CORE DATA (LOCAL)
        // LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
        // LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
        class local {
            
            static func create(away _away: Team,home _home: Team,completion: (s: Bool,game: Game?) -> Void){
                
                var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                var context: NSManagedObjectContext = appDel.managedObjectContext!
                var entity = NSEntityDescription.entityForName("Games", inManagedObjectContext: context)
                var item = GameObject(entity: entity!, insertIntoManagedObjectContext: context)
                
                item.away = _away.object
                item.home = _home.object
                
                var error: NSError?
                
                context.save(&error)
                
                if let e = error {
                    
                    println("Error!")
                    println(e)
                    completion(s: false, game: nil)
                    
                } else {
                    
                    let final = Game(game: item)
                    completion(s: true, game: final)
                    
                }
                
            }
            
            // GET
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            static func get(completion: (s: Bool,games: [Game]) -> Void){
                
                var request = NSFetchRequest(entityName: "Games")
                
                var error: NSError?
                
                var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                var context: NSManagedObjectContext = appDel.managedObjectContext!
                var results: NSArray = context.executeFetchRequest(request, error: &error)!
                
                if let e = error {
                    
                    println("ERROR:")
                    println(e)
                    
                    completion(s: false,games: [])
                    
                } else {
                    
                    var tmp: [Game] = []
                    
                    for game in results {
                        
                        println(game.home.name)
                        let t = game as! GameObject
                        
                        let final = Game(game: t)
                        
                        tmp.append(final)
                        
                    }
                    
                    completion(s: true,games: tmp)
                    
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
