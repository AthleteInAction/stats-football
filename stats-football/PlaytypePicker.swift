//
//  PlaytypePicker.swift
//  stats-football
//
//  Created by grobinson on 10/17/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PlaytypePicker: UIPickerView,UIPickerViewDelegate,UIPickerViewDataSource {
    
    let types: [Playtype] = [.Kickoff,.Down,.PAT]

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
        
    }
    
    override func drawRect(rect: CGRect) {
        
        let aShape = CAShapeLayer()
        aShape.backgroundColor = UIColor.clearColor().CGColor
        aShape.bounds = frame
        aShape.position = center
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, CGRectMake(0, 0, frame.width, frame.height))
        aShape.path = path
        layer.mask = aShape
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return types.count
        
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        let txt = UILabel()
//        txt.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        txt.textColor = UIColor.whiteColor()
        txt.text = types[row].display
        txt.font = UIFont.systemFontOfSize(17, weight: 0.5)
        txt.textAlignment = .Center
        
        return txt
        
    }

}