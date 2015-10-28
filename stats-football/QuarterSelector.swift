//
//  QuarterSelector.swift
//  stats-football
//
//  Created by grobinson on 10/17/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class QuarterSelector: UIScrollView,UIScrollViewDelegate {
    
    var tracker: Tracker!
    
    private var items: [AnyObject] = [true,true,true,true]
    
    var qtr: Int = 1
    
    var textAlignment: NSTextAlignment = .Center
    var textColor: UIColor = UIColor.whiteColor()
    var font: UIFont = UIFont.systemFontOfSize(14, weight: 0.25)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        pagingEnabled = true
        delegate = self
        
    }
    
    override func drawRect(rect: CGRect) {
        
        for v in subviews { v.removeFromSuperview() }
        
        for (i,item) in enumerate(items) {
            
            let _qtr = i+1
            
            let label = UILabel(frame: CGRect(x: frame.width*CGFloat(i), y: 0, width: frame.width, height: frame.height))
            label.textAlignment = textAlignment
            label.textColor = textColor
            label.font = font
            
            var txt = ""
            switch _qtr {
            case 1: txt = "1st QTR"
            case 2: txt = "2nd QTR"
            case 3: txt = "3rd QTR"
            case 4: txt = "4th QTR"
            default:
                txt = "OT \((_qtr)-4)"
            }
            
            label.text = txt
            
            addSubview(label)
            
        }
        
        contentSize = CGSizeMake(frame.width*CGFloat(items.count), frame.height)
        
        scrollRectToVisible(CGRectMake(CGFloat(qtr-1)*frame.width, 0, frame.width, frame.height), animated: true)
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        
        var pageWidth = frame.width
        
        qtr = Int(floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1) + 1
        
        tracker.qtrChanged(self)
        
        if qtr >= items.count {
            
            items.append(true)
            setNeedsDisplay()
            
        }
        
    }
    
    func setQuater(_qtr: Int){
        
        qtr = _qtr
        
        var tmp: [AnyObject] = []
        for i in 1..._qtr+1 {
            
            tmp.append(true)
            
        }
        
        items = tmp
        setNeedsDisplay()
        
    }
    
}