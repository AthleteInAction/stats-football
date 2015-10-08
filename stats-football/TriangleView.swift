import Foundation
import UIKit

class TriangeView : UIView {
    
    var color: UIColor!
    
    init(frame _frame: CGRect,color _color: UIColor){
        super.init(frame: _frame)
        
        color = _color
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        
        backgroundColor = UIColor.clearColor()
        
        var ctx : CGContextRef = UIGraphicsGetCurrentContext()
        
        CGContextBeginPath(ctx)
        CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect))
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        CGContextAddLineToPoint(ctx, (CGRectGetMaxX(rect)/2.0), CGRectGetMinY(rect))
        CGContextClosePath(ctx)
        
        CGContextSetFillColorWithColor(ctx, color.CGColor)
        CGContextFillPath(ctx)
        
    }
    
}