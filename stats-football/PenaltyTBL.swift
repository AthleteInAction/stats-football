//
//  PenaltyTBL.swift
//  stats-football
//
//  Created by grobinson on 9/13/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PenaltyTBL: UITableView,UITableViewDataSource,UITableViewDelegate {
    
    var tracker: TrackerCTRL!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
        
        estimatedRowHeight = 44
        rowHeight = UITableViewAutomaticDimension
        
        separatorStyle = .None
        
        registerNib(UINib(nibName: "PenaltyCell", bundle: nil), forCellReuseIdentifier: "penalty_cell")
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var txt = UILabel()
        txt.textAlignment = .Center
        txt.text = "Penalties"
        txt.font = UIFont.systemFontOfSize(12)
        txt.textColor = UIColor.whiteColor()
        txt.backgroundColor = UIColor(red: 147/255, green: 147/255, blue: 154/255, alpha: 1)
        
        return txt
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tracker.game.sequences.count == 0 {
            
            return 0
            
        } else {
            
            let s = tracker.game.sequences[tracker.index]
            
            s.getPenalties()
            
            return s.penalties.count
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let s = tracker.game.sequences[tracker.index]
        
        s.getPenalties()
        
        if s.penalties.count == 0 {
            let c = UITableViewCell()
            c.textLabel?.text = "NO DATA : \(indexPath.row)"
            return c
        }
        JP("PENALTIES 2: \(s.penalties.count)")
        let penalty = s.penalties[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("penalty_cell") as! PenaltyCell
        cell.backgroundColor = UIColor.yellowColor()
        
        var top = "\(penalty.distance) yard penalty on \(penalty.team.short)"
        
        if let p = penalty.player {
            
            top += " #\(p)"
            
        }
        
        cell.topTXT.text = top
        
        switch penalty.enforcement {
        case "declined":
            
            cell.btmTXT.text = "Declined"
            
        case "offset":
            
            cell.btmTXT.text = "Offset"
            
        case "kick":
            
            cell.btmTXT.text = "Enforced on Kickoff"
            
        default:
            
            var t: String!
            
            if let endX = penalty.endX {
                
                if endX == 50 {
                    t = 50.string()
                } else if endX < 0 {
                    
                    // -38
                    t = "\(s.team.short) \(endX * -1)"
                    
                } else {
                    
                    // 38
                    t = "\(tracker.opTeam(penalty.team).short) \(endX)"
                    
                }
                
                cell.btmTXT.text = "Ball to \(t)"
                
            } else {
                
                cell.btmTXT.text = "No Spot"
                
            }
            
        }
        
        cell.selectionStyle = .None
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let s = tracker.game.sequences[tracker.index]
            
            s.getPenalties()
            
            let penalty = s.penalties[indexPath.row]
            
            penalty.delete(nil)
            
            s.penalties.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            
            tracker.draw()
            tracker.drawButtons()
            
        }
        
    }

}
