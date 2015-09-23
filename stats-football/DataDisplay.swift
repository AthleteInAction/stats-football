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
    
    var peerPicker: PeerPicker!
    
    var MPC = MPCManager()
    
    var game: [[String:AnyObject]] = []
    var data: [String:AnyObject] = [
        "run": 0,
        "run_pct": 0,
        "pass": 0,
        "pass_pct": 0
    ]
    
    var ai: UIActivityIndicatorView!
    var at: UIView!
    
    var connect: UIBarButtonItem!
    var disconnect: UIBarButtonItem!
    
    @IBOutlet weak var rpVIEW: rpPCT!
    @IBOutlet weak var fieldIMG: UIImageView!
    @IBOutlet weak var field: DisplayField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        ai.startAnimating()
        
        at = navigationItem.titleView
        
        rpVIEW.dataDisplay = self
        field.dataDisplay = self
        
        MPC.receiver = self
        MPC.stateMonitor = self
        
        MPC.startBrowsing()
        
        title = "Not Connected"
        
        edgesForExtendedLayout = UIRectEdge()
        
        var cancel = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Done, target: self, action: "cancelTPD:")
        navigationItem.setLeftBarButtonItem(cancel, animated: true)
        
        connect = UIBarButtonItem(title: "Connect", style: UIBarButtonItemStyle.Plain, target: self, action: "connectTPD:")
        navigationItem.setRightBarButtonItem(connect, animated: true)
        
        disconnect = UIBarButtonItem(title: "Disconnect", style: UIBarButtonItemStyle.Plain, target: self, action: "disconnectTPD:")
        
        peerPicker = PeerPicker(nibName: "PeerPicker",bundle: nil)
        peerPicker.dataDisplay = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func cancelTPD(sender: UIBarButtonItem){
        
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
    
    func receiveGame(game: [[String:AnyObject]]) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            
            self.game = game
            self.setData()
            
        }
    }
    
    func setData(){
        
        data = Stats.compileAnalytics(game: game)
        println("DATA SENT:")
        println(data)
        rpVIEW.setViews()
        field.setViews()
        
    }
    
    func stateChanged(state: MCSessionState) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            
            switch state {
            case .Connecting:
                self.navigationItem.titleView = self.ai
            case .Connected:
                self.navigationItem.titleView = self.at
                self.title = state.stringValue()
                self.peerPicker.dismissViewControllerAnimated(true, completion: nil)
                self.navigationItem.setRightBarButtonItem(self.disconnect, animated: true)
            default:
                self.navigationItem.titleView = self.at
                self.title = state.stringValue()
                self.navigationItem.setRightBarButtonItem(self.connect, animated: true)
            }
            
        }
    }
    
    func peersChanged() {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            
            self.peerPicker.tableView.reloadData()
            
        }
    }

}