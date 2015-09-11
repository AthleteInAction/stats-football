//
//  NumberSelector.swift
//  stats-football
//
//  Created by grobinson on 9/7/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class NumberSelector: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var teamSEL: UISegmentedControl!
    
    var tracker: TrackerCTRL!
    var newPlay: Play?
    var type: String!
    var i: Int!
    
    var nsel: NumberSelector!
    var ksel: KeySelector!
    
    var numbers: [Int] = []
    
    var s: Sequence!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        s = tracker.log[tracker.index]
        
        nsel = NumberSelector(nibName: "NumberSelector", bundle: nil)
        nsel.tracker = tracker
        
        ksel = KeySelector(nibName: "KeySelector", bundle: nil)
        ksel.tracker = tracker
        
        table.delegate = self
        table.dataSource = self
        
        let getRandom = randomSequenceGenerator(min: 1, max: 99)
        
        for _ in 1...34 {
            
            numbers.append(getRandom())
            
        }
        
        numbers.sort( {$0 < $1 } )
        
        edgesForExtendedLayout = UIRectEdge()
        
        setTeamSel()
        
        switch type {
        case "penalty","fumble":
            
            teamSEL.hidden = false
            
        default:
            
            teamSEL.hidden = true
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func randomSequenceGenerator(#min: Int,max: Int) -> () -> Int {
        var numbers: [Int] = []
        return {
            if numbers.count == 0 {
                numbers = Array(min ... max)
            }
            
            let index = Int(arc4random_uniform(UInt32(numbers.count)))
            return numbers.removeAtIndex(index)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numbers.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        let n = numbers[indexPath.row]
        
        cell.textLabel?.text = "#\(n)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let n = numbers[indexPath.row]
        
        // =========================================================
        // =========================================================
        if let play = newPlay {
            
            switch type {
            case "player_a":
                
                play.player_a = n
                
                ksel.type = "play_key_select"
                ksel.newPlay = play
                
                navigationController?.pushViewController(ksel, animated: true)
                
            case "player_b":
                
                play.player_b = n
                
                tracker.newPlay = play
                
                tracker.spot()
                
                close()
                
            case "tackle":
                
                s.plays[i].tackles.append(n)
                
                tracker.draw()
                
                close()
                
            case "sack":
                
                s.plays[i].sacks.append(n)
                
                tracker.draw()
                
                close()
                
            case "penalty_player":
                
                play.player_a = n
                ksel.newPlay = play
                ksel.type = "penalty_options"
                
                navigationController?.pushViewController(ksel, animated: true)
                
            default:
                
                ()
                
            }
            
        }
        // =========================================================
        // =========================================================
        
    }
    
    func close(){
        
        dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    func setTeamSel(){
        
        if let play = newPlay {
            
            if let id = play.pos_id {
                
                if play.key == "penalty" {
                    
                    if tracker.rightHome {
                        
                        teamSEL.setTitle(tracker.game.away.short, forSegmentAtIndex: 0)
                        teamSEL.setTitle(tracker.game.home.short, forSegmentAtIndex: 1)
                        
                        if id == tracker.game.home.id {
                            
                            teamSEL.selectedSegmentIndex = 1
                            
                        } else {
                            
                            teamSEL.selectedSegmentIndex = 0
                            
                        }
                        
                    } else {
                        
                        teamSEL.setTitle(tracker.game.away.short, forSegmentAtIndex: 1)
                        teamSEL.setTitle(tracker.game.home.short, forSegmentAtIndex: 0)
                        
                        if id == tracker.game.home.id {
                            
                            teamSEL.selectedSegmentIndex = 0
                            
                        } else {
                            
                            teamSEL.selectedSegmentIndex = 1
                            
                        }
                        
                    }
                    
                    teamSEL.userInteractionEnabled = false
                    
                }
                
            }
            
        }
        
    }
    
}