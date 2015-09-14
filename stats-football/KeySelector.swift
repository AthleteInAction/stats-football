//
//  PlayKeySelector.swift
//  stats-football
//
//  Created by grobinson on 9/7/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class KeySelector: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate {

    var tracker: TrackerCTRL!
    var newPlay: Play?
    var newPenalty: Penalty?
    private var keys: [String] = []
    var type: String!
    
    var nsel: NumberSelector!
    var ksel: KeySelector!
    
    var s: Sequence!
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        s = tracker.log[tracker.index]
        
        keys = Filters.keys(s,type: type)
        
        nsel = NumberSelector(nibName: "NumberSelector", bundle: nil)
        nsel.tracker = tracker
        
        ksel = KeySelector(nibName: "KeySelector", bundle: nil)
        ksel.tracker = tracker
        
        table.delegate = self
        table.dataSource = self
        
        edgesForExtendedLayout = UIRectEdge()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return keys.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        let key = keys[indexPath.row]
        
        switch type {
        case "penalty_distance":
            
            cell.textLabel?.text = "\(key) yards"
            
        default:
            
            cell.textLabel?.text = key
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let key = keys[indexPath.row]
        
        // =========================================================
        // =========================================================
        if let play = newPlay {
            
            switch type {
            case "play_key_select":
            // ++++++++++++++++++++++++++++++++++++++++++++++++
                
                switch key {
                case "pass","interception":
                    
                    play.key = key
                    nsel.newPlay = play
                    nsel.type = "player_b"
                    
                    navigationController?.pushViewController(nsel, animated: false)
                    
                default:
                    
                    play.key = key
                    tracker.newPlay = play
                    
                    tracker.spot()
                    
                    close()
                    
                }
                
            // ++++++++++++++++++++++++++++++++++++++++++++++++
            default:
                
                ()
                
            }
            
        }
        // =========================================================
        // =========================================================
        
        if let penalty = newPenalty {
            
            switch type {
            // ++++++++++++++++++++++++++++++++++++++++++++++++
//            case "penalty_type":
//            // ++++++++++++++++++++++++++++++++++++++++++++++++
//                
//                play.penaltyKey = key
//                ksel.newPlay = play
//                ksel.type = "penalty_distance"
//                
//                navigationController?.pushViewController(ksel, animated: false)
                
            // ++++++++++++++++++++++++++++++++++++++++++++++++
            case "penalty_distance":
            // ++++++++++++++++++++++++++++++++++++++++++++++++
                
                penalty.distance = key.toInt()
                nsel.newPenalty = penalty
                nsel.type = "penalty_player"
                
                navigationController?.pushViewController(nsel, animated: false)
                
            // ++++++++++++++++++++++++++++++++++++++++++++++++
            case "penalty_options":
            // ++++++++++++++++++++++++++++++++++++++++++++++++
                
                switch key {
                case "offset":
                    
                    penalty.enforcement = "offset"
                    
                    s.penalties.append(penalty)
                    
                    tracker.penaltyTBL.reloadData()
                    
                case "kick":
                    
                    penalty.enforcement = "kick"
                    s.penalties.append(penalty)
                    
                    tracker.penaltyTBL.reloadData()
                    
                default:
                    
                    tracker.newPenalty = penalty
                    
                    tracker.spot()
                    
                }
                
                close()
            
            // ++++++++++++++++++++++++++++++++++++++++++++++++
            default:
                
                ()
                
            }
            
        }
        
    }
    
    func close(){
        
        dismissViewControllerAnimated(false, completion: nil)
        
    }

}