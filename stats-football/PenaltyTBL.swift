//
//  PenaltyTBL.swift
//  stats-football
//
//  Created by grobinson on 9/13/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PenaltyTBL: UITableView,UITableViewDataSource,UITableViewDelegate {
    
    var tracker: Tracker!
    
    var penalties: [Penalty] = []

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
        
        rowHeight = 46
        
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
        
        return penalties.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let s = tracker.game.sequences[tracker.index]
        
        if penalties.count == 0 {
            let c = UITableViewCell()
            c.textLabel?.text = "NO DATA : \(indexPath.row)"
            return c
        }
        
        let penalty = penalties[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("penalty_cell") as! PenaltyCell
        cell.backgroundColor = UIColor.yellowColor()
        
        var top = "\(penalty.distance) yard penalty"
        
        cell.topTXT.text = top
        
        switch penalty.enforcement as Key {
        case .Declined,.Offset,.Kick:
            
            cell.btmTXT.text = penalty.enforcement.displayKey
            
        default:
            
            var t: String!
            
            if let endX = penalty.endX {
                
                switch endX.spot {
                case 50:
                    
                    t = 50.string()
                    
                case 1...49:
                    
                    t = "\(s.team.short) \(endX.toShort())"
                    
                case 51...99:
                    
                    t = "\(tracker.opTeam(s.team).short) \(endX.toShort())"
                    
                default:
                    
                    if endX.spot < 50 {
                        t = "\(s.team.short) ENDZONE"
                    } else {
                        t = "\(tracker.opTeam(s.team).short) ENDZONE"
                    }
                    
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
            
            let penalty = penalties[indexPath.row]
            
            penalty.delete(nil)
            
            s.getPenalties()
            
            penalties = s.penalties
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            
            tracker.field.setNeedsDisplay()
            tracker.drawButtons()
            
        }
        
    }
    
    func reload(){
        
        let s = tracker.game.sequences[tracker.index]
        s.getPenalties()
        penalties = s.penalties
        reloadData()
        
    }

}