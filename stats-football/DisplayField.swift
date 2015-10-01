//
//  DisplayField.swift
//  stats-football
//
//  Created by grobinson on 9/21/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class DisplayField: UIView {
    
    var dataDisplay: DataDisplay!
    
    var runs: [UIView]!
    var passes: [UIView]!
    var runTXTs: [UIView]!
    var passTXTs: [UIView]!
    
    var ratio: CGFloat!
    var vratio: CGFloat!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    override func drawRect(rect: CGRect){
        
        ratio = CGFloat(bounds.height) / 100
        vratio = CGFloat(bounds.width) / 53.33
        
        runs = [
            UIView(),
            UIView(),
            UIView(),
            UIView(),
            UIView()
        ]
        
        runTXTs = [
            UIView(),
            UIView(),
            UIView(),
            UIView(),
            UIView()
        ]
        
        passes = [
            UIView(),
            UIView(),
            UIView(),
            UIView(),
            UIView()
        ]
        
        passTXTs = [
            UIView(),
            UIView(),
            UIView(),
            UIView(),
            UIView()
        ]
        
        for view in runs {
            view.backgroundColor = Filters.colors(.Run, alpha: 0.9)
            addSubview(view)
        }
        for view in runTXTs {
            view.backgroundColor = Filters.colors(.Run, alpha: 0.9)
            var txt = UILabel()
            txt.textColor = UIColor.whiteColor()
            txt.font = UIFont.systemFontOfSize(9, weight: 3)
            view.addSubview(txt)
            addSubview(view)
        }
        
        for view in passes {
            view.backgroundColor = Filters.colors(.Pass, alpha: 0.9)
            addSubview(view)
        }
        for view in passTXTs {
            view.backgroundColor = Filters.colors(.Pass, alpha: 0.9)
            var txt = UILabel()
            txt.textColor = UIColor.whiteColor()
            txt.font = UIFont.systemFontOfSize(9, weight: 3)
            view.addSubview(txt)
            addSubview(view)
        }
        
        setViews()

    }
    
    func setViews() -> Bool {
        
//        for key in ["run","pass","run_1","run_2","run_3","run_4","run_5","pass_1","pass_2","pass_3","pass_4","pass_5"] {
//            
//            if dataDisplay.data[key] == nil { return false }
//            
//        }
        
        var run = dataDisplay.data["run"] as! CGFloat
        var pass = dataDisplay.data["pass"] as! CGFloat
        var height: CGFloat = 10
        
        let runSpots: [CGFloat] = [15,36,50,64,85]
        let runWidths: [CGFloat] = [0.29,0.14,0.14,0.14,0.29]
        
        for (i,view) in enumerate(runs) {
            
            if dataDisplay.data["run_\(i+1)"] != nil {
                
                let a = dataDisplay.data["run_\(i+1)"] as! CGFloat
                var pct = a / run
                if run == 0 { pct = 0 }
                
                if run > 0 {
                    height = (45*ratio) * pct
                }
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    
                    view.frame = CGRect(x: 0, y: (50*self.ratio)-height, width: self.bounds.width*runWidths[i]-4, height: height)
                    view.center.x = (runSpots[i]/100) * self.bounds.width
                    
                    self.runTXTs[i].frame = CGRect(x: view.frame.origin.x, y: 0, width: view.bounds.width, height: (3*self.ratio))
                    self.runTXTs[i].frame.origin.y = view.frame.origin.y - self.runTXTs[i].bounds.height
                    
                    for v in self.runTXTs[i].subviews {
                        let txt = v as! UILabel
                        let p = round(pct*1000)/10
                        txt.text = "\(p)%"
                        txt.textAlignment = .Center
                        txt.frame = CGRect(x: 0, y: 0, width: self.runTXTs[i].bounds.width, height: self.runTXTs[i].bounds.height)
                    }
                    
                })
                
            }
            
        }
        
        let passSpots: [CGFloat] = [10,30,50,70,90]
        
        for (i,view) in enumerate(passes) {
            
            if dataDisplay.data["pass_\(i+1)"] != nil {
                
                let a = dataDisplay.data["pass_\(i+1)"] as! CGFloat
                var pct = a / pass
                if pass == 0 { pct = 0 }
                
                if pass > 0 {
                    height = (45*ratio) * pct
                }
                
                let w: CGFloat = (0.2*self.bounds.width) - 2
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    
                    view.frame = CGRect(x: 0, y: (100*self.ratio)-height, width: w, height: height)
                    view.center.x = ((0.20 * (CGFloat(i)+1)) * self.bounds.width) - (0.1 * self.bounds.width)
                    
                    self.passTXTs[i].frame = CGRect(x: view.frame.origin.x, y: 0, width: view.bounds.width, height: (3*self.ratio))
                    self.passTXTs[i].frame.origin.y = view.frame.origin.y - self.passTXTs[i].bounds.height
                    
                    for v in self.passTXTs[i].subviews {
                        let txt = v as! UILabel
                        let p = round(pct*1000)/10
                        txt.text = "\(p)%"
                        txt.textAlignment = .Center
                        txt.frame = CGRect(x: 0, y: 0, width: self.passTXTs[i].bounds.width, height: self.passTXTs[i].bounds.height)
                    }
                    
                })
                
            }
            
        }
        
        return true
        
    }

}