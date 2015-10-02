//
//  PassingTBL.swift
//  stats-football
//
//  Created by grobinson on 9/25/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class RushingTBL: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    var team: Team!
    var rushing: [RushingTotal] = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
        
        registerNib(UINib(nibName: "RushingCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        rowHeight = 60
        
    }
    
    override func drawRect(rect: CGRect) {
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var txt = UILabel()
        txt.textAlignment = .Center
        txt.font = UIFont.systemFontOfSize(12)
        txt.textColor = UIColor.whiteColor()
        txt.backgroundColor = Filters.colors(.Run, alpha: 1)
        
        if section == 0 {
            
            txt.text = "Team Rushing"
            
        } else {
            
            txt.text = "Individual Rushing"
            
        }
        
        return txt
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
            
        } else {
            
            return rushing.count
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! RushingCell
        
        var item: RushingTotal!
        
        if indexPath.section == 0 {
            
            item = team.teamRushing
            cell.playerTXT.text = ""
            cell.backTXT.text = team.short
            
        } else {
            
            item = rushing[indexPath.row]
            cell.playerTXT.text = "#"+item.player.string()
            cell.backTXT.text = "#"+item.player.string()
            
        }
        
        cell.attTXT.text = item.att.string()
        cell.ydsTXT.text = item.yds.string()
        cell.tdTXT.text = item.td.string()
        cell.longTXT.text = item.long.string()
        cell.ypaTXT.text = "\(item.yardsPerAttempt())"
        
        return cell
        
    }
    
}