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
        
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 90
        
        registerNib(UINib(nibName: "SequenceCell", bundle: nil), forCellReuseIdentifier: "sequence_cell")
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tracker.game.sequences.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("sequence_cell") as! SequenceCell
        
        let s = tracker.game.sequences[indexPath.row]
        
        let pos_right: Bool = tracker.posRight(s)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.userInteractionEnabled = true
        cell.posIndicator.setTitle(s.team.short, forState: .Normal)
        
        let t: String!
        
        if s.startX == 50 {
            t = 50.string()
        } else if s.startX < 0 {
            
            // -38
            t = "\(s.team.short) \(s.startX * -1)"
            
        } else {
            
            // 38
            t = "\(tracker.opTeam(s.team).short) \(s.startX)"
            
        }
        
        cell.ballPos.setTitle(t, forState: .Normal)
        
        switch s.key {
        case "kickoff":
            
            cell.midTXT.text = "Kickoff"
            
        case "freekick":
            
            cell.midTXT.text = "Freekick"
            
        case "pat":
            
            cell.midTXT.text = "PAT"
            
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
                f = "\(fd)"
                
            }
            
            switch d {
            case 1.string():
                d = "1st"
            case 2.string():
                d = "2nd"
            case 3.string():
                d = "3rd"
            case 4.string():
                d = "4th"
            default:
                ()
            }
            
            cell.midTXT.text = "\(d) and \(togo)"
            
        default:
            
            cell.midTXT.text = "Error"
            
        }
        
//        if tracker.game.sequences.count == 1 {
//            
//            cell.selected = true
//            cell.selectionStyle = UITableViewCellSelectionStyle.Default
//            cell.userInteractionEnabled = false
//            
//        } else {
//            
//            cell.userInteractionEnabled = true
//            
//        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tracker.index = indexPath.row
        tracker.sequenceSelected()
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("DESELECT")
        
        let s = tracker.game.sequences[indexPath.row]
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let text = cell?.textLabel?.text
        
        cell?.textLabel?.text = "Saving..."
        
        s.save(nil)
        
        cell?.textLabel?.text = text
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            if tracker.game.sequences.count > 1 {
                
                let s = tracker.game.sequences[tracker.index]
                
                s.delete(nil)
                
                tracker.index = 0
                tracker.game.sequences.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                if tracker.game.sequences.count > (indexPath.row+1) {
                    
                    tracker.index = indexPath.row
                    
                } else if tracker.game.sequences.count >= (indexPath.row+1) && indexPath.row > 0 {
                    
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
        tracker.penaltyTBL.reloadData()
        tracker.selectSequence(tracker.index)
        
    }
    
}