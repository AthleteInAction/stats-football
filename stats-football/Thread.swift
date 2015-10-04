//
//  Thread.swift
//  stats-football
//
//  Created by grobinson on 10/4/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import Foundation

class Rhino {
    
    static func run(block: Void -> Void,completion: () -> Void){
        
        let queue = NSOperationQueue()
        
        queue.addOperationWithBlock() {
            
            block()
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                
                completion()
                
            }
            
        }
        
    }
    
}