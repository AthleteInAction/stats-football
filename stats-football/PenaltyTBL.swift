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
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let s = tracker.log[tracker.index]
        
        return s.penalties.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let s = tracker.log[tracker.index]
        
        let penalty = s.penalties[indexPath.row]
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor.yellowColor()
        cell.textLabel?.font = cell.textLabel?.font.fontWithSize(11)
        
        var desc = "\(penalty.distance) yards"
        if let player = penalty.player { desc += " : #\(player)" }
        if let x = penalty.endX { desc += " : \(x)" }
        
        cell.textLabel?.text = desc
        cell.selectionStyle = .None
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let s = tracker.log[tracker.index]
            
            s.penalties.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            
            tracker.draw()
            tracker.drawButtons()
            
        }
        
    }

}
