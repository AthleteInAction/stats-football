//
//  TeamTBL.swift
//  stats-football
//
//  Created by grobinson on 9/10/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TeamsTBL: UITableView,UITableViewDataSource,UITableViewDelegate {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
        
    }
    
    override func numberOfRowsInSection(section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return UITableViewCell()
        
    }

}