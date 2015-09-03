//
//  PlaylogTBL.swift
//  stats-football
//
//  Created by grobinson on 8/26/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class SequenceTBL: UITableView,UITableViewDataSource,UITableViewDelegate {
    
    var tracker: TrackerCTRL!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tracker.log.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        let p = tracker.log[indexPath.row]
        
        switch p.key {
        case "kickoff","freekick","pat":
            
            cell.textLabel?.text = "\(p.pos_id) \(p.key) from \(p.startX)"
            
        default:
            
            cell.textLabel?.text = "\(p.key) : \(p.qtr) : \(p.pos_right) : \(p.startX)"
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let s = tracker.log[tracker.index]
        
        for play in s.plays {
            
            play.removeButton()
            play.removeButtons()
            
        }
        
        tracker.index = indexPath.row
        tracker.sequenceSelected()
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    func reload(){
        
        reloadData()
        tracker.playTBL.reloadData()
        
    }
    
}