//
//  PenaltyMKR.swift
//  stats-football
//
//  Created by grobinson on 9/6/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PenaltyMKR: UIView {
    
    var field: Field!
    
    var index: Int!
    
    var pan = UIPanGestureRecognizer()
    
    var lastLocation: CGPoint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.yellowColor()
        alpha = 0.6
        
        pan = UIPanGestureRecognizer(target: self, action: "dDrag:")
        addGestureRecognizer(pan)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        lastLocation = center
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        
        
    }
    
    func dDrag(sender: UIPanGestureRecognizer){
        
        var translation  = sender.translationInView(superview!)
        
        var nex = round((lastLocation.x + translation.x) / field.ratio) * field.ratio
        
        center.x = nex
        
    }
    
    func setArrow(right: Bool){
        
        let x = bounds.width / 2
        let y = bounds.height / 2
        
        var img = UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        
        img.center.x = x
        img.center.y = y
        img.contentMode = UIViewContentMode.ScaleAspectFit
        
        if right {
        
            img.image = UIImage(named: "arrow_r.png")
            
        } else {
            
            img.image = UIImage(named: "arrow_l.png")
            img.frame.origin.x = bounds.width * -1
            
        }
        
        addSubview(img)
        
    }

}
