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
import CoreData

class TeamsTBL: UITableView,UITableViewDataSource,UITableViewDelegate {
    
    var main: MainCTRL!
    var teams: [Team] = []

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
        
        getData()
        
    }
    
    override func numberOfRowsInSection(section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teams.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = "\(teams[indexPath.row].name)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let team = teams[indexPath.row]
            
            team.delete(nil)
            teams.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let team = teams[indexPath.row]
        
        let vc = TeamDetail(nibName: "TeamDetail",bundle: nil)
        vc.team = team
        vc.main = main
        let nav = UINavigationController(rootViewController: vc)
        main.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func getData(){
        
        DB.teams.local.get { (s,items) -> Void in
            
            if s {
                
                self.teams = items
                
//                if self.teams.count == 0 {
//                    
//                    DB.teams.local.create(name: "Willow Glen", short: "WG", completion: { (s, team) -> Void in
//                        
//                        let t = Team(team: team)
//                        
//                        self.teams.append(t)
//                        
//                    })
//                    DB.teams.local.create(name: "Terra Nova", short: "TN", completion: { (s, team) -> Void in
//                        
//                        let t = Team(team: team)
//                        
//                        self.teams.append(t)
//                        
//                    })
//                    DB.games.local.create(away: self.teams[1], home: self.teams[0], completion: { (s, game) -> Void in
//                        
//                        
//                        
//                    })
//                    
//                }
                
                self.reloadData()
                
            }
            
        }
        
    }

}