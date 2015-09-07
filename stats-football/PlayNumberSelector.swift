//
//  PlayNumberSelector.swift
//  stats-football
//
//  Created by grobinson on 9/7/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PlayNumberSelector: UITableView,UITableViewDataSource,UITableViewDelegate {
    
    var numbers: [Int] = [2,23,54,67,9,94,88,10]

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numbers.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        let n = numbers[indexPath.row]
        
        cell.textLabel?.text = "#\(n)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }

}