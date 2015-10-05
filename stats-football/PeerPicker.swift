//
//  PeerPicker.swift
//  stats-football
//
//  Created by grobinson on 9/20/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class PeerPicker: UITableViewController {
    
    var dataDisplay: DataDisplay!
    
    var devices: [MCPeerID] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select Device"
        
        edgesForExtendedLayout = UIRectEdge()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MPC.devices.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        
        let device = MPC.devices[indexPath.row]
        
        cell.textLabel?.text = device.displayName
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let device = MPC.devices[indexPath.row]
        
        MPC.serviceBrowser.invitePeer(device, toSession: MPC.session, withContext: nil, timeout: 10)
        
    }
    
}