//
//  SequenceScroll.swift
//  stats-football
//
//  Created by grobinson on 10/18/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class SequenceScroll: UIScrollView,UIScrollViewDelegate {
    
    var tracker: Tracker!
    
    var sequences: [Sequence] = []
    var cells: [SequenceItem] = []
    
    var viewWidth: CGFloat = 240
    var rightPadding: CGFloat = 0
    
    private let sAlpha: CGFloat = 0.3

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        
    }
    
    func reload(){
        
        sequences = tracker.game.sequences
        setData()
        
    }
    
    private func setData(){
        
        for v in subviews { v.removeFromSuperview() }
        
        cells.removeAll(keepCapacity: true)
        
        for (i,_sequence) in enumerate(sequences){
            
            let s = sequences[i]
            
            let S = SequenceItem(frame: CGRect(x: (viewWidth+rightPadding)*CGFloat(i), y: 0, width: viewWidth, height: frame.height), sequence: s)
            
            S.primary.tag = i
            
            if sequences.count > i+1 {
                
                let prev = sequences[i+1]
                
                S.nextVW.backgroundColor = prev.team.primary
                
            } else {
                
                S.nextVW.backgroundColor = UIColor.clearColor()
                
            }
            
            if let gr = S.primary.gestureRecognizers {
                
                for r in gr {
                    
                    S.primary.removeGestureRecognizer(r as! UIGestureRecognizer)
                    
                }
                
            }
            
            let tap = UITapGestureRecognizer()
            tap.numberOfTouchesRequired = 1
            tap.addTarget(self, action: "selectSequence:")
            S.primary.addGestureRecognizer(tap)
            
            let tap2 = UISwipeGestureRecognizer(target: self, action: "deleteConfirm:")
            tap2.direction = .Up
            S.primary.addGestureRecognizer(tap2)
            
            cells.append(S)
            
            addSubview(cells[i])
            
        }
        
        contentSize = CGSizeMake((viewWidth+rightPadding)*CGFloat(sequences.count),frame.height)
        
    }
    
    func reloadCell(column _column: Int){
        
        let cell = cells[_column]
        cell.setNeedsDisplay()
        
    }
    
    func unshiftSequence(sequence _sequence: Sequence){
        
        let S = SequenceItem(frame: CGRect(x: viewWidth * -1, y: 0, width: viewWidth, height: frame.height), sequence: _sequence)
        
        if sequences.count > 0 {
            
            let prev = sequences[0]
            
            S.nextVW.backgroundColor = prev.team.primary
            
        } else {
            
            S.nextVW.backgroundColor = UIColor.clearColor()
            
        }
        
        if let gr = S.primary.gestureRecognizers {
            
            for r in gr {
                
                S.primary.removeGestureRecognizer(r as! UIGestureRecognizer)
                
            }
            
        }
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTouchesRequired = 1
        tap.addTarget(self, action: "selectSequence:")
        S.primary.addGestureRecognizer(tap)
        
        let tap2 = UISwipeGestureRecognizer(target: self, action: "deleteConfirm:")
        tap2.direction = .Up
        S.primary.addGestureRecognizer(tap2)
        
        sequences.insert(_sequence, atIndex: 0)
        cells.insert(S, atIndex: 0)
        
        addSubview(cells[0])
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            for (i,cell) in enumerate(self.cells) {
                
                let _frame = CGRect(x: cell.frame.origin.x+(self.viewWidth+self.rightPadding), y: cell.frame.origin.y, width: cell.frame.width, height: cell.frame.height)
                
                cell.frame = _frame
                
            }
            
        }) { (success) -> Void in
            
            for (i,cell) in enumerate(self.cells) { cell.primary.tag = i }
            
            self.contentSize = CGSizeMake((self.viewWidth+self.rightPadding)*CGFloat(self.cells.count),self.frame.height)
            
        }
        
    }
    
    func scrollTo(i: Int){
        
        scrollRectToVisible(CGRectMake((viewWidth+rightPadding)*CGFloat(i), 0, viewWidth + rightPadding, frame.height), animated: true)
        
    }
    
    func setSelected(i: Int){
        
        for cell in cells {
            
            cell.selector.hidden = true
            
        }
        
        let S = cells[i]
        
        S.selector.hidden = false
        
    }
    
    func selectSequence(sender: UITapGestureRecognizer){
        
        let v = sender.view!
        
        tracker.selectSequence(v.tag)
        
    }
    
    func deleteConfirm(sender: UISwipeGestureRecognizer){
        
        let alert = UIAlertController(title: "Delete", message: "Are you sure you wish to delete this play?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let delete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { (action) -> Void in
            
            self.deleteSequence(sender)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            
            
        }
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        if let popoverController = alert.popoverPresentationController {
            
            popoverController.sourceView = sender.view!
            popoverController.sourceRect = sender.view!.bounds
            
        }
        
        tracker.presentViewController(alert, animated: false, completion: nil)
        
    }
    
    func deleteSequence(sender: UISwipeGestureRecognizer){
        
        let index = sender.view!.tag
        
        let _cell = cells[index]
        let s = sequences[index]
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.sendSubviewToBack(_cell)
            
            for (i,cell) in enumerate(self.cells) {
                
                if i >= index {
                    
                    let _f = CGRect(x: cell.frame.origin.x-(self.viewWidth+self.rightPadding), y: cell.frame.origin.y, width: cell.frame.width, height: cell.frame.height)
                    
                    cell.frame = _f
                    
                }
                
            }
            
        }) { (success) -> Void in
            
            s.delete(nil)
            
            _cell.removeFromSuperview()
            
            self.cells.removeAtIndex(index)
            self.sequences.removeAtIndex(index)
            self.tracker.game.sequences.removeAtIndex(index)
            
            for (i,cell) in enumerate(self.cells) {
                
                cell.primary.tag = i
                cell.frame = CGRect(x: (self.viewWidth+self.rightPadding)*CGFloat(i), y: 0, width: self.viewWidth, height: self.frame.height)
            
            }
            
            self.contentSize = CGSizeMake((self.viewWidth+self.rightPadding)*CGFloat(self.sequences.count),self.frame.height)
            
            self.tracker.selectSequence(0)
            
        }
        
    }

}