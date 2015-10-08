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
    @IBOutlet weak var displayTXT: UILabel!
    
    var nTXT: UITextField!
    
    var tracker: Tracker!
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
        
        title = "Player"
        
        table.tag = 1
        freqTBL.tag = 2
        
        if tracker.game.sequences.count > 0 {
            s = tracker.game.sequences[tracker.index]
        }
        
        if tracker.game.right_home {
            selectedTeam = tracker.game.away
            teamKey.removeAll(keepCapacity: true)
            teamKey.append(tracker.game.away)
            teamKey.append(tracker.game.home)
        } else {
            selectedTeam = tracker.game.home
            teamKey.removeAll(keepCapacity: true)
            teamKey.append(tracker.game.home)
            teamKey.append(tracker.game.away)
        }
        
        nsel = NumberSelector(nibName: "NumberSelector", bundle: nil)
        nsel.tracker = tracker
        
        ksel = KeySelector(nibName: "KeySelector", bundle: nil)
        ksel.tracker = tracker
        
        table.delegate = self
        table.dataSource = self
        freqTBL.delegate = self
        freqTBL.dataSource = self
        
        tracker.game.getPlayers()
        numbers = tracker.game.players
        
        reload()
        
        edgesForExtendedLayout = UIRectEdge()
        
//        nTXT = UITextField(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
//        nTXT.placeholder = "New #"
//        nTXT.font = UIFont.systemFontOfSize(14)
//        nTXT.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
//        nTXT.backgroundColor = UIColor.whiteColor()
//        nTXT.textAlignment = .Center
//        nTXT.layer.cornerRadius = 4
//        nTXT.keyboardType = UIKeyboardType.PhonePad
//        nTXT.delegate = self
//        
//        navigationItem.titleView = nTXT
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if nTXT.text != "" {
            
            let n = nTXT.text.toInt()!
            
            let newPlayer = Player(game: tracker.game, number: n)
            
            var foundPlayer: Player?
            for player in tracker.game.players {
                
                if player.number == newPlayer.number { foundPlayer = player }
                
            }
            
            if let p = foundPlayer {
                
                p.used++
                p.save(nil)
                
            } else {
                
                newPlayer.used++
                newPlayer.save(nil)
                numbers.insert(newPlayer, atIndex: 0)
                
            }
            
            selectPlayer(newPlayer)
            
        }
        
        return true
        
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var txt = UILabel()
        txt.textAlignment = .Center
        txt.font = UIFont.systemFontOfSize(12)
        txt.textColor = UIColor.whiteColor()
        txt.backgroundColor = UIColor(red: 147/255, green: 147/255, blue: 154/255, alpha: 1)
        
        if tableView.tag == 1 {
            
            txt.text = "Ordered"
            
            return txt
            
        } else {
            
            txt.text = "Most Used"
            
            return txt
            
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
                
                close()
                
            case "sack":
                
                s.plays[i].sacks.append(n.number)
                
                close()
                
            default:
                
                JP("NOTHING #")
                
            }
            
        } else {
            
            JP("NO NEW PLAY!")
            
        }
        // =========================================================
        // =========================================================
        
        if let penalty = newPenalty {
            
            penalty.player = n.number
            ksel.newPenalty = penalty
            ksel.type = "penalty_options"
            
            navigationController?.pushViewController(ksel, animated: false)
            
        } else {
            
            JP("NO NEW PENALTY!")
            
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
    
    @IBAction func numberTPD(sender: UIButton) {
        
        if displayTXT.text?.length() >= 2 {
            
            displayTXT.text = sender.tag.string()
            
        } else {
            
            displayTXT.text! += sender.tag.string()
            
        }
        
    }
    
    @IBAction func enterTPD(sender: AnyObject) {
        
        if displayTXT.text != "" {
            
            let n = displayTXT.text!.toInt()!
            
            let newPlayer = Player(game: tracker.game, number: n)
            
            var foundPlayer: Player?
            for player in tracker.game.players {
                
                if player.number == newPlayer.number { foundPlayer = player }
                
            }
            
            if let p = foundPlayer {
                
                p.used++
                p.save(nil)
                
            } else {
                
                newPlayer.used++
                newPlayer.save(nil)
                numbers.insert(newPlayer, atIndex: 0)
                
            }
            
            selectPlayer(newPlayer)
            
        }
        
    }
    
}

extension String {
    
    func length() -> Int {
        
        return count(self)
        
    }
    
}