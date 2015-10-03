//
//  Button2Tapped.swift
//  stats-football
//
//  Created by grobinson on 9/27/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit

extension Tracker {
    
    func button2Tapped(sender: UITapGestureRecognizer){
        
        let b: PointBTN = sender.view as! PointBTN
        
        let s = game.sequences[index]
        
        var alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        var tackle = UIAlertAction(title: "Tackle", style: UIAlertActionStyle.Default) { action -> Void in
            
            var nsel = NumberSelector(nibName: "NumberSelector",bundle: nil)
            nsel.tracker = self
            nsel.type = "tackle"
            nsel.newPlay = Play(s: s)
            nsel.i = b.index
            
            var nav = UINavigationController(rootViewController: nsel)
            
            self.popover = UIPopoverController(contentViewController: nav)
            self.popover.delegate = self
            self.popover.popoverContentSize = CGSize(width: 283, height: self.view.bounds.height * 0.6)
            self.popover.presentPopoverFromRect(b.frame, inView: self.field, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
            
        }
        
        var sack = UIAlertAction(title: "Sack", style: UIAlertActionStyle.Default) { action -> Void in
            
            var nsel = NumberSelector(nibName: "NumberSelector",bundle: nil)
            nsel.tracker = self
            nsel.type = "sack"
            nsel.newPlay = Play(s: s)
            nsel.i = b.index
            
            var nav = UINavigationController(rootViewController: nsel)
            
            self.popover = UIPopoverController(contentViewController: nav)
            self.popover.delegate = self
            self.popover.popoverContentSize = CGSize(width: 283, height: self.view.bounds.height * 0.6)
            self.popover.presentPopoverFromRect(b.frame, inView: self.field, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
            
        }
        
        var fumble = UIAlertAction(title: "Fumble", style: UIAlertActionStyle.Default) { action -> Void in
            
            var alert2 = UIAlertController(title: "Recovery", message: nil, preferredStyle: .ActionSheet)
            
            var away = UIAlertAction(title: String(self.game.away.short), style: .Default, handler: { action -> Void in
                
                self.newPlay = Play(s: s)
                self.newPlay?.key = .Fumble
                self.newPlay?.player_a = b.titleLabel?.text?.toInt()
                self.newPlay?.team = self.game.away
                
                var nsel = NumberSelector(nibName: "NumberSelector",bundle: nil)
                nsel.tracker = self
                nsel.newPlay = self.newPlay
                nsel.type = "player_b"
                
                var nav = UINavigationController(rootViewController: nsel)
                
                self.popover = UIPopoverController(contentViewController: nav)
                self.popover.delegate = self
                self.popover.popoverContentSize = CGSize(width: 283, height: self.view.bounds.height * 0.6)
                self.popover.presentPopoverFromRect(b.frame, inView: self.field, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
                
            })
            
            var home = UIAlertAction(title: String(self.game.home.short), style: .Default, handler: { action -> Void in
                
                self.newPlay = Play(s: s)
                self.newPlay?.key = .Fumble
                self.newPlay?.player_a = b.titleLabel?.text?.toInt()
                self.newPlay?.team = self.game.home
                
                var nsel = NumberSelector(nibName: "NumberSelector",bundle: nil)
                nsel.tracker = self
                nsel.newPlay = self.newPlay
                nsel.type = "player_b"
                
                var nav = UINavigationController(rootViewController: nsel)
                
                self.popover = UIPopoverController(contentViewController: nav)
                self.popover.delegate = self
                self.popover.popoverContentSize = CGSize(width: 283, height: self.view.bounds.height * 0.6)
                self.popover.presentPopoverFromRect(b.frame, inView: self.field, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
                
            })
            
            var no = UIAlertAction(title: "No Recovery", style: .Default, handler: { action -> Void in
                
                self.newPlay = Play(s: s)
                self.newPlay?.key = .Fumble
                self.newPlay?.player_a = b.titleLabel?.text?.toInt()
                
                self.spot()
                
            })
            
            var cancel2 = UIAlertAction(title: "Cancel", style: .Default, handler: { action -> Void in
                
                
                
            })
            
            alert2.addAction(home)
            alert2.addAction(away)
            alert2.addAction(no)
            alert2.addAction(cancel2)
            
            if let popoverController2 = alert2.popoverPresentationController {
                
                popoverController2.sourceView = b
                popoverController2.sourceRect = b.bounds
                
            }
            
            self.presentViewController(alert2, animated: false, completion: nil)
            
        }
        
        var delete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { action -> Void in
            
            var alert3 = UIAlertController(title: nil, message: "Delete this play?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            var delete2 = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { action -> Void in
                
                s.getPlays()
                let play = s.plays[b.index]
                play.delete(nil)
                s.plays.removeAtIndex(b.index)
                self.playTBL.plays.removeAtIndex(b.index)
                
                self.playTBL.deleteRowsAtIndexPaths([NSIndexPath(forRow: b.index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
                
                s.getPlays()
                self.playTBL.plays = s.plays
                
                self.field.setNeedsDisplay()
                self.drawButtons()
                
                self.MPC.sendGame(self.game)
                
            }
            
            var cancel3 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { action -> Void in
                
                self.newPlay = nil
                
            }
            
            alert3.addAction(delete2)
            alert3.addAction(cancel3)
            
            if let popoverController3 = alert3.popoverPresentationController {
                
                popoverController3.sourceView = b
                popoverController3.sourceRect = b.bounds
                
            }
            
            self.presentViewController(alert3, animated: true, completion: nil)
            
        }
        
//        alert.addAction(tackle)
//        alert.addAction(sack)
        alert.addAction(fumble)
        alert.addAction(delete)
        
        if let popoverController = alert.popoverPresentationController {
            
            popoverController.sourceView = b
            popoverController.sourceRect = b.bounds
            
        }
        
        presentViewController(alert, animated: false, completion: nil)
        
    }
    
}