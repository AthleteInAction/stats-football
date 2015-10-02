//
//  RunPassBar.swift
//  stats-football
//
//  Created by grobinson on 10/2/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class RunPassBar: UIView {
    
    var _data: TeamData!
    var ready = false
    
    var run: UIView!
    var runTXT: UILabel!
    var pass: UIView!
    var passTXT: UILabel!
    
    override func drawRect(rect: CGRect) {
        
        if !ready {
            
            run = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width / 2, height: bounds.height))
            run.backgroundColor = Filters.colors(.Run, alpha: 1)
            runTXT = UILabel(frame: CGRect(x: 0, y: 0, width: run.bounds.width, height: run.bounds.height))
            runTXT.textAlignment = .Center
            runTXT.font = UIFont.systemFontOfSize(20, weight: 4)
            runTXT.textColor = UIColor.whiteColor()
            runTXT.text = "50% (0)"
            run.addSubview(runTXT)
            addSubview(run)
            
            pass = UIView(frame: CGRect(x: bounds.width / 2, y: 0, width: bounds.width / 2, height: bounds.height))
            pass.backgroundColor = Filters.colors(.Pass, alpha: 1)
            passTXT = UILabel(frame: CGRect(x: 0, y: 0, width: pass.bounds.width, height: pass.bounds.height))
            passTXT.textAlignment = .Center
            passTXT.font = UIFont.systemFontOfSize(20, weight: 4)
            passTXT.textColor = UIColor.whiteColor()
            passTXT.text = "50% (0)"
            pass.addSubview(passTXT)
            addSubview(pass)
            
        } else {
            
            var runPCT: CGFloat {
                
                if (_data.run + _data.pass) == 0 { return 0 }
                
                return CGFloat(_data.run) / (CGFloat(_data.run) + CGFloat(_data.pass))
                
            }
            var runWidth = bounds.width * runPCT
            if runWidth < 100 { runWidth = 100 }
            if runWidth > (bounds.width - 100) { runWidth = bounds.width - 100 }
            runTXT.text = "\(round(runPCT*1000)/10)% (\(_data.run))"
            
            var passPCT: CGFloat {
                
                if (_data.pass + _data.run) == 0 { return 0 }
                
                return CGFloat(_data.pass) / (CGFloat(_data.run) + CGFloat(_data.pass))
                
            }
            var passWidth = bounds.width * passPCT
            if passWidth < 100 { passWidth = 100 }
            if passWidth > (bounds.width - 100) { passWidth = bounds.width - 100 }
            passTXT.text = "\(round(passPCT*1000)/10)% (\(_data.pass))"
            
            if runPCT == 0 && passPCT == 0 {
                
                runWidth = bounds.width / 2
                passWidth = runWidth
                
            }
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                let _runFrame = CGRect(x: 0, y: 0, width: runWidth, height: self.bounds.height)
                self.run.frame = _runFrame
                let _runTXTFrame = CGRect(x: 0, y: 0, width: self.run.bounds.width, height: self.run.bounds.height)
                self.runTXT.frame = _runTXTFrame
                
                let _passFrame = CGRect(x: self.run.bounds.width, y: 0, width: passWidth, height: self.bounds.height)
                self.pass.frame = _passFrame
                let _passTXTFrame = CGRect(x: 0, y: 0, width: self.pass.bounds.width, height: self.pass.bounds.height)
                self.passTXT.frame = _passTXTFrame
                
            })
            
        }
        
        ready = true
        
    }

}