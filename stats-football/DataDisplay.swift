//
//  DataDisplay.swift
//  stats-football
//
//  Created by grobinson on 9/20/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class DataDisplay: UIViewController,MPCManagerReceiver,MPCManagerStateChanged {
    
    var peerPicker: PeerPicker!
    
    var connect: UIBarButtonItem!
    var disconnect: UIBarButtonItem!
    var ai: UIActivityIndicatorView!
    var at: UIView!
    var cover: UIView!
    
    var game: [String:AnyObject] = [
        "home": [
            "name":"",
            "short":"",
            "plays": []
        ],
        "away": [
            "name":"",
            "short":"",
            "plays": []
        ]
    ]
    
    @IBOutlet weak var runVIEW: SectionView!
    @IBOutlet weak var passVIEW: SectionView!
    @IBOutlet weak var rpVIEW: RunPassBar!
    @IBOutlet weak var homeBTN: UIButton!
    @IBOutlet weak var awayBTN: UIButton!
    @IBOutlet weak var togoTXT: UILabel!
    @IBOutlet weak var threshTXT: UILabel!
    @IBOutlet var downSWT: [UISwitch]!
    @IBOutlet weak var togoSLDR: UISlider!
    @IBOutlet weak var threshSLDR: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MPC.receiver = self
        MPC.stateMonitor = self
        MPC.startBrowsing()
        
        var close = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "closeTPD:")
        navigationItem.setLeftBarButtonItem(close, animated: true)
        
        connect = UIBarButtonItem(title: "Connect", style: UIBarButtonItemStyle.Plain, target: self, action: "connectTPD:")
        navigationItem.setRightBarButtonItem(connect, animated: true)
        
        disconnect = UIBarButtonItem(title: "Disconnect", style: UIBarButtonItemStyle.Plain, target: self, action: "disconnectTPD:")
        
        peerPicker = PeerPicker(nibName: "PeerPicker",bundle: nil)
        peerPicker.dataDisplay = self
        
        ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        ai.startAnimating()
        
        title = "Not Connected"
        
        at = navigationItem.titleView
        
        runVIEW.type = .Run
        runVIEW.sections = settings.runSections
        
        passVIEW.type = .Pass
        passVIEW.sections = settings.passSections
        
        homeBTN.layer.cornerRadius = 4
        homeBTN.hidden = true
        awayBTN.layer.cornerRadius = 4
        awayBTN.hidden = true
        
        cover = UIView(frame: view.frame)
        cover.backgroundColor = UIColor.blackColor()
        cover.alpha = 0.4
        view.addSubview(cover)
        
        edgesForExtendedLayout = UIRectEdge()
        
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    func receiveGame(_game: [String : AnyObject]) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            
            JP("GAME RECEIVED")
            JP(_game)
            self.game = _game
            
            let _show = _game["show"] as! String
            
            if _show == "home" { self.index = 1 } else { self.index = 0 }
            
            self.setData(self.index)
            
        }
    }
    
    func stateChanged(_state: MCSessionState) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            
            JP("STATE CHANGED")
            
            switch _state {
            case .Connecting:
                
                self.navigationItem.titleView = self.ai
                
            case .Connected:
                
                self.navigationItem.titleView = self.at
                self.title = _state.stringValue()
                self.peerPicker.dismissViewControllerAnimated(true, completion: nil)
                self.navigationItem.setRightBarButtonItem(self.disconnect, animated: true)
                
            default:
                
                self.navigationItem.titleView = self.at
                self.title = _state.stringValue()
                self.navigationItem.setRightBarButtonItem(self.connect, animated: true)
                
            }
            
            self.cover.hidden = _state == .Connected
            
        }
    }
    
    func peersChanged() {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            
            JP("PEERS CHANGED")
            
            self.peerPicker.tableView.reloadData()
            
        }
    }
    
    func closeTPD(sender: UIBarButtonItem){
        
        MPC.stopBrowsing()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func connectTPD(sender: UIBarButtonItem){
        
        var nav = UINavigationController(rootViewController: peerPicker)
        
        var popover = UIPopoverController(contentViewController: nav)
        popover.popoverContentSize = CGSize(width: 220, height: view.bounds.height * 0.6)
        popover.presentPopoverFromBarButtonItem(sender, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        
    }
    
    func disconnectTPD(sender: UIBarButtonItem){
        
        MPC.session.disconnect()
        lastPeer = nil
        
    }
    
    var index: Int = 1
    func setData(i: Int){
        JP("SET DATA +++++++++++++++++++++++++++++++++++++++++++++++++++")
        index = i
        
        if i == 1 {
            
            homeBTN.backgroundColor = UIColor(red: 88/255, green: 88/255, blue: 88/255, alpha: 1)
            awayBTN.backgroundColor = UIColor.clearColor()
            
        } else {
            
            awayBTN.backgroundColor = UIColor(red: 88/255, green: 88/255, blue: 88/255, alpha: 1)
            homeBTN.backgroundColor = UIColor.clearColor()
            
        }
        
        let H = game["home"] as! [String:AnyObject]
        let A = game["away"] as! [String:AnyObject]
        
        homeBTN.setTitle(H["short"] as? String, forState: .Normal)
        awayBTN.setTitle(A["short"] as? String, forState: .Normal)
        
        homeBTN.hidden = false
        awayBTN.hidden = false
        
        var downs: [Int] = []
        for (i,swt) in enumerate(downSWT) {
            
            if swt.on { downs.append(i+1) }
            
        }
        
        var d: TeamData!
        
        if i == 1 {
            
            d = gameData(data: H,downs: downs,togo: Int(togoSLDR.value),threshold: Int(threshSLDR.value))
            
        } else {
            
            d = gameData(data: A,downs: downs,togo: Int(togoSLDR.value),threshold: Int(threshSLDR.value))
            
        }
        
        JP("RUNS: \(d.run)")
        JP("RUN SECTIONS: \(d.runs)")
        JP("PASS: \(d.pass)")
        JP("PASS SECTIONS: \(d.passes)")
        
        rpVIEW._data = d
        rpVIEW.setNeedsDisplay()
        
        runVIEW.items = d.runs
        runVIEW.total = d.run
        runVIEW.setNeedsDisplay()
        
        passVIEW.items = d.passes
        passVIEW.total = d.pass
        passVIEW.setNeedsDisplay()
        
    }

    @IBAction func teamTPD(sender: AnyObject) {
        
        JP("TEAM TPD")
        setData(sender.tag)
        
    }
    
    @IBAction func distanceCHG(sender: UISlider) {
        
        sender.value = round(sender.value)
        
        if sender.value == 51 {
            togoTXT.text = "All"
        } else {
            togoTXT.text = Int(sender.value).string()
        }
        
    }
    
    @IBAction func threshCHG(sender: UISlider) {
        
        sender.value = round(sender.value)
        
        threshTXT.text = "+/- \(Int(sender.value))"
        
    }
    
    @IBAction func slideEnded(sender: AnyObject) {
        
        JP("SLIDE ENEDED")
        setData(index)
        
    }
    
}