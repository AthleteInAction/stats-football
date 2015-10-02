//
//  SectionView.swift
//  stats-football
//
//  Created by grobinson on 10/2/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class SectionView: UIView {
    
    var type: Key = .Run
    var sections: [Int] = []
    var items: [Int] = []
    var total: Int = 0
    
    var views: [UIView] = []
    var labels: [UIView] = []
    var txts: [UILabel] = []
    
    var ready = false
    
    var hratio: CGFloat!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
    }
    
    override func drawRect(rect: CGRect) {
        
        hratio = bounds.height / 50
        
        let labelHeight = 3 * hratio
        
        if !ready {
            
            var cx: CGFloat = 0
            for (i,section) in enumerate(sections) {
                
                var a: CGFloat = 0
                if i > 0 { a = sections[i-1].percent() }
                var b: CGFloat = section.percent()
                var c = b - a
                
                let _view = UIView(frame: CGRect(x: (cx * bounds.width)+2, y: bounds.height, width: c*bounds.width-4, height: 0))
                _view.backgroundColor = Filters.colors(type, alpha: 0.6)
                addSubview(_view)
                views.append(_view)
                
                let _label = UIView(frame: CGRect(x: _view.frame.origin.x, y: bounds.height - labelHeight, width: 0, height: labelHeight))
                _label.backgroundColor = Filters.colors(type, alpha: 0.9)
                
                let _txt = UILabel(frame: CGRect(x: 0, y: 0, width: _label.bounds.width, height: _label.bounds.height))
                _txt.textAlignment = .Center
                _txt.textColor = UIColor.whiteColor()
                _txt.font = UIFont.systemFontOfSize(12, weight: 1)
                _txt.text = "0% (0)"
                
                _label.addSubview(_txt)
                txts.append(_txt)
                
                addSubview(_label)
                labels.append(_label)
                
                cx = section.percent()
                
            }
            
        } else {
            
            for (i,section) in enumerate(items) {
                
                let _view = views[i]
                _view.backgroundColor = Filters.colors(type, alpha: 0.6)
                
                let _label = labels[i]
                _label.backgroundColor = Filters.colors(type, alpha: 0.9)
                
                let _txt = txts[i]
                
                var pct: CGFloat {
                    
                    if total == 0 {
                        
                        return 0
                        
                    } else {
                        
                        return CGFloat(section) / CGFloat(total)
                        
                    }
                    
                }
                
                _txt.text = "\(round(pct*1000)/10)% (\(section))"
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    
                    let _frame = CGRect(x: _view.frame.origin.x, y: self.bounds.height, width: _view.bounds.width, height: (pct * (self.bounds.height - labelHeight)) * -1)
                    _view.frame = _frame
                    
                    let _Lframe = CGRect(x: _view.frame.origin.x, y: (self.bounds.height - _view.bounds.height) - labelHeight, width: _view.bounds.width, height: labelHeight)
                    _label.frame = _Lframe
                    
                    _txt.frame = CGRect(x: 0, y: 0, width: _label.bounds.width, height: _label.bounds.height)
                    
                })
                
            }
            
        }
        
        ready = true
        
    }
    
}