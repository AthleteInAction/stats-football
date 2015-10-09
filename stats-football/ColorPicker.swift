//
//  ColorPicker.swift
//  stats-football
//
//  Created by grobinson on 9/18/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

protocol ColorPickerPTC {
    
    func colorSelected(i: Int,color: UIColor)
    
}

class ColorPicker: UIViewController {
    
    //MARK: - Second example - rainbow buttons
    
    var delegate: ColorPickerPTC!
    
    var color: UIColor!
    var index: Int!
    
    @IBOutlet weak var showVW: UIView!
    
    func displayColor(sender:UIButton){
        var r:CGFloat = 0,g:CGFloat = 0,b:CGFloat = 0
        var a:CGFloat = 0
        var h:CGFloat = 0,s:CGFloat = 0,l:CGFloat = 0
        let color = sender.backgroundColor!
        if color.getHue(&h, saturation: &s, brightness: &l, alpha: &a){
            if color.getRed(&r, green: &g, blue: &b, alpha: &a){
                let colorText = NSString(format: "HSB: %4.2f,%4.2f,%4.2f RGB: %4.2f,%4.2f,%4.2f",
                    Float(h),Float(s),Float(b),Float(r),Float(g),Float(b))
                delegate.colorSelected(index,color: sender.backgroundColor!)
            }
        }
        showVW.backgroundColor = color
    }
    
    func makeRainbowButtons(buttonFrame:CGRect, sat:CGFloat, bright:CGFloat){
        var myButtonFrame = buttonFrame
        //populate an array of buttons
        for i in 0..<12{
            let hue:CGFloat = CGFloat(i) / 12.0
            let color = UIColor(hue: hue, saturation: sat, brightness: bright, alpha: 1.0)
            let aButton = UIButton(frame: myButtonFrame)
            myButtonFrame.origin.x = myButtonFrame.size.width + myButtonFrame.origin.x
            aButton.backgroundColor = color
            view.addSubview(aButton)
            aButton.addTarget(self, action: "displayColor:", forControlEvents: UIControlEvents.TouchUpInside)
            
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var buttonFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
        var i:CGFloat = 1.0
        while i > 0{
            makeRainbowButtons(buttonFrame, sat: i ,bright: 1.0)
            i = i - 0.1
            buttonFrame.origin.y = buttonFrame.origin.y + buttonFrame.size.height
        }
        showVW.backgroundColor = color
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        showVW.backgroundColor = UIColor.whiteColor()
        delegate.colorSelected(index,color: UIColor.whiteColor())
        
    }
    
}