//
//  PlaylogTBL.swift
//  stats-football
//
//  Created by grobinson on 8/26/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PlayTBL: UITableView,UITableViewDataSource,UITableViewDelegate {
    
    var tracker: TrackerCTRL!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
        
        estimatedRowHeight = 44
        rowHeight = UITableViewAutomaticDimension
        
        registerNib(UINib(nibName: "PlayCell", bundle: nil), forCellReuseIdentifier: "play_cell")
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let s = tracker.game.sequences[tracker.index]
        
        return s.plays.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("play_cell") as! PlayCell
        
        let s = tracker.game.sequences[tracker.index]
        
        let p = s.plays[indexPath.row]
        
        cell.userInteractionEnabled = false
        
        var t: String!
        
        if let endX = p.endX {
            
            if p.endX == 50 {
                t = 50.string()
            } else if p.endX < 0 {
                
                // -38
                t = "\(s.team.short) \(p.endX! * -1)"
                
            } else {
                
                // 38
                t = "\(tracker.opTeam(s.team).short) \(p.endX!)"
                
            }
            
        }
        
        cell.backgroundColor = Filters.colors(p.key, alpha: 1)
        cell.TXT.textColor = Filters.textColors(p.key, alpha: 1)
        
        var txt = "#\(p.player_a) "
        
        switch p.key {
        case "run":
            txt += "runs"
            txt += " to \(t)"
        case "return":
            txt += "returns"
            txt += " to \(t)"
        case "kick":
            txt += "kicks"
            txt += " to \(t)"
        case "pass":
            txt += "passes to #"
            txt += p.player_b!.string()
            txt += ", down at \(t)"
            cell.TXT.textColor = UIColor(red: 64/155, green: 64/155, blue: 64/155, alpha: 1)
        case "incomplete":
            txt += " Incomplete"
        default:
            txt += p.key
            txt += " to \(t)"
        }
        
        cell.TXT.text = txt
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    func reload(){
        
        tracker.game.sequences[tracker.index].getPlays()
        reloadData()
        
    }
    
}