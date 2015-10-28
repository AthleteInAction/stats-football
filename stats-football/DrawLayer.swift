//
//  DrawLayer.swift
//  stats-football
//
//  Created by grobinson on 10/17/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class DrawLayer: UIView {
    
    var tracker: Tracker!
    
    var ready = false

    override func drawRect(rect: CGRect) {
        
        ratio = CGFloat(bounds.width) / 120
        vratio = CGFloat(bounds.height) / 53.33
        
        if !ready {
            
            tracker.setData()
            
        } else {
            
            if tracker.game.sequences.count > 0 {
                
                let s = tracker.game.sequences[tracker.index]
                
                let c = UIGraphicsGetCurrentContext()
                
                let pos_right: Bool = tracker.posRight(s)
                
                var x = s.startX.toX(pos_right)
                var y = s.startY.toP() * bounds.height
                if pos_right { y = (100 - s.startY).toP() * bounds.height }
                
                var prev: Play?
                for (i,play) in enumerate(s.plays) {
                    
                    if let endX = play.endX {
                        
                        if i == 0 {
                            
                            switch play.key as Key {
                            case .Run:
                                
                                x = s.startX.increment(-3).toX(pos_right)
                                
                            case .Pass,.Incomplete,.Interception:
                                
                                x = s.startX.increment(-4).toX(pos_right)
                                
                            case .Punt:
                                
                                x = s.startX.increment(-12).toX(pos_right)
                                
                            default:
                                
                                x = s.startX.toX(pos_right)
                                
                            }
                            
                        }
                        
                        CGContextMoveToPoint(c,CGFloat(x),CGFloat(y))
                        
                        x = endX.toX(pos_right)
                        y = play.endY!.toP() * bounds.height
                        if tracker.posRight(s) { y = (100 - play.endY!).toP() * bounds.height }
                        
                        CGContextSetLineWidth(c, 10.0)
                        
                        var color = Filters.colors(play.key, alpha: 1).CGColor
                        
                        switch play.key as Key {
                        case .Pass,.Incomplete,.Interception,.Punt,.Kick:
                            CGContextSetLineDash(c, 10, [6,3], 2)
                        default:
                            CGContextSetLineDash(c, 0, [0,0], 0)
                        }
                        
                        CGContextSetStrokeColorWithColor(c,color)
                        
                        switch play.key as Key {
                        case .FGM,.FGA,.Sacked: ()
                        default:
                            
                            CGContextAddLineToPoint(c,CGFloat(x),CGFloat(y))
                            CGContextStrokePath(c)
                            
                        }
                        
                        CGContextMoveToPoint(c,CGFloat(x),CGFloat(y))
                        
                        prev = play
                        
                    }
                    
                }
                
            }
            
        }
        
        ready = true
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
    }

}