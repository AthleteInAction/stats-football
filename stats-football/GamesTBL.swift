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
            
            let game = games[indexPath.row]
            
            game.delete(nil)
            
            self.games.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let game = games[indexPath.row]
        
        var vc = Tracker(nibName: "Tracker",bundle: nil)
        vc.game = game
        
        main.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getData(){
        
        DB.games.local.get { (s,items) -> Void in
            
            if s {
                
                self.games = items
                self.reloadData()
                
            }
            
        }
        
    }

}