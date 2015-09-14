//
//  GamesTBL.swift
//  stats-football
//
//  Created by grobinson on 9/10/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GamesTBL: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    var main: MainCTRL!
    
    var games: [Game] = []
    
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
        
        return games.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        let g = games[indexPath.row]
        
        cell.textLabel?.text = "\(g.away.name) @ \(g.home.name)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            Loading.start()
            
            let game = games[indexPath.row]
            
            let s = "\(domain)/api/v1/games/\(game.id).json"
            
            Alamofire.request(.DELETE,s)
                .responseJSON { request, response, data, error in
                    
                    if error == nil {
                        
                        if response?.statusCode == 200 {
                            
                            self.games.removeAtIndex(indexPath.row)
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
        
        let game = games[indexPath.row]
        
        var vc = main.storyboard?.instantiateViewControllerWithIdentifier("tracker_ctrl") as! TrackerCTRL
        vc.game = game
        main.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getData(){
        
//        Loading.start()
//        
//        let s = "\(domain)/api/v1/games.json"
//        
//        Alamofire.request(.GET, s.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, parameters: nil)
//            .responseJSON { request, response, data, error in
//                
//                if error == nil {
//                    
//                    if response?.statusCode == 200 {
//                        
//                        var json = JSON(data!)
//                        
//                        var tmp: [Game] = []
//                        
//                        if let games = json["games"].array {
//                            
//                            for game in games {
//                                
//                                let t = Game(json: game)
//                                
//                                tmp.append(t)
//                                
//                            }
//                            
//                        }
//                        
//                        self.games = tmp
//                        
//                        self.reloadData()
//                        
//                    } else {
//                        
//                        println("Status Code Error: \(response?.statusCode)")
//                        println(request)
//                        
//                    }
//                    
//                } else {
//                    
//                    println("Error!")
//                    println(error)
//                    println(request)
//                    
//                }
//                
//                Loading.stop()
//                
//        }
        
    }

}