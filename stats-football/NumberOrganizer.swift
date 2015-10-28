//
//  NumberOrganizer.swift
//  stats-football
//
//  Created by grobinson on 10/20/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class NumberOrganizer: UIView {
    
    var tracker: Tracker!
    
    @IBOutlet weak var numberTXT: UILabel!
    
    @IBOutlet var nTBL: [NumberTable]!
    @IBOutlet weak var player_a: UILabel!
    @IBOutlet weak var player_b: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib()
        
    }
    
    override func drawRect(frame: CGRect){
        
        numberTXT.text = ""
        
        setNumbers()
        
    }
    
    func loadViewFromNib(){
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "NumberOrganizer", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        view.frame = bounds
        
        self.addSubview(view)
        
    }
    
    func setNumbers(){
        
        for (i,tbl) in enumerate(nTBL) {
            
            var tblView =  UIView(frame: CGRectZero)
            tbl.tableFooterView = tblView
            tbl.tableFooterView?.hidden = true
            tbl.backgroundColor = UIColor.clearColor()
            
            switch i {
            case 1:
                
                tbl.title = "QB"
                tbl.players = tracker.game.players.filter { player in player.is_qb }
                
            case 2:
                
                tbl.title = "RB"
                tbl.players = tracker.game.players.filter { player in player.is_rb }
                
            case 3:
                
                tbl.title = "REC"
                tbl.players = tracker.game.players.filter { player in player.is_rec }
                
            case 4:
                
                tbl.title = "K"
                tbl.players = tracker.game.players.filter { player in player.is_k }
                
            default:
                
                tbl.title = "ALL"
                tbl.players = tracker.game.players
                
            }
            
            tbl.players.sort { $0.number < $1.number }
            tbl.reloadData()
            
        }
    
    }
    
    @IBAction func numberTPD(sender: UIButton){
        
        if numberTXT.text?.length() >= 2 {
            
            numberTXT.text = sender.tag.string()
            
        } else {
            
            numberTXT.text! += sender.tag.string()
            
        }
        
    }

    @IBAction func enterTPD(sender: UIButton){
        
        if numberTXT.text != "" {
            
            let n = numberTXT.text!.toInt()!
            
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
                tracker.game.players.append(newPlayer)
                
            }
            
//            selectPlayer(newPlayer)
            
        }
        
    }
    
}