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
        
        let s = tracker.log[indexPath.row]
        
        switch s.key {
        case "kickoff","freekick","pat":
            
            cell.textLabel?.text = "\(s.pos_id) \(s.key) from \(s.startX)"
            
        case "down":
            
            var fd: String!
            
            if let f = s.fd {
                fd = "\(f)"
            } else {
                fd = "nil"
            }
            
            var d: String!
            
            if let dd = s.down {
                d = "\(dd)"
            } else {
                d = "nil"
            }
            
            let a = s.startX.yardToFull(s.pos_right)
            let b = s.fd!.yardToFull(s.pos_right)
            
            var togo: String!
            
            if s.pos_right == true {
                
                togo = "\(a - b)"
                
            } else {
                
                togo = "\(b - a)"
                
            }
            
            if let fd = s.fd {
                
                if fd == 100 { togo = "G" }
                
            }
            
            cell.textLabel?.text = "\(s.pos_id) \(d)n\(togo) from \(s.startX)"
            
        default:
            
            cell.textLabel?.text = "\(s.key) : \(s.qtr) : \(s.pos_right) : \(s.startX)"
            
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
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            if tracker.log.count > 1 {
                
                tracker.log.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                tracker.selectSequence(0)
                
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        
        tracker.selectSequence(tracker.index)
        
    }
    
    func reload(){
        
        reloadData()
        tracker.playTBL.reloadData()
        
    }
    
}