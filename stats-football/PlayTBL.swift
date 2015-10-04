//
//  PlaylogTBL.swift
//  stats-football
//
//  Created by grobinson on 8/26/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PlayTBL: UITableView,UITableViewDataSource,UITableViewDelegate {
    
    var tracker: Tracker!
    
    var plays: [Play] = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
        
        rowHeight = 34
        
        separatorStyle = .None
        
        registerNib(UINib(nibName: "PlayCell", bundle: nil), forCellReuseIdentifier: "play_cell")
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var txt = UILabel()
        txt.textAlignment = .Center
        txt.text = "Log"
        txt.font = UIFont.systemFontOfSize(12)
        txt.textColor = UIColor.whiteColor()
        txt.backgroundColor = UIColor(red: 147/255, green: 147/255, blue: 154/255, alpha: 1)
        
        return txt
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return plays.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("play_cell") as! PlayCell
        
        let s = tracker.game.sequences[tracker.index]
        
        let p = plays[indexPath.row]
        
        cell.userInteractionEnabled = false
        
        var t: String!
        
        if let endX = p.endX {
            
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
            
        }
        
        cell.backgroundColor = Filters.colors(p.key, alpha: 1)
        cell.TXT.textColor = Filters.textColors(p.key, alpha: 1)
        
        var txt = "#\(p.player_a) "
        
        switch p.key as Key {
        case .Run:
            txt += "run"
            txt += " to \(t)"
        case .Return:
            txt += "return"
            txt += " to \(t)"
        case .Kick:
            txt += "kick"
            txt += " to \(t)"
        case .Pass:
            txt += "pass to #"
            txt += p.player_b!.string()
            txt += ", down at \(t)"
            cell.TXT.textColor = UIColor(red: 64/155, green: 64/155, blue: 64/155, alpha: 1)
        case .Incomplete:
            txt += " Incomplete"
        default:
            txt += p.key.displayKey
            txt += " to \(t)"
        }
        
        cell.TXT.text = txt
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    func reload(){
        
        let s = tracker.game.sequences[tracker.index]
        JP("PLAY TBL RELOAD")
        s.getPlays()
        plays = s.plays
        reloadData()
        
    }
    
}