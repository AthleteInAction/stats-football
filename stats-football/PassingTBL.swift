//
//  PassingTBL.swift
//  stats-football
//
//  Created by grobinson on 9/25/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PassingTBL: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    var team: Team!
    var passing: [PassingTotal] = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
        
        registerNib(UINib(nibName: "PassingCell", bundle: nil), forCellReuseIdentifier: "cell")
        
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
        txt.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        txt.backgroundColor = Filters.colors(.Pass, alpha: 1)
        
        if section == 0 {
            
            txt.text = "Team Passing"
            
        } else {
            
            txt.text = "Individual Passing"
            
        }
        
        return txt
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
            
        } else {
            
            return passing.count
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! PassingCell
        
        var item: PassingTotal!
        
        if indexPath.section == 0 {
            
            item = team.teamPassing
            cell.playerTXT.text = ""
            cell.backTXT.text = team.short
            
        } else {
            
            item = passing[indexPath.row]
            cell.playerTXT.text = "#"+item.player!.string()
            cell.backTXT.text = "#"+item.player!.string()
            
        }
        
        cell.compTXT.text = "\(item.comp) / \(item.att)"
        cell.ydsTXT.text = item.yds.string()
        cell.tdTXT.text = item.td.string()
        cell.intTXT.text = item.int.string()
        cell.ratTXT.text = "\(item.passerRating())"
        cell.perTXT.text = "\(item.completionPercentage())%"
        cell.ypaTXT.text = "\(item.yardsPerAttempt())"
        
        return cell
        
    }
    
}