//
//  ViewController.swift
//  stats-football
//
//  Created by grobinson on 8/24/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import Foundation
import UIKit
import MultipeerConnectivity

class Tracker: UIViewController,UIPopoverControllerDelegate {
    
    var game: Game!
    
    var index: Int = 0
    
    var popover: UIPopoverController!
    
    var rightPos: Bool = true
    
    var newPlay: Play?
    var newPenalty: Penalty?
    var kickPenalty: Penalty?
    
    var enterOn = false
    
    var bLast: CGPoint!
    
    var tn: Int?
    var sn: Int?
    
    var lastFD: Yardline?
    var lastDOWN: Int?
    
    var add: UIBarButtonItem!
    
    // IB
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    @IBOutlet weak var playTypeSEL: PlaytypeSelector!
    @IBOutlet weak var field: Field!
    @IBOutlet weak var draw: DrawLayer!
    @IBOutlet weak var qtrSEL: QuarterSelector!
    @IBOutlet weak var cancelBTN: UIButton!
    @IBOutlet weak var fimg: UIImageView!
    @IBOutlet weak var rightPTY: PenaltyBTN!
    @IBOutlet weak var leftPTY: PenaltyBTN!
    @IBOutlet weak var leftTEAM: UIButton!
    @IBOutlet weak var rightTEAM: UIButton!
    @IBOutlet weak var leftSCORE: UILabel!
    @IBOutlet weak var rightSCORE: UILabel!
    @IBOutlet weak var tosTXT: UITextField!
    @IBOutlet weak var rightBALL: UIView!
    @IBOutlet weak var leftBALL: UIView!
    @IBOutlet weak var sequenceSC: SequenceScroll!
    @IBOutlet weak var firstBTN: UIButton!
    @IBOutlet weak var panel: Panel!
    @IBOutlet weak var statsLEFT: UIButton!
    @IBOutlet weak var statsRIGHT: UIButton!
    @IBOutlet weak var eraseBTN: UIButton!
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    
    // VIEW DID LOAD
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        title = "\(game.away.name) @ \(game.home.name)"
        
        var tblView =  UIView(frame: CGRectZero)
        
        add = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "newSequence:")
        navigationItem.setRightBarButtonItem(add, animated: true)
        
        let back = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.Plain, target: self, action: "backTPD:")
        navigationItem.setLeftBarButtonItem(back, animated: true)
        
        edgesForExtendedLayout = UIRectEdge()
        
        leftPTY.layer.cornerRadius = 4
        rightPTY.layer.cornerRadius = 4
        cancelBTN.layer.cornerRadius = 6
        eraseBTN.layer.cornerRadius = 4
        
        setDelegates()
        
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    func setDelegates(){
        
        tosTXT.borderStyle = .None
        
        panel.tracker = self
        sequenceSC.tracker = self
        playTypeSEL.tracker = self
        qtrSEL.tracker = self
        field.tracker = self
        draw.tracker = self
        
        MPC.receiver = self
        MPC.stateMonitor = self
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: "field2TPD:")
        tap.delegate = field
        field.addGestureRecognizer(tap)
        
        tosTXT.addTarget(self, action: "tosEND:", forControlEvents: UIControlEvents.EditingDidEndOnExit)
        
        var t1 = UITapGestureRecognizer()
        t1.numberOfTapsRequired = 1
        var t1b = UITapGestureRecognizer()
        t1b.numberOfTapsRequired = 2
        t1.requireGestureRecognizerToFail(t1b)
        t1.addTarget(self, action: "posChanged:")
        t1b.addTarget(self, action: "switchTPD:")
        rightTEAM.addGestureRecognizer(t1)
        rightTEAM.addGestureRecognizer(t1b)
        
        var t2 = UITapGestureRecognizer()
        t2.numberOfTapsRequired = 1
        var t2b = UITapGestureRecognizer()
        t2b.numberOfTapsRequired = 2
        t2.requireGestureRecognizerToFail(t2b)
        t2.addTarget(self, action: "posChanged:")
        t2b.addTarget(self, action: "switchTPD:")
        leftTEAM.addGestureRecognizer(t2)
        leftTEAM.addGestureRecognizer(t2b)
        
        var swipe = UISwipeGestureRecognizer()
        swipe.numberOfTouchesRequired = 3
        swipe.direction = .Up
        swipe.addTarget(self, action: "newSequence:")
        field.addGestureRecognizer(swipe)
        
        var swipeL = UISwipeGestureRecognizer()
        swipeL.numberOfTouchesRequired = 3
        swipeL.direction = .Left
        swipeL.addTarget(self, action: "newSequence:")
        field.addGestureRecognizer(swipeL)
        
        var swipeR = UISwipeGestureRecognizer()
        swipeR.numberOfTouchesRequired = 3
        swipeR.direction = .Right
        swipeR.addTarget(self, action: "newSequence:")
        field.addGestureRecognizer(swipeR)
        
        var swipeD = UISwipeGestureRecognizer()
        swipeD.numberOfTouchesRequired = 3
        swipeD.direction = .Down
        swipeD.addTarget(self, action: "newSequence:")
        field.addGestureRecognizer(swipeD)
        
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
}