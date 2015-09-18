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
        
        s = tracker.game.sequences[tracker.index]
        
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
                
                play.key = key
                tracker.newPlay = play
                
                switch key {
                case "pass","interception":
                    
                    nsel.type = "player_b"
                    nsel.newPlay = play
                    
                    navigationController?.pushViewController(nsel, animated: false)
                    
                case "incomplete":
                    
                    play.save(nil)
                    
                    s.plays.append(play)
                    
                    tracker.playTBL.reloadData()
                    
                    tracker.newPlay = nil
                    
                    dismissViewControllerAnimated(false, completion: nil)
                    
                default:
                    
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
            case "penalty_distance":
            // ++++++++++++++++++++++++++++++++++++++++++++++++
                
                penalty.distance = key.toInt()!
                nsel.newPenalty = penalty
                nsel.type = "penalty_player"
                
                navigationController?.pushViewController(nsel, animated: false)
                
            // ++++++++++++++++++++++++++++++++++++++++++++++++
            case "penalty_options":
            // ++++++++++++++++++++++++++++++++++++++++++++++++
                
                switch key {
                case "offset","declined":
                    
                    penalty.enforcement = key
                    
                    penalty.save(nil)
                    
                    s.penalties.append(penalty)
                    
                    tracker.penaltyTBL.reloadData()
                    
                case "kick":
                    
                    penalty.enforcement = "kick"

                    penalty.save(nil)
                    
                    s.penalties.append(penalty)
                    
                    tracker.penaltyTBL.reloadData()
                    
                default:
                    
                    penalty.enforcement = "spot"
                    
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