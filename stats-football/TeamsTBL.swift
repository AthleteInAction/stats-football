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
        
        cell.textLabel?.text = teams[indexPath.row].name
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            Loading.start()
            
            let team = teams[indexPath.row]
            
            let s = "\(domain)/api/v1/teams/\(team.id).json"
            
            Alamofire.request(.DELETE,s)
                .responseJSON { request, response, data, error in
                    
                    if error == nil {
                        
                        if response?.statusCode == 200 {
                            
                            self.teams.removeAtIndex(indexPath.row)
                            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                            
                        } else {
                            
                            println("Status Code Error: \(response?.statusCode)")
                            println(request)
                            
                        }
                        
                    } else {
                        
                        println("Error!")
                        println(error)
                        println(request)
                        
                    }
                    
                    Loading.stop()
                    
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func getData(){
        
        Loading.start()
        
        let s = "\(domain)/api/v1/teams.json"
        
        Alamofire.request(.GET, s.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, parameters: nil)
            .responseJSON { request, response, data, error in
                
                if error == nil {
                    
                    if response?.statusCode == 200 {
                        
                        var json = JSON(data!)
                        
                        var tmp: [Team] = []
                        
                        if let teams = json["teams"].array {
                            
                            for team in teams {
                                
                                let t = Team(json: team)
                                
                                tmp.append(t)
                                
                            }
                            
                        }
                        
                        self.teams = tmp
                        
                        self.reloadData()
                        
                    } else {
                        
                        println("Status Code Error: \(response?.statusCode)")
                        println(request)
                        
                    }
                    
                } else {
                    
                    println("Error!")
                    println(error)
                    println(request)
                    
                }
                
                Loading.stop()
                
        }
        
    }

}