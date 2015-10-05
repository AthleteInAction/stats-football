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
    
    // SEQUENCES
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
                
                var results: NSArray = context.executeFetchRequest(request, error: &error)!
                
                if let e = error {
                    
                    JP("ERROR:")
                    JP(e)
                    
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
                
                var results: NSArray = context.executeFetchRequest(request, error: &error)!
                
                if let e = error {
                    
                    JP("ERROR:")
                    JP(e)
                    
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
                
                var entity = NSEntityDescription.entityForName("Teams", inManagedObjectContext: context)
                var item = TeamObject(entity: entity!, insertIntoManagedObjectContext: context)
                
                item.name = _name
                item.short = _short
                
                var error: NSError?
                
                context.save(&error)
                
                if let e = error {
                    
                    JP("Error!")
                    JP(e)
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
                
                var results: NSArray = context.executeFetchRequest(request, error: &error)!
                
                if let e = error {
                    
                    JP("ERROR:")
                    JP(e)
                    
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
                
                var entity = NSEntityDescription.entityForName("Games", inManagedObjectContext: context)
                var item = GameObject(entity: entity!, insertIntoManagedObjectContext: context)
                
                item.away = _away.object
                item.home = _home.object
                
                var error: NSError?
                
                context.save(&error)
                
                if let e = error {
                    
                    JP("Error!")
                    JP(e)
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
                
                var results: NSArray = context.executeFetchRequest(request, error: &error)!
                
                if let e = error {
                    
                    JP("ERROR:")
                    JP(e)
                    
                    completion(s: false,games: [])
                    
                } else {
                    
                    var tmp: [Game] = []
                    
                    for game in results {
                        
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
    
    
    // PLAYS
    // ============================================================================================================
    // ============================================================================================================
    class plays {
        
        // CORE DATA (LOCAL)
        // LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
        // LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
        class local {
            
            
            // GET
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            static func get(completion: (s: Bool,items: [PlayObject]) -> Void){
                
                var request = NSFetchRequest(entityName: "Plays")
                
                var error: NSError?
                
                var results: NSArray = context.executeFetchRequest(request, error: &error)!
                
                if let e = error {
                    
                    JP("ERROR:")
                    JP(e)
                    
                    completion(s: false,items: [])
                    
                } else {
                    
                    var tmp: [PlayObject] = []
                    
                    for team in results {
                        
                        let t = team as! PlayObject
                        
                        tmp.append(t)
                        
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
    
    
    // PENALTIES
    // ============================================================================================================
    // ============================================================================================================
    class penalties {
        
        // CORE DATA (LOCAL)
        // LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
        // LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
        class local {
            
            // FIND
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            static func find(penalty: Penalty,completion: (s: Bool,items: [Penalty]) -> Void){
                
                var error: NSError?
                
                var request = NSFetchRequest(entityName: "Penalties")
                
                let p = NSPredicate(format: "game in %@", argumentArray: [penalty.object!])
                
                request.predicate = p
                
                var results: NSArray = context.executeFetchRequest(request, error: &error)!
                
                if let e = error {
                    
                    JP("ERROR:")
                    JP(e)
                    
                    completion(s: false,items: [])
                    
                } else {
                    
                    var tmp: [Penalty] = []
                    
                    for team in results {
                        
                        let t = team as! PenaltyObject
                        
                    }
                    
                    completion(s: true,items: tmp)
                    
                }
                
            }
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            
            
            // GET
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            static func get(completion: (s: Bool,items: [Penalty]) -> Void){
                
                var request = NSFetchRequest(entityName: "Penalties")
                
                var error: NSError?
                
                var results: NSArray = context.executeFetchRequest(request, error: &error)!
                
                if let e = error {
                    
                    JP("ERROR:")
                    JP(e)
                    
                    completion(s: false,items: [])
                    
                } else {
                    
                    var tmp: [Penalty] = []
                    
                    for team in results {
                        
                        let t = team as! PenaltyObject
                        
                        let final = Penalty(penalty: t)
                        
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
    
}
