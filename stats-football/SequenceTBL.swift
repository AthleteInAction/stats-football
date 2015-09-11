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
        
        delegate = self
        dataSource = self
        
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
        
        let pos_right: Bool = (s.pos_id == tracker.game.home.id && tracker.rightHome) || (s.pos_id == tracker.game.away.id && !tracker.rightHome)
        
        switch s.key {
        case "kickoff","freekick","pat":
            
            cell.textLabel?.text = "\(tracker.getTeam(s.pos_id).short) \(s.key) from \(s.startX)"
            
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
            
            let a = s.startX.yardToFull(pos_right)
            let b = s.fd!.yardToFull(pos_right)
            
            var togo: String!
            
            if pos_right {
                
                togo = "\(a - b)"
                
            } else {
                
                togo = "\(b - a)"
                
            }
            
            var f = ""
            if let fd = s.fd {
                
                if fd == 100 { togo = "G" }
                f = "(\(fd))"
                
            }
            
            cell.textLabel?.text = "\(tracker.getTeam(s.pos_id).short) \(d)n\(togo)\(f) from \(s.startX)"
            
        default:
            
            cell.textLabel?.text = "\(s.key) : \(s.qtr) : \(pos_right) : \(s.startX)"
            
        }
        
        if tracker.log.count == 1 {
            
            cell.selected = true
            cell.selectionStyle = UITableViewCellSelectionStyle.Default
            cell.userInteractionEnabled = false
            
        } else {
            
            cell.userInteractionEnabled = true
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tracker.index = indexPath.row
        tracker.sequenceSelected()
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            if tracker.log.count > 1 {
                
                tracker.index = 0
                tracker.log.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                if tracker.log.count > (indexPath.row+1) {
                    
                    tracker.index = indexPath.row
                    
                } else if tracker.log.count >= (indexPath.row+1) && indexPath.row > 0 {
                    
                    tracker.index = indexPath.row - 1
                    
                }
                
                tracker.selectSequence(tracker.index)
                
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