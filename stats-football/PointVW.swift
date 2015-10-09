//
//  PointVW.swift
//  stats-football
//
//  Created by grobinson on 10/7/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PointVW: UIView {
    
    let a = UILabel()
    let b = UILabel()
    
    var key: Key!
    var team: Team!
    var index: Int!
    
    init(number _number: Int,key _key: Key,team _team: Team){
        
        key = _key
        team = _team
        
        var txt = _team.short+" "
        txt += "#\(_number)"
        
        a.text = txt
        b.text = _key.displayShort
        
        super.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        
    }
    
    override init(frame _frame: CGRect){
        super.init(frame: _frame)
        
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
    }
    
    override func drawRect(rect: CGRect) {
        
        backgroundColor = UIColor.clearColor()
        
        a.textAlignment = .Center
        a.backgroundColor = team.primary
        a.textColor = team.secondary
        a.font = UIFont.systemFontOfSize(10, weight: 1)
        a.sizeToFit()
        a.frame = CGRect(x: 0, y: 0, width: Int(a.frame.width + 8), height: Int(a.frame.height + 6))
        a.center.x = bounds.width/2
        
        var width = a.bounds.width
        
        b.textAlignment = .Center
        b.backgroundColor = Filters.colors(key, alpha: 1)
        b.textColor = Filters.textColors(key, alpha: 1)
        b.font = UIFont.systemFontOfSize(10)
        b.sizeToFit()
        b.frame = CGRect(x: 0, y: 0, width: Int(b.frame.width + 8), height: Int(b.frame.height + 6))
        b.center.x = bounds.width/2
        b.frame.origin.y = round(a.bounds.height)
        
        if b.bounds.width > width { width = b.bounds.width }
        
        var height = a.bounds.height + b.bounds.height
        
        addSubview(a)
        addSubview(b)
        
        var c = center
        
        frame = CGRect(x: Int(frame.origin.x), y: Int(frame.origin.y), width: Int(width), height: Int(height))
        
        a.frame = CGRect(x: 0, y: 0, width: Int(width), height: Int(a.bounds.height))
        b.frame = CGRect(x: 0, y: Int(a.bounds.height), width: Int(width), height: Int(b.bounds.height))
        
        let cr: CGFloat = 4
        
        layer.cornerRadius = cr
        
        let aShape = CAShapeLayer()
        aShape.bounds = a.frame
        aShape.position = a.center
        aShape.path = UIBezierPath(roundedRect: a.bounds, byRoundingCorners: .TopRight | .TopLeft, cornerRadii: CGSize(width: cr, height: cr)).CGPath
        a.layer.mask = aShape
        
        let bShape = CAShapeLayer()
        bShape.bounds = b.frame
        bShape.position = b.center
        bShape.path = UIBezierPath(roundedRect: b.bounds, byRoundingCorners: .BottomRight | .BottomLeft, cornerRadii: CGSize(width: cr, height: cr)).CGPath
        b.layer.mask = bShape
        
        center = c
        
        let triangle = TriangeView(frame: CGRect(x: 0, y: -6, width: 10, height: 6), color: Filters.colors(key, alpha: 1))
        triangle.center.x = round(bounds.width/2)
        triangle.backgroundColor = UIColor.clearColor()
        addSubview(triangle)
        
        let triangle2 = TriangeView(frame: CGRect(x: 0, y: Int(bounds.height), width: 10, height: 6), color: Filters.colors(key, alpha: 1))
        triangle2.center.x = round(bounds.width/2)
        triangle2.backgroundColor = UIColor.clearColor()
        triangle2.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
        addSubview(triangle2)
        
    }
    
}