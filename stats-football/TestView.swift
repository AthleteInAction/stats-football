//
//  TestView.swift
//  stats-football
//
//  Created by grobinson on 10/18/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

@IBDesignable class TestView: UIView {

    @IBOutlet weak var label: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        loadViewFromNib()
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        loadViewFromNib()
        
    }
    
    func loadViewFromNib(){
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "TestView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        view.frame = bounds
//        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        self.addSubview(view)
        
    }

}