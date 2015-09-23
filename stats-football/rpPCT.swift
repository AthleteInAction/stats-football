//
//  rpPCT.swift
//  stats-football
//
//  Created by grobinson on 9/21/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class rpPCT: UIView {
    
    var dataDisplay: DataDisplay!
    
    var run: UIView!
    var runTXT: UILabel!
    var pass: UIView!
    var passTXT: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
    }
    
    override func drawRect(rect: CGRect) {
        
        run = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width/2, height: bounds.height))
        run.backgroundColor = Filters.colors("run", alpha: 1)
        addSubview(run)
        
        runTXT = UILabel(frame: run.frame)
        runTXT.textColor = UIColor.whiteColor()
        runTXT.font = UIFont.systemFontOfSize(16, weight: 3)
        runTXT.textAlignment = .Center
        runTXT.text = "50.0%"
        addSubview(runTXT)
        
        pass = UIView(frame: CGRect(x: run.bounds.width, y: 0, width: bounds.width/2, height: bounds.height))
        pass.backgroundColor = Filters.colors("pass", alpha: 1)
        addSubview(pass)
        
        passTXT = UILabel(frame: pass.frame)
        passTXT.textColor = UIColor.whiteColor()
        passTXT.font = UIFont.systemFontOfSize(16, weight: 3)
        passTXT.textAlignment = .Center
        passTXT.text = "50.0%"
        addSubview(passTXT)
        
        setViews()
        
    }
    
    func setViews() -> Bool {
        
        if dataDisplay.data["run"] == nil || dataDisplay.data["pass"] == nil { return false }
        
        let runs: CGFloat = dataDisplay.data["run"] as! CGFloat
        let passes: CGFloat = dataDisplay.data["pass"] as! CGFloat
        var total = runs + passes
        if total == 0 { total = 1 }
        var runPCT = (runs / total)
        var passPCT = (passes / total)
        
        var runWidth = self.bounds.width*runPCT
        var passWidth = self.bounds.width*passPCT
        
        if runWidth == 0 && passWidth == 0 {
            runWidth = bounds.width*0.5
            passWidth = runWidth
        }
        
        let min: CGFloat = 50
        let max: CGFloat = bounds.width - 50
        
        if runWidth < min { runWidth = min }
        if passWidth < min { passWidth = min }
        if runWidth > max { runWidth = max }
        if passWidth > max { passWidth = max }
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.run.frame = CGRect(x: 0, y: 0, width: runWidth, height: self.bounds.height)
            self.pass.frame = CGRect(x: self.run!.bounds.width, y: 0, width: passWidth, height: self.bounds.height)
            
        })
        
        UILabel.animateWithDuration(0.5, animations: { () -> Void in
            
            self.runTXT.frame = self.run.frame
            var pct = round(runPCT*1000)/10
            self.runTXT.text = "\(pct)%"
            
            self.passTXT.frame = self.pass.frame
            pct = round(passPCT*1000)/10
            self.passTXT.text = "\(pct)%"
            
        })
        
        return true
        
    }

}