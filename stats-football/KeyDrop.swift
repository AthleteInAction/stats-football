//
//  KeyDrop.swift
//  stats-football
//
//  Created by grobinson on 10/22/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class KeyDrop: UIView {
    
    var keys: [Key] = [.Run,.Pass,.Incomplete,.Interception,.Punt,.Sacked,.FumbledSnap,.BadSnap,.Recovery,.FGA,.FGM]
    
    var buttons: [UIView] = []
    
    var cover: UIView!
    var txt: UILabel!
    
    var open = false
    
    var selected: Key?
    
    private var originalHeight: CGFloat!
    
    override func drawRect(rect: CGRect) {
        
        cover = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        cover.backgroundColor = Filters.colors(.Sacked, alpha: 1)
        cover.tag = -1
        
        txt = UILabel(frame: cover.frame)
        txt.text = "Select:"
        txt.textColor = UIColor.whiteColor()
        txt.textAlignment = .Center
        txt.font = UIFont.systemFontOfSize(12, weight: 0.3)
        
        cover.addSubview(txt)
        
        insertSubview(cover, atIndex: 1000)
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: "openClose:")
        
//        cover.addGestureRecognizer(tap)
        
        originalHeight = frame.height
        
    }
    
    func setOpen(){
        
        open = true
        
        for v in subviews {
            
            if v.tag != -1 { v.removeFromSuperview() }
            
        }
        
        buttons.removeAll(keepCapacity: true)
        
        for (i,key) in enumerate(keys) {
            
            let button = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: originalHeight))
            button.backgroundColor = Filters.colors(key, alpha: 1)
            button.tag = i
            
            let _txt = UILabel(frame: CGRect(x: 0, y: 0, width: button.frame.width, height: button.frame.height))
            _txt.text = key.passed
            _txt.textColor = UIColor.whiteColor()
            _txt.textAlignment = .Center
            _txt.font = UIFont.systemFontOfSize(12, weight: 0.3)
            
            button.addSubview(_txt)
            
            let tap = UITapGestureRecognizer()
            tap.addTarget(self, action: "selectKey:")
//            button.addGestureRecognizer(tap)
            
            buttons.append(button)
            
            insertSubview(button, atIndex: i)
            
        }
        
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: (frame.height + 2) * CGFloat(keys.count))
        
        for (i,button) in enumerate(buttons) {
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                
                let _frame = CGRect(x: 0, y: CGFloat(i+1)*(self.originalHeight + 2), width: self.frame.width, height: self.originalHeight)
                
                button.frame = _frame
                
            })
            
        }
        
    }
    
    func setClosed(){
        
        open = false
        
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: originalHeight)
        
        for (i,button) in enumerate(buttons) {
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                
                let _frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.originalHeight)
                
                button.frame = _frame
                
            }, completion: { (success) -> Void in
                
                
                button.removeFromSuperview()
                
            })
            
        }
        
    }
    
    func openClose(sender: UITapGestureRecognizer){
        
        if open {
            
            setClosed()
            
        } else {
            
            setOpen()
            
        }
        
    }
    
    func selectKey(sender: UITapGestureRecognizer){
        
        let key = keys[sender.view!.tag]
        
        cover.backgroundColor = Filters.colors(key, alpha: 1)
        txt.textColor = Filters.textColors(key, alpha: 1)
        txt.text = key.passed
        
        selected = key
        
        setClosed()
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        setOpen()
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        setClosed()
        
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        
        setClosed()
        
    }

}