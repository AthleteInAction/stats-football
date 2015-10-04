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
    
    var tracker: Tracker!
    
    var sequences: [Sequence] = []
    
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
        
        return sequences.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("sequence_cell") as! SequenceCell
        
        let s = sequences[indexPath.row]
        
        cell.sequence = s
        
        let pos_right: Bool = tracker.posRight(s)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.userInteractionEnabled = true
        
        cell.team.backgroundColor = s.team.primary
//        cell.flag.hidden = !s.flagged
        if let play = s.plays.first {
            
            cell.flag.hidden = false
            cell.flag.backgroundColor = Filters.colors(play.key, alpha: 1)
            cell.flag.alpha = 0.6
            
        } else {
            
            cell.flag.hidden = true
            
        }
        
        cell.leftTXT.text = s.team.short
        
        let t: String!
        
        switch s.startX.spot {
        case 50:
            
            t = 50.string()
            
        case 1...49:
            
            t = "\(s.team.short) \(s.startX.toShort())"
            
        case 51...99:
            
            t = "\(tracker.opTeam(s.team).short) \(s.startX.toShort())"
            
        default:
            
            if s.startX.spot < 50 {
                t = "\(s.team.short) ENDZONE"
            } else {
                t = "\(tracker.opTeam(s.team).short) ENDZONE"
            }
            
        }
        
        cell.rightTXT.text = t
        
        switch s.key as Playtype {
        case .Kickoff:
            
            cell.midTXT.text = "Kickoff"
            
        case .Freekick:
            
            cell.midTXT.text = "Freekick"
            
        case .PAT:
            
            cell.midTXT.text = "PAT"
            
        case .Down:
            
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
            
            var togo = "\(s.fd!.spot - s.startX.spot)"
            if s.fd!.spot >= 100 { togo = "G" }
            
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
        
        tracker.selectSequence(indexPath.row)
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            let s = sequences[indexPath.row]
            
            s.delete(nil)
            
            sequences.removeAtIndex(indexPath.row)
            tracker.game.sequences.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            
            tracker.selectSequence(0)
            
        }
        
    }
    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
//        
//        
//        
//    }
    
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    
    func reload(){
        
        sequences = tracker.game.sequences
        reloadData()
        
    }
    
}