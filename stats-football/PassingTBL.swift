//
//  PassingTBL.swift
//  stats-football
//
//  Created by grobinson on 9/25/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PassingTBL: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    var passing = [String:PassingTotal]()
    
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
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var txt = UILabel()
        txt.textAlignment = .Center
        txt.text = "Passing"
        txt.font = UIFont.systemFontOfSize(12)
        txt.textColor = UIColor.whiteColor()
        txt.backgroundColor = UIColor(red: 147/255, green: 147/255, blue: 154/255, alpha: 1)
        
        return txt
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return passing.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! PassingCell
        
        let key = Array(passing.keys)[indexPath.row]
        
        if let item = passing[key] {
            
            cell.playerTXT.text = "#"+key
            cell.compTXT.text = "\(item.comp) / \(item.att)"
            cell.ydsTXT.text = item.yds.string()
            cell.tdTXT.text = item.td.string()
            cell.intTD.text = item.int.string()
            
        }
        
        return cell
        
    }
    
}