//
//  TrackerMPC.swift
//  stats-football
//
//  Created by grobinson on 10/1/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit
import MultipeerConnectivity

extension Tracker: MPCManagerReceiver,MPCManagerStateChanged {
    
    func receiveGame(game: [String : AnyObject]) {
        
        
        
    }
    
    func stateChanged(state: MCSessionState) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            
            if state == .Connected { self.MPC.sendGame(self.game) }
            
        }
    }
    
    func peersChanged() {
        
        
        
    }
    
}