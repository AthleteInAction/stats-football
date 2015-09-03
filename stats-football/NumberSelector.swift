//
//  NumberSelector.swift
//  stats-football
//
//  Created by grobinson on 8/25/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class NumberSelector: UITableView,UITableViewDataSource,UITableViewDelegate {
    
    var d: TrackerCTRL!
    
    var numbers: [Int] = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numbers.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! NumberSelectorCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        let n = numbers[indexPath.row]
        
        cell.num.text = "\(n)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! NumberSelectorCell
        
        let n = numbers[indexPath.row]
        
        d.numberSelected(n)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }

}