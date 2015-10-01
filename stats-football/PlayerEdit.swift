//
//  PlayerEdit.swift
//  stats-football
//
//  Created by grobinson on 9/18/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PlayerEdit: UIViewController,UITextFieldDelegate {
    
    var teamDetail: TeamDetail!
    var editPlayer: Player?
    
    @IBOutlet weak var numberTXT: UITextField!
    @IBOutlet weak var firstTXT: UITextField!
    @IBOutlet weak var lastTXT: UITextField!
    @IBOutlet weak var saveBTN: UIButton!
    @IBOutlet weak var cancelBTN: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Player"
        
        saveBTN.layer.cornerRadius = 3
        cancelBTN.layer.cornerRadius = 3
        
        numberTXT.delegate = self
        firstTXT.delegate = self
        lastTXT.delegate = self
        
        numberTXT.addTarget(self, action:"textChanged:", forControlEvents: UIControlEvents.EditingChanged)
        
        edgesForExtendedLayout = UIRectEdge()
        
        if let p = editPlayer {
            
            title = "Edit Player"
            numberTXT.text = "#\(p.number)"
            if let n = p.first_name { firstTXT.text = n }
            if let n = p.last_name { lastTXT.text = n }
            
        } else {
            
            saveBTN.alpha = 0.3
            saveBTN.userInteractionEnabled = false
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        dismissKeyboard()
        
    }
    
    func textChanged(sender: UITextField) {
        
        if numberTXT.text == "" {
            
            saveBTN.alpha = 0.3
            saveBTN.userInteractionEnabled = false
            
        } else {
            
            saveBTN.alpha = 1
            saveBTN.userInteractionEnabled = true
            
        }
        
    }
    
    func dismissKeyboard(){
        
        numberTXT.endEditing(true)
        firstTXT.endEditing(true)
        lastTXT.endEditing(true)
        
    }
    
    @IBAction func saveTPD(sender: AnyObject) {
        
        save()
        
    }
    
    func save() -> Bool {
        
//        if numberTXT.text == "" { return false }
//        
//        var player: Player!
//        
//        if let p = editPlayer {
//            player = p
//        } else {
//            player = Player(game: tracker.game, number: numberTXT.text.toInt()!)
//        }
//        
//        if firstTXT.text != "" { player.first_name = firstTXT.text }
//        if lastTXT.text != "" { player.last_name = lastTXT.text }
//        
//        player.save(nil)
//        
//        teamDetail.team.roster.insert(player, atIndex: 0)
//        teamDetail.rosterTBL.reloadData()
//        teamDetail.main.gamesTBL.getData()
//        teamDetail.main.teamsTBL.getData()
//        
//        dismissKeyboard()
//        dismissViewControllerAnimated(true, completion: nil)
        
        return true
        
    }
    
    @IBAction func cancelTPD(sender: AnyObject) {
        
        dismissKeyboard()
        dismissViewControllerAnimated(true, completion: nil)
        
    }

}