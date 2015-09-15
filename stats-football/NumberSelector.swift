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
    
    var tracker: TrackerCTRL!
    var newPlay: Play?
    var newPenalty: Penalty?
    var type: String!
    var i: Int!
    
    var nsel: NumberSelector!
    var ksel: KeySelector!
    
    var freq: [Player] = []
    
    var s: Sequence!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.tag = 1
        freqTBL.tag = 2
        
        if tracker.log.count > 0 {
            s = tracker.log[tracker.index]
        } else {
            s = Sequence()
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
        
        let getRandom = randomSequenceGenerator(min: 1, max: 99)
        
        var tmp: [Player] = []
        
        for _ in 1...34 {
            
            tmp.append(Player(n: getRandom()))
            
        }
        
        tracker.numbers = tmp
        
        edgesForExtendedLayout = UIRectEdge()
        
        freq = tracker.numbers
        
        tracker.numbers.sort({ $0.number < $1.number })
        freq.sort({ $0.used > $1.used })
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if nTXT.text != "" {
            
            let n = nTXT.text.toInt()
            
            let player = Player(n: n!)
            
            var foundPlayer: Player?
            for p in tracker.numbers {
                
                if p.number == player.number { foundPlayer = p }
                
            }
            
            if let p = foundPlayer {
                
                p.used++
                
            } else {
                
                player.used++
                tracker.numbers.insert(player, atIndex: 0)
                
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
            
            return tracker.numbers.count
            
        } else {
            
            return freq.count
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        var n: Player!
        
        if tableView.tag == 1 {
            
            n = tracker.numbers[indexPath.row]
            
        } else {
            
            n = freq[indexPath.row]
            
        }
        
        cell.textLabel?.text = "#\(n.number)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var n: Player!
        
        if tableView.tag == 1 {
            
            n = tracker.numbers[indexPath.row]
            n.used++
            freq = tracker.numbers
            
        } else {
            
            n = freq[indexPath.row]
            n.used++
            tracker.numbers = freq
            
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
                
                ()
                
            }
            
        }
        // =========================================================
        // =========================================================
        
        if let penalty = newPenalty {
            
            penalty.player = n.number
            ksel.newPenalty = penalty
            ksel.type = "penalty_options"
            
            navigationController?.pushViewController(ksel, animated: false)
            
        }
        
    }
    
    func close(){
        
        dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    func reload(){
        
        tracker.numbers.sort({ $0.number < $1.number })
        
        freq = tracker.numbers
        freq.sort({ $0.used > $1.used })
        
        table.reloadData()
        freqTBL.reloadData()
        
    }
    
}