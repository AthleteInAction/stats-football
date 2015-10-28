//
//  NumberScroll.swift
//  stats-football
//
//  Created by grobinson on 10/20/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class NumberScroll: UIScrollView,UIScrollViewDelegate {
    
    var players: [Player] = []
    
    var columnWidth: CGFloat = 34
    var padding: CGFloat = 10
    var color: UIColor = Filters.colors(.Sacked, alpha: 1)
    var textColor: UIColor = UIColor.whiteColor()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        
    }
    
    override func drawRect(rect: CGRect) {
        
        setData()
        
    }
    
    func setData(){
        
        for v in subviews { v.removeFromSuperview() }
        
        for (i,player) in enumerate(players) {
            
            let x = (columnWidth + padding) * CGFloat(i)
            
            let button = UIView(frame: CGRect(x: x, y: 0, width: columnWidth, height: frame.height))
            button.backgroundColor = color
            
            let txt = UILabel(frame: CGRect(x: 0, y: 0, width: button.frame.width, height: button.frame.height))
            txt.textColor = textColor
            txt.textAlignment = .Center
            txt.font = UIFont.systemFontOfSize(13, weight: 0.75)
            txt.text = "#"+player.number.string()
            
            let tap = UITapGestureRecognizer()
            tap.addTarget(self, action: "buttonTPD:")
            button.addGestureRecognizer(tap)
            
            button.addSubview(txt)
            
            addSubview(button)
            
        }
        
        contentSize = CGSizeMake((columnWidth + padding)*CGFloat(players.count),frame.height)
        
    }
    
    func buttonTPD(sender: UITapGestureRecognizer){
        
        let button = sender.view!
        
        if let v: AnyObject = button.subviews.first {
            
            let txt = v as! UILabel
            
            txt.alpha = 0.2
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                txt.alpha = 1
                
            })
            
        }
        
    }
    
}