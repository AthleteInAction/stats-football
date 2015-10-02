//
//  DataDisplay.swift
//  stats-football
//
//  Created by grobinson on 9/20/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class DataDisplay: UIViewController,MPCManagerReceiver,MPCManagerStateChanged {
    
    var MPC = MPCManager()
    
    var peerPicker: PeerPicker!
    
    var connect: UIBarButtonItem!
    var disconnect: UIBarButtonItem!
    var ai: UIActivityIndicatorView!
    var at: UIView!
    
    var game: [String:AnyObject] = [
        "home": [
            "name":"",
            "short":"",
            "plays": []
        ],
        "away": [
            "name":"",
            "short":"",
            "plays": []
        ]
    ]
    
    @IBOutlet weak var runVIEW: SectionView!
    @IBOutlet weak var passVIEW: SectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MPC.receiver = self
        MPC.stateMonitor = self
        MPC.startBrowsing()
        
        var close = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "closeTPD:")
        navigationItem.setLeftBarButtonItem(close, animated: true)
        
        connect = UIBarButtonItem(title: "Connect", style: UIBarButtonItemStyle.Plain, target: self, action: "connectTPD:")
        navigationItem.setRightBarButtonItem(connect, animated: true)
        
        disconnect = UIBarButtonItem(title: "Disconnect", style: UIBarButtonItemStyle.Plain, target: self, action: "disconnectTPD:")
        
        peerPicker = PeerPicker(nibName: "PeerPicker",bundle: nil)
        peerPicker.dataDisplay = self
        
        ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        ai.startAnimating()
        
        title = "Not Connected"
        
        at = navigationItem.titleView
        
        runVIEW.type = .Run
        runVIEW.sections = settings.runSections
        
        passVIEW.type = .Pass
        passVIEW.sections = settings.passSections
        
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    func receiveGame(_game: [String : AnyObject]) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            
            JP("GAME RECEIVED")
            JP(_game)
            self.game = _game
            self.setData()
            
        }
    }
    
    func stateChanged(_state: MCSessionState) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            
            JP("STATE CHANGED")
            
            switch _state {
            case .Connecting:
                
                self.navigationItem.titleView = self.ai
                
            case .Connected:
                
                self.navigationItem.titleView = self.at
                self.title = _state.stringValue()
                self.peerPicker.dismissViewControllerAnimated(true, completion: nil)
                self.navigationItem.setRightBarButtonItem(self.disconnect, animated: true)
                
            default:
                
                self.navigationItem.titleView = self.at
                self.title = _state.stringValue()
                self.navigationItem.setRightBarButtonItem(self.connect, animated: true)
                
            }
            
        }
    }
    
    func peersChanged() {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            
            JP("PEERS CHANGED")
            
            self.peerPicker.tableView.reloadData()
            
        }
    }
    
    func closeTPD(sender: UIBarButtonItem){
        
        MPC.stopBrowsing()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func connectTPD(sender: UIBarButtonItem){
        
        var nav = UINavigationController(rootViewController: peerPicker)
        
        var popover = UIPopoverController(contentViewController: nav)
        popover.popoverContentSize = CGSize(width: 220, height: view.bounds.height * 0.6)
        popover.presentPopoverFromBarButtonItem(sender, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        
    }
    
    func disconnectTPD(sender: UIBarButtonItem){
        
        MPC.session.disconnect()
        lastPeer = nil
        
    }
    
    func setData(){
        
        let home = gameData(data: game["home"] as! [String:AnyObject])
        let away = gameData(data: game["away"] as! [String:AnyObject])
        
        JP("RUNS: \(home.run)")
        JP("RUN SECTIONS: \(home.runs)")
        JP("PASS: \(home.pass)")
        JP("PASS SECTIONS: \(home.passes)")
        
        runVIEW.items = home.runs
        runVIEW.total = home.run
        runVIEW.setNeedsDisplay()
        
        passVIEW.items = home.passes
        passVIEW.total = home.pass
        passVIEW.setNeedsDisplay()
        
    }

}