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
        s.getPlays()
        s.getPenalties()
        
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
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell") as UITableViewCell
        
        let key = keys[indexPath.row]
        
        switch type {
        case "penalty_distance":
            
            cell.textLabel?.text = "\(key) yards"
            
        case "penalty_occurence":
            
            cell.textLabel?.text = "\(key) the play"
            
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
                case "kick":
                    
                    penalty.enforcement = key
                    
                    penalty.save(nil)
                    
                    s.penalties.append(penalty)
                    
                    tracker.penaltyTBL.reloadData()
                    
                    tracker.updateBoard()
                    
                case "offset","declined":
                    
                    penalty.enforcement = key
                    
                    penalty.save(nil)
                    
                    tracker.penaltyTBL.reloadData()
                    
                    tracker.updateBoard()
                    
                case "previous spot":
                    
                    let yard = Yardline(yardline: s.startX)
                    
                    if s.team.object.isEqual(penalty.team.object) {
                        
                        penalty.endX = yard.penaltyMinus(penalty.distance)
                        
                    } else {
                        
                        penalty.endX = yard.penaltyPlus(penalty.distance)
                        
                    }
                    
                    penalty.enforcement = key
                    
                    penalty.save(nil)
                    
                    s.penalties.append(penalty)
                    
                    s.replay = true
                    
                    s.save(nil)
                    
                    tracker.penaltyTBL.reloadData()
                    tracker.draw()
                    tracker.drawButtons()
                    tracker.updateBoard()
                    
                case "dead ball spot":
                    
                    var yard = Yardline(yardline: s.startX)
                    
                    s.getPlays()
                    for play in reverse(s.plays) {
                        
                        if let x = play.endX {
                            
                            yard = Yardline(yardline: x)
                            
                            break
                            
                        }
                        
                    }
                    
                    if s.team.object.isEqual(penalty.team.object) {
                        
                        penalty.endX = yard.penaltyMinus(penalty.distance)
                        
                    } else {
                        
                        penalty.endX = yard.penaltyPlus(penalty.distance)
                        
                    }
                    
                    penalty.enforcement = key
                    
                    penalty.save(nil)
                    
                    s.penalties.append(penalty)
                    
                    tracker.penaltyTBL.reloadData()
                    tracker.draw()
                    tracker.drawButtons()
                    tracker.updateBoard()
                    
                case "spot of foul":
                    
                    penalty.enforcement = key
                    
                    tracker.newPenalty = penalty
                    
                    tracker.spot()
                    
                default:
                    
                    ()
                    
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

class Yardline {
    
    var spot: Int!
    
    func full() -> Int {
        
        switch spot {
        case 1 ... 49:
            return 100 - spot
        case -49 ... -1:
            return spot * -1
        case -110 ... -100:
            return 100 + spot
        default:
            return spot
        }
        
    }
    
    func split(n: Int) -> Int {
        
        var final = n
        
        switch n {
        case 51 ... 99:
            return 100 - final
        case 100 ... 110,1 ... 49:
            return final * -1
        default:
            return final
        }
        
    }
    
    func penaltyMinus(n: Int) -> Int {
        
        var full = self.full()
        var final = full
        
        if final <= (n * 2) { final %= 2 } else { final -= n }
        
        return split(final)
        
    }
    
    func penaltyPlus(n: Int) -> Int {
        
        var full = self.full()
        var final = full
        
        if final >= (100 - (n * 2)) { final = 100 - (final % 2) } else { final += n }
        
        return split(final)
        
    }
    
    init(yardline: Int){
        
        spot = yardline
        
    }
    
}