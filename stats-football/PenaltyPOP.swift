//
//  PenaltyPOP.swift
//  stats-football
//
//  Created by grobinson on 9/6/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PenaltyPOP: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tracker: TrackerCTRL!
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("VIEW DID LOAD")
        
        table.dataSource = self
        table.delegate = self
        
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 44.0
        
        table.registerNib(UINib(nibName: "PenaltyPOPCell", bundle: nil), forCellReuseIdentifier: "cell_z")
        
//        table.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 32
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: PenaltyPOPCell = tableView.dequeueReusableCellWithIdentifier("cell_z") as! PenaltyPOPCell
        
        cell.label.text = "ROW: \(indexPath.row+1)"
        
        return cell
        
    }

}