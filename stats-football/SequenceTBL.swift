//
//  PlaylogTBL.swift
//  stats-football
//
//  Created by grobinson on 8/26/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class SequenceTBL: UITableView,UITableViewDataSource,UITableViewDelegate {
    
    var tracker: TrackerCTRL!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
        
        rowHeight = 34
        
        separatorStyle = .None
        
        registerNib(UINib(nibName: "SequenceCell", bundle: nil), forCellReuseIdentifier: "sequence_cell")
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var txt = UILabel()
        txt.textAlignment = .Center
        txt.text = "Plays"
        txt.font = UIFont.systemFontOfSize(12)
        txt.textColor = UIColor.whiteColor()
        txt.backgroundColor = UIColor(red: 147/255, green: 147/255, blue: 154/255, alpha: 1)
        
        return txt
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tracker.game.sequences.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("sequence_cell") as! SequenceCell
        
        let s = tracker.game.sequences[indexPath.row]
        
        cell.sequence = s
        
        let pos_right: Bool = tracker.posRight(s)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.userInteractionEnabled = true
        
        cell.team.backgroundColor = s.team.color
        cell.flag.hidden = !s.flagged
        
        cell.leftTXT.text = s.team.short
//        cell.leftTXT.textColor = s.team.color
        
        let t: String!
        
        if s.startX == 50 {
            t = 50.string()
        } else if s.startX < 0 {
            
            // -38
            t = "\(s.team.short) \(s.startX * -1)"
//            cell.rightTXT.textColor = s.team.color
            
        } else {
            
            // 38
            t = "\(tracker.opTeam(s.team).short) \(s.startX)"
//            cell.rightTXT.textColor = tracker.opTeam(s.team).color
            
        }
        
        cell.rightTXT.text = t
        
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
        
        Stats.player(sequence: tracker.game.sequences[indexPath.row])
        
        tracker.sequenceSelected(indexPath.row)
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SequenceCell
        
        let s = tracker.game.sequences[indexPath.row]
        
        var flag = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Flag") { (action, indexPath) -> Void in
            
            s.flagged = !s.flagged
            s.save(nil)
            
            cell.flag.hidden = !s.flagged
            
            tableView.setEditing(false, animated: true)
            
        }
        
        var delete = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Delete") { (action, indexPath) -> Void in
            
            if self.tracker.game.sequences.count > 1 {
                
                self.userInteractionEnabled = false
                
                s.delete(nil)
                
                var i = indexPath.row
                
                if indexPath.row < self.tracker.index {
                    
                    i--
                    
                } else if indexPath.row == self.tracker.index {
                    
                    if self.tracker.game.sequences.count > (indexPath.row+1) {
                        
                        i++
                        
                    } else {
                        
                        i--
                        
                    }
                    
                }
                
                self.tracker.game.sequences.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                
                self.tracker.selectSequence(i)
                
                self.userInteractionEnabled = true
                
            }
            
        }
        
        flag.backgroundColor = UIColor(red: 254/255, green: 242/255, blue: 58/255, alpha: 1)
        delete.backgroundColor = UIColor.redColor()
        
        return [flag,delete]
        
    }
    
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        
        tracker.selectSequence(tracker.index)
        
    }
    
}