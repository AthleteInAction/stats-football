//
//  PassingTBL.swift
//  stats-football
//
//  Created by grobinson on 9/25/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PuntReturnTBL: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    var team: Team!
    var returns: [ReturnTotal] = []
    var type: String!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
        
        registerNib(UINib(nibName: "PuntReturnCell", bundle: nil), forCellReuseIdentifier: "cell")
        
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
        txt.backgroundColor = Filters.colors(.Return, alpha: 1)
        
        if section == 0 {
            
            txt.text = "Team \(type) Return"
            
        } else {
            
            txt.text = "Individual \(type) Return"
            
        }
        
        return txt
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
            
        } else {
            
            return returns.count
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! PuntReturnCell
        
        var item: ReturnTotal!
        
        if indexPath.section == 0 {
            
            if type == "Kick" {
                item = team.teamKickReturns
            } else {
                item = team.teamPuntReturns
            }
            cell.playerTXT.text = ""
            cell.backTXT.text = team.short
            
        } else {
            
            item = returns[indexPath.row]
            cell.playerTXT.text = "#"+item.player!.string()
            cell.backTXT.text = "#"+item.player!.string()
            
        }
        
        cell.attTXT.text = item.att.string()
        cell.ydsTXT.text = item.yds.string()
        cell.tdTXT.text = item.td.string()
        cell.longTXT.text = item.long.string()
        cell.ypaTXT.text = "\(item.yardsPerReturn())"
        
        return cell
        
    }
    
}