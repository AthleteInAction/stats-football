//
//  HorizontalSelector.swift
//  stats-football
//
//  Created by grobinson on 10/17/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PlaytypeSelector: UIScrollView,UIScrollViewDelegate {
    
    var tracker: Tracker!
    
    var items: [Playtype] = [.Kickoff,.Down,.PAT]
    
    var selectedIndex: Int = 0
    
    var textAlignment: NSTextAlignment = .Center
    var textColor: UIColor = UIColor.whiteColor()
    var font: UIFont = UIFont.systemFontOfSize(14, weight: 0.25)
    
    var index = 0
    
    var downSEL: DownSelector!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        pagingEnabled = true
        delegate = self
        
        downSEL = DownSelector(frame: CGRect(x: frame.width, y: 0, width: frame.width, height: frame.height))
        
    }
    
    override func drawRect(rect: CGRect) {
        
        for v in subviews { v.removeFromSuperview() }
        
        for (i,item) in enumerate(items) {
            
            if item == .Down {
                
                downSEL.frame = CGRect(x: frame.width*CGFloat(i), y: 0, width: frame.width, height: frame.height)
                downSEL.tracker = tracker
                
                addSubview(downSEL)
                
            } else {
                
                let label = UILabel(frame: CGRect(x: frame.width*CGFloat(i), y: 0, width: frame.width, height: frame.height))
                
                label.textAlignment = textAlignment
                label.textColor = textColor
                label.font = font
                label.text = item.display
                
                addSubview(label)
                
            }
            
        }
        
        contentSize = CGSizeMake(frame.width*CGFloat(items.count), frame.height)
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        
        var pageWidth = frame.width
        
        selectedIndex = Int(floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1)
        
        tracker.playTypeChanged(self)
        
    }
    
    func setPage(i: Int){
        
        selectedIndex = i
        
        scrollRectToVisible(CGRectMake(CGFloat(i)*frame.width, 0, frame.width, frame.height), animated: true)
        
    }

}