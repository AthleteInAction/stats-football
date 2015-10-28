//
//  DownSelector.swift
//  stats-football
//
//  Created by grobinson on 10/17/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class DownSelector: UIScrollView,UIScrollViewDelegate {
    
    var tracker: Tracker!
    
    var items: [Int] = [1,2,3,4]
    
    var down: Int = 1
    var togo: String = 10.string()
    
    var textAlignment: NSTextAlignment = .Center
    var textColor: UIColor = UIColor.whiteColor()
    var font: UIFont = UIFont.systemFontOfSize(14, weight: 0.25)
    
    var index = 0
    
    override init(frame _frame: CGRect){
        super.init(frame: _frame)
        
        backgroundColor = UIColor.clearColor()
        
        pagingEnabled = true
        delegate = self
    
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
    }
    
    override func drawRect(rect: CGRect) {
        
        for v in subviews { v.removeFromSuperview() }
        
        for (i,item) in enumerate(items) {
            
            let label = UILabel(frame: CGRect(x: 0, y: frame.height*CGFloat(i), width: frame.width, height: frame.height))
            label.textAlignment = textAlignment
            label.textColor = textColor
            label.font = font
            
            var txt = ""
            
            switch item {
            case 2: txt = "2nd"
            case 3: txt = "3rd"
            case 4: txt = "4th"
            default: txt = "1st"
            }
            
            txt += " and "+togo
            
            label.text = txt
            
            addSubview(label)
            
        }
        
        contentSize = CGSizeMake(frame.width, frame.height*CGFloat(items.count))
        
        scrollRectToVisible(CGRectMake(0, CGFloat(down-1)*frame.height, frame.width, frame.height), animated: true)
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        
        var pageHeight = frame.height
        
        down = Int(floor((scrollView.contentOffset.y-pageHeight/2)/pageHeight)+1) + 1
        
        tracker.downChanged(self)
        
    }
    
    func setD(_down: Int){
        
        down = _down
        setNeedsDisplay()
        
    }
    
}