//
//  NumberSelector.swift
//  stats-football
//
//  Created by grobinson on 9/7/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class NumberSelector: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var freqTBL: UITableView!
    @IBOutlet weak var nTXT: UITextField!
    @IBOutlet weak var teamSEL: UISegmentedControl!
    
    var tracker: TrackerCTRL!
    var newPlay: Play?
    var newPenalty: Penalty?
    var type: String!
    var i: Int!
    
    var nsel: NumberSelector!
    var ksel: KeySelector!
    
    var freq: [Player] = []
    var numbers: [Player] = []
    
    var s: Sequence!
    
    var teamKey: [Team] = []
    var selectedTeam: Team!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.tag = 1
        freqTBL.tag = 2
        
        if tracker.game.sequences.count > 0 {
            s = tracker.game.sequences[tracker.index]
        } else {
            s = Sequence()
        }
        
        if tracker.rightHome {
            selectedTeam = tracker.game.away
            teamSEL.setTitle(tracker.game.home.short, forSegmentAtIndex: 1)
            teamSEL.setTitle(tracker.game.away.short, forSegmentAtIndex: 0)
            teamKey.removeAll(keepCapacity: true)
            teamKey.append(tracker.game.away)
            teamKey.append(tracker.game.home)
        } else {
            selectedTeam = tracker.game.home
            teamSEL.setTitle(tracker.game.home.short, forSegmentAtIndex: 0)
            teamSEL.setTitle(tracker.game.away.short, forSegmentAtIndex: 1)
            teamKey.removeAll(keepCapacity: true)
            teamKey.append(tracker.game.home)
            teamKey.append(tracker.game.away)
        }
        
        nsel = NumberSelector(nibName: "NumberSelector", bundle: nil)
        nsel.tracker = tracker
        
        ksel = KeySelector(nibName: "KeySelector", bundle: nil)
        ksel.tracker = tracker
        
        nTXT.delegate = self
        
        table.delegate = self
        table.dataSource = self
        freqTBL.delegate = self
        freqTBL.dataSource = self
        
        var po = tracker.game.home.object.roster.allObjects as! [PlayerObject]
        println(po.count)
        var home: [Player] = []
        for p in po {
            
            let player = Player(object: p)
            
            home.append(player)
            
        }
        var pa = tracker.game.away.object.roster.allObjects as! [PlayerObject]
        println(pa.count)
        for p in pa {
            
            let player = Player(object: p)
            
            if !hasPlayer(items: home, player: player) {
                
                home.append(player)
                
            }
            
        }
        println(home.count)
        numbers = home
        
        reload()
        
        edgesForExtendedLayout = UIRectEdge()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if nTXT.text != "" {
            
            let n = nTXT.text.toInt()!
            
            let player = Player(team: selectedTeam, number: n)
            
            var foundPlayer: Player?
            for p in tracker.numbers {
                
                if p.number == player.number { foundPlayer = p }
                
            }
            
            if let p = foundPlayer {
                
                p.used++
                
            } else {
                
                player.used++
                player.save(nil)
                numbers.insert(player, atIndex: 0)
                
            }
            
            selectPlayer(player)
            
        }
        
        return true
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        nTXT.endEditing(true)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            
            return numbers.count
            
        } else {
            
            return freq.count
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        var n: Player!
        
        if tableView.tag == 1 {
            
            n = numbers[indexPath.row]
            
        } else {
            
            n = freq[indexPath.row]
            
        }
        
        cell.textLabel?.text = "#\(n.number)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var n: Player!
        
        if tableView.tag == 1 {
            
            n = numbers[indexPath.row]
            n.used++
            n.save(nil)
            freq = numbers
            
        } else {
            
            n = freq[indexPath.row]
            n.used++
            n.save(nil)
            numbers = freq
            
        }
        
        selectPlayer(n)
        
    }
    
    func selectPlayer(n: Player){
        
        // =========================================================
        // =========================================================
        if let play = newPlay {
            
            switch type {
            case "player_a":
                
                play.player_a = n.number
                
                ksel.type = "play_key_select"
                ksel.newPlay = play
                
                navigationController?.pushViewController(ksel, animated: false)
                
            case "player_b":
                
                play.player_b = n.number
                
                tracker.newPlay = play
                
                tracker.spot()
                
                close()
                
            case "tackle":
                
                s.plays[i].tackles.append(n.number)
                
                tracker.draw()
                
                close()
                
            case "sack":
                
                s.plays[i].sacks.append(n.number)
                
                tracker.draw()
                
                close()
                
            default:
                
                println("NOTHING #")
                
            }
            
        } else {
            
            println("NO NEW PLAY!")
            
        }
        // =========================================================
        // =========================================================
        
        if let penalty = newPenalty {
            
            penalty.player = n.number
            ksel.newPenalty = penalty
            ksel.type = "penalty_options"
            
            navigationController?.pushViewController(ksel, animated: false)
            
        } else {
            
            println("NO NEW PENALTY!")
            
        }
        
    }
    
    func close(){
        
        dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    func reload(){
        
        numbers.sort({ $0.number < $1.number })
        freq = numbers
        freq.sort({ $0.used > $1.used })
        
        table.reloadData()
        freqTBL.reloadData()
        
    }
    
    func hasPlayer(items _items: [Player],player _player: Player) -> Bool {
        
        for p in _items {
            
            if p.number == _player.number {
                
                return true
                
            }
            
        }
        
        return false
        
    }
    
    @IBAction func teamChanged(sender: UISegmentedControl) {
        
        selectedTeam = teamKey[sender.selectedSegmentIndex]
        
    }
    
}