//
//  NumberTable.swift
//  stats-football
//
//  Created by grobinson on 10/22/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class NumberTable: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    var tracker: Tracker!
    var title: String!
    var players: [Player] = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
        
        rowHeight = 30
        
    }
    
    override func drawRect(rect: CGRect) {
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return players.count
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v = UILabel()
        v.text = title
        v.textColor = Filters.textColors(.Sacked, alpha: 1)
        v.backgroundColor = Filters.colors(.Sacked, alpha: 1)
        v.textAlignment = .Center
        v.font = UIFont.systemFontOfSize(10, weight: 0.4)
        
        return v
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        let player = players[indexPath.row]
        
        cell.textLabel?.text = "#"+player.number.string()
        cell.textLabel?.textAlignment = .Center
        cell.textLabel?.font = UIFont.systemFontOfSize(14, weight: 0.4)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }

}