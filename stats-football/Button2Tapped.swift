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
        
        let s = game.sequences[index]
        
        var alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        var tackle = UIAlertAction(title: "Tackle", style: UIAlertActionStyle.Default) { action -> Void in
            
            var nsel = NumberSelector(nibName: "NumberSelector",bundle: nil)
            nsel.tracker = self
            nsel.type = "tackle"
            nsel.newPlay = Play(s: s)
            nsel.i = sender.view!.tag
            
            var nav = UINavigationController(rootViewController: nsel)
            
            self.popover = UIPopoverController(contentViewController: nav)
            self.popover.delegate = self
            self.popover.popoverContentSize = CGSize(width: 500, height: self.view.bounds.height * 0.7)
            self.popover.presentPopoverFromRect(sender.view!.frame, inView: self.field, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
            
        }
        
        var sack = UIAlertAction(title: "Sack", style: UIAlertActionStyle.Default) { action -> Void in
            
            var nsel = NumberSelector(nibName: "NumberSelector",bundle: nil)
            nsel.tracker = self
            nsel.type = "sack"
            nsel.newPlay = Play(s: s)
            nsel.i = sender.view!.tag
            
            var nav = UINavigationController(rootViewController: nsel)
            
            self.popover = UIPopoverController(contentViewController: nav)
            self.popover.delegate = self
            self.popover.popoverContentSize = CGSize(width: 500, height: self.view.bounds.height * 0.6)
            self.popover.presentPopoverFromRect(sender.view!.frame, inView: self.field, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
            
        }
        
        var fumble = UIAlertAction(title: "Fumble", style: UIAlertActionStyle.Default) { action -> Void in
            
            var alert2 = UIAlertController(title: "Recovery", message: nil, preferredStyle: .ActionSheet)
            
            var away = UIAlertAction(title: String(self.game.away.short), style: .Default, handler: { action -> Void in
                
                let p = Play(s: s)
                let play = s.plays[sender.view!.tag]
                p.key = .Fumble
                switch play.key as Key {
                case .Pass,.Interception: p.player_a = play.player_b!
                default: p.player_a = play.player_a
                }
                p.team = self.game.away
                
                var nsel = NumberSelector(nibName: "NumberSelector",bundle: nil)
                nsel.tracker = self
                nsel.newPlay = p
                nsel.type = "player_b"
                
                var nav = UINavigationController(rootViewController: nsel)
                
                self.popover = UIPopoverController(contentViewController: nav)
                self.popover.delegate = self
                self.popover.popoverContentSize = CGSize(width: 500, height: self.view.bounds.height * 0.6)
                self.popover.presentPopoverFromRect(sender.view!.frame, inView: self.field, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
                
            })
            
            var home = UIAlertAction(title: String(self.game.home.short), style: .Default, handler: { action -> Void in
                
                let p = Play(s: s)
                let play = s.plays[sender.view!.tag]
                p.key = .Fumble
                switch play.key as Key {
                case .Pass,.Interception: p.player_a = play.player_b!
                default: p.player_a = play.player_a
                }
                p.team = self.game.home
                
                var nsel = NumberSelector(nibName: "NumberSelector",bundle: nil)
                nsel.tracker = self
                nsel.newPlay = p
                nsel.type = "player_b"
                
                var nav = UINavigationController(rootViewController: nsel)
                
                self.popover = UIPopoverController(contentViewController: nav)
                self.popover.delegate = self
                self.popover.popoverContentSize = CGSize(width: 500, height: self.view.bounds.height * 0.6)
                self.popover.presentPopoverFromRect(sender.view!.frame, inView: self.field, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
                
            })
            
            var no = UIAlertAction(title: "No Recovery", style: .Default, handler: { action -> Void in
                
                let p = Play(s: s)
                let play = s.plays[sender.view!.tag]
                p.key = .Fumble
                p.player_a = play.player_a
                
                self.spot()
                
            })
            
            var cancel2 = UIAlertAction(title: "Cancel", style: .Default, handler: { action -> Void in
                
                
                
            })
            
            alert2.addAction(home)
            alert2.addAction(away)
            alert2.addAction(no)
            alert2.addAction(cancel2)
            
            if let popoverController2 = alert2.popoverPresentationController {
                
                popoverController2.sourceView = sender.view!
                popoverController2.sourceRect = sender.view!.bounds
                
            }
            
            self.presentViewController(alert2, animated: false, completion: nil)
            
        }
        
        var delete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { action -> Void in
            
            var alert3 = UIAlertController(title: nil, message: "Delete this play?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            var delete2 = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { action -> Void in
                
                let play = s.plays[sender.view!.tag]
                play.delete(nil)
                s.plays.removeAtIndex(sender.view!.tag)
                
                self.field.setNeedsDisplay()
                self.drawButtons()
                
                MPC.sendGame(self.game)
                
            }
            
            var cancel3 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { action -> Void in
                
                
                
            }
            
            alert3.addAction(delete2)
            alert3.addAction(cancel3)
            
            if let popoverController3 = alert3.popoverPresentationController {
                
                popoverController3.sourceView = sender.view!
                popoverController3.sourceRect = sender.view!.bounds
                
            }
            
            self.presentViewController(alert3, animated: true, completion: nil)
            
        }
        
//        alert.addAction(tackle)
//        alert.addAction(sack)
        alert.addAction(fumble)
        alert.addAction(delete)
        
        if let popoverController = alert.popoverPresentationController {
            
            popoverController.sourceView = sender.view!
            popoverController.sourceRect = sender.view!.bounds
            
        }
        
        presentViewController(alert, animated: false, completion: nil)
        
    }
    
}