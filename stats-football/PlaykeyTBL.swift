//
//  PlaykeyTBL.swift
//  stats-football
//
//  Created by grobinson on 8/27/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PlaykeyTBL: UITableView,UITableViewDataSource,UITableViewDelegate {
    
    var d: Tracker!
    
    var keys = [
        "kick",
        "run",
        "pass",
        "interception",
        "penalty"
    ]

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return keys.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        cell.textLabel?.text = keys[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let key = keys[indexPath.row]
        
    }

}