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
    
    var MPC = MPCManager()
    
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
    var data1: [String:AnyObject] = [
        "run": 0,
        "run_1": 0,
        "run_2": 0,
        "run_3": 0,
        "run_4": 0,
        "run_5": 0,
        "pass": 0,
        "pass_1": 0,
        "pass_2": 0,
        "pass_3": 0,
        "pass_4": 0,
        "pass_5": 0
    ]
    var data: [String:AnyObject]!
    
    var ai: UIActivityIndicatorView!
    var at: UIView!
    
    var connect: UIBarButtonItem!
    var disconnect: UIBarButtonItem!
    
    var homeSel = true
    var highlight: UIColor!
    
    @IBOutlet weak var rpVIEW: rpPCT!
    @IBOutlet weak var fieldIMG: UIImageView!
    @IBOutlet weak var field: DisplayField!
    @IBOutlet weak var awayBTN: UIButton!
    @IBOutlet weak var homeBTN: UIButton!
    @IBOutlet weak var playtypeSEL: UISegmentedControl!
    @IBOutlet var downTXT: [UILabel]!
    @IBOutlet var downCHK: [UISwitch]!
    @IBOutlet weak var togoSLDR: UISlider!
    @IBOutlet weak var threshSLDR: UISlider!
    @IBOutlet weak var togoTXT: UILabel!
    @IBOutlet weak var threshTXT: UILabel!
    @IBOutlet weak var togoLBL: UILabel!
    @IBOutlet weak var threshLBL: UILabel!
    
    @IBAction func playtypeCHG(sender: UISegmentedControl) {
        
        setVisible()
        setData()
        
    }
    
    func setVisible(){
        
        for item in downCHK { item.hidden = (playtypeSEL.selectedSegmentIndex == 1) }
        for item in downTXT { item.hidden = (playtypeSEL.selectedSegmentIndex == 1) }
        
        togoLBL.hidden = (playtypeSEL.selectedSegmentIndex == 1)
        togoSLDR.hidden = (playtypeSEL.selectedSegmentIndex == 1)
        togoTXT.hidden = (playtypeSEL.selectedSegmentIndex == 1)
        threshTXT.hidden = (playtypeSEL.selectedSegmentIndex == 1)
        threshLBL.hidden = (playtypeSEL.selectedSegmentIndex == 1)
        threshSLDR.hidden = (playtypeSEL.selectedSegmentIndex == 1)
        
        if playtypeSEL.selectedSegmentIndex == 2 {
            
            togoLBL.alpha = 0.5
            togoSLDR.alpha = 0.5
            togoSLDR.userInteractionEnabled = false
            
            for item in downCHK {
                item.alpha = 0.5
                item.userInteractionEnabled = false
            }
            
            for item in downTXT {
                item.alpha = 0.5
                item.userInteractionEnabled = false
            }
            
        } else {
            
            togoLBL.alpha = 1
            togoSLDR.alpha = 1
            togoSLDR.userInteractionEnabled = true
            
            for item in downCHK {
                item.alpha = 1
                item.userInteractionEnabled = true
            }
            
            for item in downTXT {
                item.alpha = 1
                item.userInteractionEnabled = true
            }
            
        }
        
    }
    
    @IBAction func togoCHG(sender: UISlider) {
        
        var i = round(sender.value)
        sender.value = i
        
        togoTXT.text = "\(Int(i))"
        
    }
    
    @IBAction func threshCHG(sender: UISlider) {
        
        var i = round(sender.value)
        sender.value = i
        
        threshTXT.text = "+/- \(Int(i))"
        
    }
    
    @IBAction func slideEND(sender: AnyObject) {
        
        setData()
        
    }
    
    @IBAction func teamSEL(sender: UIButton) {
        
        homeSel = sender.tag == 1
        setData()
        
    }
    
    @IBAction func downCHG(sender: AnyObject) {
        
        setData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = data1
        
        ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        ai.startAnimating()
        
        at = navigationItem.titleView
        
        rpVIEW.dataDisplay = self
        field.dataDisplay = self
        
        MPC.receiver = self
        MPC.stateMonitor = self
        
        MPC.startBrowsing()
        
        title = "Not Connected"
        
        edgesForExtendedLayout = UIRectEdge()
        
        var cancel = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Done, target: self, action: "cancelTPD:")
        navigationItem.setLeftBarButtonItem(cancel, animated: true)
        
        connect = UIBarButtonItem(title: "Connect", style: UIBarButtonItemStyle.Plain, target: self, action: "connectTPD:")
        navigationItem.setRightBarButtonItem(connect, animated: true)
        
        disconnect = UIBarButtonItem(title: "Disconnect", style: UIBarButtonItemStyle.Plain, target: self, action: "disconnectTPD:")
        
        peerPicker = PeerPicker(nibName: "PeerPicker",bundle: nil)
        peerPicker.dataDisplay = self
        
        awayBTN.hidden = true
        homeBTN.hidden = true
        highlight = awayBTN.backgroundColor
        
        setVisible()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func cancelTPD(sender: UIBarButtonItem){
        
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
    
    func receiveGame(game: [String:AnyObject]) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            
            println(game)
            self.game = game
            self.setData()
            
        }
    }
    
    func setData(){
        
        let home = game["home"] as! [String:AnyObject]
        let away = game["away"] as! [String:AnyObject]
        
        var pre = away
        if homeSel { pre = home }
        
        var pt: String?
        var downs: [Int]?
        var togo: Int?
        var threshold: Int?
        switch playtypeSEL.selectedSegmentIndex {
        case 1:
            // PAT
            
            pt = "pat"
            
        case 2:
            // CURRENT
            
            if pre["current"] != nil {
                
                let current = pre["current"] as! [String:AnyObject]
                
                let playtype = current["playtype"] as? String
                
                pt = playtype
                
                if let pp = playtype {
                    
                    switch pp {
                    case "down":
                        
                        let d = current["down"] as! Int
                        let tg = current["togo"] as! Int
                        
                        for (i,down) in enumerate(downCHK) {
                            
                            down.on = (i+1) == d
                            
                        }
                        
                        downs = [d]
                        
                        println("DOWNS: \(downs)")
                        togoSLDR.value = Float(tg)
                        
                    case "pat":
                        
                        ()
                        
                    default:
                        ()
                    }
                    
                }
                
            }
            
        default:
            // DOWN
            
            pt = "down"
            for (i,down) in enumerate(downCHK) {
                if down.on {
                    
                    if downs == nil { downs = [] }
                    downs!.append(i+1)
                    
                }
            }
            togo = Int(togoSLDR.value)
            threshold = Int(threshSLDR.value)
            
        }
        
//        rpVIEW.setViews()
//        field.setViews()
//        
//        awayBTN.setTitle(away["short"] as? String, forState: UIControlState.Normal)
//        homeBTN.setTitle(home["short"] as? String, forState: UIControlState.Normal)
//        
//        awayBTN.hidden = false
//        homeBTN.hidden = false
//        
//        awayBTN.backgroundColor = UIColor.whiteColor()
//        homeBTN.backgroundColor = UIColor.whiteColor()
//        if homeSel {
//            homeBTN.backgroundColor = highlight
//        } else {
//            awayBTN.backgroundColor = highlight
//        }
//        
//        togoTXT.text = Int(togoSLDR.value).string()
//        
//        setVisible()
        
    }
    
    func stateChanged(state: MCSessionState) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            
            switch state {
            case .Connecting:
                self.navigationItem.titleView = self.ai
            case .Connected:
                self.navigationItem.titleView = self.at
                self.title = state.stringValue()
                self.peerPicker.dismissViewControllerAnimated(true, completion: nil)
                self.navigationItem.setRightBarButtonItem(self.disconnect, animated: true)
            default:
                self.navigationItem.titleView = self.at
                self.title = state.stringValue()
                self.navigationItem.setRightBarButtonItem(self.connect, animated: true)
            }
            
        }
    }
    
    func peersChanged() {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            
            self.peerPicker.tableView.reloadData()
            
        }
    }

}