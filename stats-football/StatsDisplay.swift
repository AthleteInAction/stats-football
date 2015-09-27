//
//  StatsDisplay.swift
//  stats-football
//
//  Created by grobinson on 9/25/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class StatsDisplay: UIViewController {

    @IBOutlet weak var passingTBL: PassingTBL!
    
    var team: Team!
    var tracker: TrackerCTRL!
    var t = "home"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tracker.game.away.object.isEqual(team.object) { t = "away" }
        
        title = "Stats"
        
        var close = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "closeTPD:")
        
        navigationItem.setLeftBarButtonItem(close, animated: true)
        
        edgesForExtendedLayout = UIRectEdge()
        
        doStats()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func closeTPD(sender: UIBarButtonItem){
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func doStats(){
        
        var passing = [String:PassingTotal]()
        
        tracker.game.getSequences()
        for sequence in tracker.game.sequences {
            
            let stats: [Stat] = Stats.player(sequence: sequence)
            
            for stat in stats {
                
                if passing[stat.player.string()] == nil {
                    
                    passing[stat.player.string()] = PassingTotal()
                    
                } else {
                    
                    
                    
                }
                
                switch stat.key {
                case "completion","incompletion","int_thrown":
                    
                    passing[stat.player.string()]!.add(stat: stat)
                    
                default:
                    ()
                }
                
            }
            
        }
        JP(passing)
        passingTBL.passing = passing
        
        passingTBL.reloadData()
        
    }

}
