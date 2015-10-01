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
    var rightHome: Bool = true
    
    var newPlay: Play?
    var newPenalty: Penalty?
    var kickPenalty: Penalty?
    
    var enterOn = false
    
    var bLast: CGPoint!
    
    var tn: Int?
    var sn: Int?
    
    var lastFD: Yardline?
    var lastDOWN: Int?
    
    // IB
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    @IBOutlet weak var playTypeSEL: UISegmentedControl!
    @IBOutlet weak var field: Field!
    @IBOutlet weak var qtrSEL: UIStepper!
    @IBOutlet weak var qtrTXT: UILabel!
    @IBOutlet weak var downTXT: UILabel!
    @IBOutlet weak var downSEL: UISegmentedControl!
    @IBOutlet weak var cancelBTN: UIButton!
    @IBOutlet weak var sequenceTBL: SequenceTBL!
    @IBOutlet weak var playTBL: PlayTBL!
    @IBOutlet weak var penaltyTBL: PenaltyTBL!
    @IBOutlet weak var fimg: UIImageView!
    @IBOutlet weak var rightPTY: PenaltyBTN!
    @IBOutlet weak var leftPTY: PenaltyBTN!
    @IBOutlet weak var replaySWI: UISwitch!
    @IBOutlet weak var scoreboard: UIView!
    @IBOutlet weak var leftBALL: UIButton!
    @IBOutlet weak var rightBALL: UIButton!
    @IBOutlet weak var leftTEAM: UIButton!
    @IBOutlet weak var rightTEAM: UIButton!
    @IBOutlet weak var leftSCORE: UILabel!
    @IBOutlet weak var rightSCORE: UILabel!
    @IBOutlet weak var prevBTN: UIButton!
    @IBOutlet weak var nextBTN: UIButton!
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    
    // VIEW DID LOAD
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(game.away.name) @ \(game.home.name)"
        
        var tblView =  UIView(frame: CGRectZero)
        sequenceTBL.tableFooterView = tblView
        sequenceTBL.tableFooterView?.hidden = true
        sequenceTBL.backgroundColor = UIColor.clearColor()
        playTBL.tableFooterView = tblView
        playTBL.tableFooterView?.hidden = true
        playTBL.backgroundColor = UIColor.clearColor()
        penaltyTBL.tableFooterView = tblView
        penaltyTBL.tableFooterView?.hidden = true
        penaltyTBL.backgroundColor = UIColor.clearColor()
        
        let add = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "newSequence:")
        navigationItem.setRightBarButtonItem(add, animated: true)
        
        let back = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.Plain, target: self, action: "backTPD:")
        navigationItem.setLeftBarButtonItem(back, animated: true)
        
        edgesForExtendedLayout = UIRectEdge()
        
        leftPTY.layer.cornerRadius = 4
        rightPTY.layer.cornerRadius = 4
        leftTEAM.layer.cornerRadius = 6
        rightTEAM.layer.cornerRadius = 6
        
        setDelegates()
        
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    func setDelegates(){
        
        field.tracker = self
        sequenceTBL.tracker = self
        playTBL.tracker = self
        penaltyTBL.tracker = self
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 2
        tap.addTarget(self, action: "field2TPD:")
        
        field.addGestureRecognizer(tap)
        
    }
    
    func backTPD(){ navigationController?.popViewControllerAnimated(true) }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
}