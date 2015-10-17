//
//  PointVW.swift
//  stats-football
//
//  Created by grobinson on 10/7/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PenaltyVW: UIView {
    
    let a = UILabel()
    let b = UILabel()
    let c = UILabel()
    
    var third = false
    
    var penalty: Penalty!
    var index: Int!
    
    init(penalty _penalty: Penalty){
        
        penalty = _penalty
        
        var txt = _penalty.team.short+" "
        if let player = _penalty.player { txt += "#\(player)" }
        
        a.text = txt
        b.text = "\(_penalty.distance) Yards"
        
        var ctxt = ""
        
        if _penalty.replay {
            third = true
            ctxt = "Replay"
        }
        if _penalty.fd {
            third = true
            ctxt = "First Down"
        }
        
        switch _penalty.enforcement as Key {
        case .Declined,.Offset,.OnKick:
            if third { ctxt += "\n" }
            ctxt += _penalty.enforcement.displayShort
            third = true
        default: ()
        }
        
        c.text = ctxt
        
        super.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        
    }
    
    override init(frame _frame: CGRect){
        super.init(frame: _frame)
        
        self.backgroundColor = UIColor.clearColor()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clearColor()
        
    }
    
    override func drawRect(rect: CGRect) {
        
        self.backgroundColor = UIColor.clearColor()
        
        a.textAlignment = .Center
        a.backgroundColor = penalty.team.primary
        a.textColor = penalty.team.secondary
        a.font = UIFont.systemFontOfSize(10, weight: 1)
        a.sizeToFit()
        a.frame = CGRect(x: 0, y: 0, width: Int(a.frame.width + 8), height: Int(a.frame.height + 6))
        a.center.x = bounds.width/2
        
        var width = a.bounds.width
        
        b.textAlignment = .Center
        b.backgroundColor = Filters.colors(.Penalty, alpha: 1)
        b.textColor = Filters.textColors(.Penalty, alpha: 1)
        b.font = UIFont.systemFontOfSize(10)
        b.sizeToFit()
        b.frame = CGRect(x: 0, y: 0, width: Int(b.frame.width + 8), height: Int(b.frame.height + 6))
        b.center.x = bounds.width/2
        b.frame.origin.y = round(a.bounds.height)
        
        if b.bounds.width > width { width = b.bounds.width }
        
        c.numberOfLines = 0
        c.textAlignment = .Center
        c.backgroundColor = Filters.colors(.Penalty, alpha: 1)
        c.textColor = Filters.textColors(.Penalty, alpha: 1)
        c.font = UIFont.systemFontOfSize(10)
        c.sizeToFit()
        c.frame = CGRect(x: 0, y: 0, width: Int(c.frame.width + 8), height: Int(c.frame.height + 6))
        c.center.x = bounds.width/2
        c.frame.origin.y = round(a.bounds.height) + round(b.bounds.height)
        
        var height = a.bounds.height + b.bounds.height
        
        addSubview(a)
        addSubview(b)
        
        if third {
            
            if c.bounds.width > width { width = c.bounds.width }
            
            height += c.bounds.height
            addSubview(c)
            
        }
        
        var cnt = center
        
        frame = CGRect(x: Int(frame.origin.x), y: Int(frame.origin.y), width: Int(width), height: Int(height))
        
        a.frame = CGRect(x: 0, y: 0, width: Int(width), height: Int(a.bounds.height))
        b.frame = CGRect(x: 0, y: Int(a.bounds.height), width: Int(width), height: Int(b.bounds.height))
        
        if third {
            
            c.frame = CGRect(x: 0, y: Int(a.bounds.height)+Int(b.bounds.height), width: Int(width), height: Int(c.bounds.height))
            
        }
        
        let cr: CGFloat = 4
        
        layer.cornerRadius = cr
        
        let aShape = CAShapeLayer()
        aShape.backgroundColor = UIColor.clearColor().CGColor
        aShape.bounds = a.frame
        aShape.position = a.center
        aShape.path = UIBezierPath(roundedRect: a.bounds, byRoundingCorners: .TopRight | .TopLeft, cornerRadii: CGSize(width: cr, height: cr)).CGPath
        a.layer.mask = aShape
        
        if third {
            
            let bShape = CAShapeLayer()
            bShape.backgroundColor = UIColor.clearColor().CGColor
            bShape.bounds = c.frame
            bShape.position = c.center
            bShape.path = UIBezierPath(roundedRect: c.bounds, byRoundingCorners: .BottomRight | .BottomLeft, cornerRadii: CGSize(width: cr, height: cr)).CGPath
            c.layer.mask = bShape
            
        } else {
            
            let bShape = CAShapeLayer()
            bShape.backgroundColor = UIColor.clearColor().CGColor
            bShape.bounds = b.frame
            bShape.position = b.center
            bShape.path = UIBezierPath(roundedRect: b.bounds, byRoundingCorners: .BottomRight | .BottomLeft, cornerRadii: CGSize(width: cr, height: cr)).CGPath
            b.layer.mask = bShape
            
        }
        
        center = cnt
        
//        let triangle = TriangeView(frame: CGRect(x: 0, y: -6, width: 10, height: 6), color: Filters.colors(.Penalty, alpha: 1))
//        triangle.center.x = round(bounds.width/2)
//        triangle.backgroundColor = UIColor.clearColor()
//        addSubview(triangle)
//        
//        let triangle2 = TriangeView(frame: CGRect(x: 0, y: Int(bounds.height), width: 10, height: 6), color: Filters.colors(.Penalty, alpha: 1))
//        triangle2.center.x = round(bounds.width/2)
//        triangle2.backgroundColor = UIColor.clearColor()
//        triangle2.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
//        addSubview(triangle2)
        
    }
    
}