//
//  RemoteSaveViewController.swift
//  stats-football
//
//  Created by grobinson on 10/9/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class RemoteSave: UIViewController {
    
    var game: Game!
    
    var thingsToSave: Int = 0
    var thingsSaved: Int = 0
    var thingsUnsaved: Int = 0

    @IBOutlet weak var bar: UIView!
    var gbar: UIView!
    @IBOutlet weak var labelTXT: UILabel!
    @IBOutlet weak var pctTXT: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge()
        
        let close = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "closeTPD:")
        
        navigationItem.setLeftBarButtonItem(close, animated: true)
        
        labelTXT.text = ""
        
        Rhino.run({
        
            self.startSave()
        
        }, completion: { () -> Void in
            
            
            
        })
        
        gbar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: bar.bounds.height))
        gbar.backgroundColor = Filters.colors(.Pass, alpha: 1)
        bar.addSubview(gbar)
        bar.layer.cornerRadius = 6
        gbar.layer.cornerRadius = 6
        pctTXT.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func startSave(){
        
        var q = NSOperationQueue()
        q.maxConcurrentOperationCount = 1
        
        gbar.frame = CGRect(x: 0, y: 0, width: 0, height: bar.bounds.height)
        
        thingsToSave += 3
        thingsToSave += game.sequences.count
        
        for _sequence in game.sequences {
            thingsToSave += _sequence.plays.count
            thingsToSave += _sequence.penalties.count
        }
        
        labelTXT.text = "Saving \(game.away.name)..."
        
        game.away.remoteSave { (error1) -> Void in
            
            dispatch_async(dispatch_get_main_queue()){
                
                if error1 == nil {
                    
                    self.thingsSaved++
                    self.labelTXT.text = "Saving \(self.game.home.name)..."
                    self.game.home.remoteSave({ (error2) -> Void in
                        
                        dispatch_async(dispatch_get_main_queue()){
                            
                            if error2 == nil {
                                
                                self.thingsSaved++
                                self.labelTXT.text = "Saving game \(self.game.away.short) @ \(self.game.home.short)..."
                                self.game.remoteSave({ (error3) -> Void in
                                    
                                    dispatch_async(dispatch_get_main_queue()){
                                        
                                        if error3 == nil {
                                            
                                            self.thingsSaved++
                                            self.saveSequences()
                                            
                                        } else {
                                            
                                            self.thingsUnsaved++
                                            self.thingsUnsaved += self.game.sequences.count
                                            
                                        }
                                        
                                        self.updateProccess()
                                        
                                    }
                                    
                                })
                                
                            } else {
                                
                                self.thingsUnsaved++
                                
                            }
                            
                            self.updateProccess()
                            
                        }
                        
                    })
                    
                } else {
                    
                    self.thingsUnsaved++
                    
                }
                
                self.updateProccess()
                
            }
            
        }
        
    }
    
    func saveSequences(){
        
        self.labelTXT.text = "Saving plays..."
        
        for _sequence in game.sequences {
            
            dispatch_async(dispatch_get_main_queue()){
                
            _sequence.remoteSave({ (error) -> Void in
                
                dispatch_async(dispatch_get_main_queue()){
                    
                    if error == nil {
                        
                        self.thingsSaved++
                        self.savePlays(_sequence)
                        self.savePenalties(_sequence)
                        
                    } else {
                        
                        self.thingsUnsaved++
                        self.thingsUnsaved += _sequence.plays.count
                        self.thingsUnsaved += _sequence.penalties.count
                        
                    }
                    
                    self.updateProccess()
                    
                }
                
            })
                
            }
            
            usleep(250*1000)
            
        }
        
    }
    
    func savePlays(_sequence: Sequence){
        
        for _play in _sequence.plays {
            
            dispatch_async(dispatch_get_main_queue()){
                
            _play.remoteSave({ (error) -> Void in
                
                dispatch_async(dispatch_get_main_queue()){
                    
                    if error == nil {
                        
                        self.thingsSaved++
                        
                    } else {
                        
                        self.thingsUnsaved++
                        
                    }
                    
                    self.updateProccess()
                    
                }
                
            })
                
            }
            
            usleep(250*1000)
            
        }
        
    }
    func savePenalties(_sequence: Sequence){
        
        for _penalty in _sequence.penalties {
            
            dispatch_async(dispatch_get_main_queue()){
                
            _penalty.remoteSave({ (error) -> Void in
                
                dispatch_async(dispatch_get_main_queue()){
                    
                    if error == nil {
                        
                        self.thingsSaved++
                        
                    } else {
                        
                        self.thingsUnsaved++
                        
                    }
                    
                    self.updateProccess()
                    
                }
                
            })
                
            }
            
            usleep(250*1000)
            
        }
        
    }
    
    func updateProccess(){
        
        pctTXT.hidden = false
        
        let pct = round((Float(thingsSaved + thingsUnsaved) / Float(thingsToSave))*1000) / 10
        
        JP2("\(pct)% : \(thingsSaved):\(thingsUnsaved) TOTAL: \(thingsToSave)")
        
        dispatch_async(dispatch_get_main_queue()){
            
        self.gbar.frame = CGRect(x: 0, y: 0, width: self.bar.bounds.width * CGFloat(pct/100), height: self.bar.bounds.height)
        self.pctTXT.text = "\(pct)%"
        
        if pct >= 100 {
            self.labelTXT.text = "Done!"
            if self.thingsUnsaved > 0 {
                self.labelTXT.text = "Done with errors: \(self.thingsUnsaved)"
            }
        }
            
        }
        
    }
    
    func closeTPD(sender: UIBarButtonItem){
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }

}