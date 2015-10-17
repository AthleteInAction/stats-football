//
//  Penalty2Tapped.swift
//  stats-football
//
//  Created by grobinson on 9/28/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

extension Tracker {
    
    func penalty2Tapped(sender: UITapGestureRecognizer){
        
        let b: PenaltyMKR = sender.view as! PenaltyMKR
        
        let s = game.sequences[index]
        
        var alert = UIAlertController(title: "Delete this penalty?", message: nil, preferredStyle: .ActionSheet)
        
        var yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive) { action -> Void in
            
            let penalty = s.penalties[b.index]
            
            penalty.delete(nil)
            
            s.penalties.removeAtIndex(b.index)
            
            self.field.setNeedsDisplay()
            self.drawButtons()
            
            s.save(nil)
            self.updateScoreboard()
            
        }
        
        var no = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) { action -> Void in
            
            
            
        }
        
        alert.addAction(yes)
        alert.addAction(no)
        
        if let popoverController = alert.popoverPresentationController {
            
            popoverController.sourceView = b
            popoverController.sourceRect = b.bounds
            
        }
        
        presentViewController(alert, animated: false, completion: nil)
        
    }
    
}