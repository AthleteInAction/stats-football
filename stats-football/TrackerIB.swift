//
//  TrackerIB.swift
//  stats-football
//
//  Created by grobinson on 9/27/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit

extension Tracker {
    
    @IBAction func seekTPD(sender: UIButton) {
        
        if sender.tag == 1 {
            
            if index > 0 { index-- }
            
        } else {
            
            if index < game.sequences.count { index++ }
            
        }
        
        switch index {
        case 0 ... (game.sequences.count - 1):
            
            selectSequence(index)
            
        case _ where index < 0, _ where index > (game.sequences.count - 1):
            
            index = 0
            
            selectSequence(index)
            
        default:
            
            ()
            
        }
        
    }
    
    func playTypeChanged(sender: PlaytypeSelector) {
        
        let s = game.sequences[index]
        
        let pos_right = posRight(s)
        
        s.key = sender.selectedIndex.toPlaytype()
        
        if s.key == Playtype.Down {
            
            if let z = s.fd { } else {
                
                if let x = lastFD {
                    
                    s.fd = x
                    
                } else {
                    
                    s.fd = s.startX.increment(10)
                    
                }
                
            }
            
            if let z = s.down { } else {
                
                if let d = lastDOWN {
                    
                    s.down = d
                    
                } else {
                    
                    s.down = 1
                    
                }
                
            }
            
            field.fd.center.x = s.fd!.toX(pos_right)
            
        } else {
            
            s.fd = nil
            s.down = nil
            
        }
        
        field.fd.hidden = s.fd == nil
        
        s.save(nil)
        
        updateScoreboard()
        
    }
    
    func qtrChanged(sender: QuarterSelector) {
        
        let s = game.sequences[index]
        
        s.qtr = sender.qtr
        
        s.save(nil)
        
        updateScoreboard()
        
    }
    
    func downChanged(sender: DownSelector) {
        
        let s = game.sequences[index]
        
        s.down = sender.down
        
        s.save(nil)
        
        updateDown()
        
    }
    
    func posChanged(sender: UITapGestureRecognizer) {
        
        let v = sender.view!
        
        let s = game.sequences[index]
        
        if game.right_home {
            
            if v.tag == 1 {
                
                s.team = game.home
                
            } else {
                
                s.team = game.away
                
            }
            
        } else {
            
            if v.tag == 1 {
                
                s.team = game.away
                
            } else {
                
                s.team = game.home
                
            }
            
        }
        
        s.save(nil)
        
        sequenceSC.reloadCell(column: index)
        
        updateScoreboard()
        
        draw.setNeedsDisplay()
        drawButtons(false)
        
    }
    
    func switchTPD(sender: UITapGestureRecognizer) {
        
        let s = game.sequences[index]
        
        let alert = UIAlertController(title: "Switch Sides", message: "Advance to next quarter?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            self.game.right_home = !self.game.right_home
            self.game.save(nil)
            
            s.qtr = s.qtr + 1
            s.save(nil)
            
            self.updateScoreboard()
            self.draw.setNeedsDisplay()
            self.drawButtons(false)
            
        }
        
        let no = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            self.game.right_home = !self.game.right_home
            self.game.save(nil)
            
            self.updateScoreboard()
            self.draw.setNeedsDisplay()
            self.drawButtons(false)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive) { (action) -> Void in
            
            
            
        }
        
        alert.addAction(yes)
        alert.addAction(no)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelTPD(sender: AnyObject) {
        
        enterOn = false
        
        enableField()
        enableScoreboard()
        field.hideCrosses()
        field.highlight.hidden = true
        
        newPlay = nil
        newPenalty = nil
        
        tn = nil
        sn = nil
        
    }
    
    @IBAction func penaltyTPD(sender: PenaltyBTN) {
        
        let s = game.sequences[index]
        
        let newPenalty = Penalty(s: s)
        newPenalty.team = sender.team
        
        var vc = KeySelector(nibName: "KeySelector",bundle: nil)
        vc.tracker = self
        vc.title = "\(sender.team.short) Penalty"
        vc.newPenalty = newPenalty
        vc.type = "penalty_distance"
        
        var nav = UINavigationController(rootViewController: vc)
        
        popover = UIPopoverController(contentViewController: nav)
        popover.delegate = self
        popover.popoverContentSize = CGSize(width: 500, height: view.bounds.height * 0.85)
        popover.presentPopoverFromRect(sender.frame, inView: panel, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
        
    }
    
    @IBAction func statsTPD(sender: AnyObject) {
        
        let vc = StatsDisplay(nibName: "StatsDisplay",bundle: nil)
        vc.game = game
        
        if sender.tag == 0 {
            
            vc.team = game.away
            
        } else {
            
            vc.team = game.home
            
        }
        
        let nav = UINavigationController(rootViewController: vc)
        
        presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func backTPD(sender: UIBarButtonItem){
        
        UIApplication.sharedApplication().idleTimerDisabled = false
        MPC.stopAdvertising()
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    func exportTPD(sender: AnyObject){
        
        let vc = RemoteSave(nibName: "RemoteSave",bundle: nil)
        vc.game = game
        
        let nav = UINavigationController(rootViewController: vc)
        
        presentViewController(nav, animated: true, completion: nil)
        
    }
    
    @IBAction func docsTPD(sender: AnyObject){
        
        let conf = UIAlertController(title: "Finished!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        conf.addAction(ok)
        
        let alert = UIAlertController(title: "Send Summary", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        var txt: UITextField!
        
        func addTextField(_txt: UITextField!){
            
            _txt.placeholder = "Email"
            _txt.keyboardType = UIKeyboardType.EmailAddress
            _txt.text = last_email.string()
            txt = _txt
            
        }
        
        alert.addTextFieldWithConfigurationHandler(addTextField)
        
        let send = UIAlertAction(title: "Send", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            if txt.text != "" {
                
                last_email.setValue(txt.text)
                
                Loading.start()
                
                self.game.sendSummary(email: txt.text, completion: { (error) -> Void in
                    
                    if error == nil {
                        
                        
                        
                    } else {
                        
                        conf.message = "There was an error!"
                        
                    }
                    
                    self.presentViewController(conf, animated: true, completion: nil)
                    
                    Loading.stop()
                    
                })
            }
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive) { (action) -> Void in
            
            
            
        }
        
        alert.addAction(send)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func scrollFirst(sender: UIButton){
        
        sequenceSC.scrollTo(0)
        
    }
    
    @IBAction func eraseTPD(sender: UIButton){
        
        let s = game.sequences[index]
        
        if let penalty = s.penalties.last {
            
            let i = s.penalties.count - 1
            
            penalty.delete(nil)
            s.penalties.removeAtIndex(i)
            
            draw.setNeedsDisplay()
            drawButtons(false)
            
            s.scoreSave(nil)
            updateScoreboard()
            
            sequenceSC.reloadCell(column: index)
            
        } else {
            
            if let play = s.plays.last {
                
                let i = s.plays.count - 1
                
                play.delete(nil)
                s.plays.removeAtIndex(i)
                
                draw.setNeedsDisplay()
                drawButtons(false)
                
                s.scoreSave(nil)
                updateScoreboard()
                
                sequenceSC.reloadCell(column: index)
                
            }
            
        }
        
    }
    
}