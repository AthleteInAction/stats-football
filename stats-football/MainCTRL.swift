//
//  MainCTRL.swift
//  stats-football
//
//  Created by grobinson on 9/10/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MainCTRL: UIViewController {

    @IBOutlet weak var teamsTBL: TeamsTBL!
    @IBOutlet weak var gamesTBL: GamesTBL!
    @IBOutlet weak var teamsBTN: UIButton!
    @IBOutlet weak var gamesBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamsTBL.main = self
        gamesTBL.main = self
        
        teamsBTN.tag = 1
        gamesBTN.tag = 2
        
        teamsBTN.userInteractionEnabled = true
        gamesBTN.userInteractionEnabled = true
        
        var tap1a = UITapGestureRecognizer()
        tap1a.numberOfTapsRequired = 1
        tap1a.addTarget(self, action: "team1TPD:")
        
        var tap2a = UITapGestureRecognizer()
        tap2a.numberOfTapsRequired = 2
        tap2a.addTarget(self, action: "team2TPD:")
        tap1a.requireGestureRecognizerToFail(tap2a)
        
        var tap1b = UITapGestureRecognizer()
        tap1b.numberOfTapsRequired = 1
        tap1b.addTarget(self, action: "team1TPD:")
        
        var tap2b = UITapGestureRecognizer()
        tap2b.numberOfTapsRequired = 2
        tap2b.addTarget(self, action: "team2TPD:")
        tap1b.requireGestureRecognizerToFail(tap2b)
        
        teamsBTN.addGestureRecognizer(tap1a)
        teamsBTN.addGestureRecognizer(tap2a)
        
        gamesBTN.addGestureRecognizer(tap1b)
        gamesBTN.addGestureRecognizer(tap2b)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func team1TPD(sender: UITapGestureRecognizer){
        
        let b = sender.view as! UIButton
        
        if b.tag == 1 {
            
            teamsTBL.getData()
            
        } else if b.tag == 2 {
            
            gamesTBL.getData()
            
        }
        
    }
    
    func team2TPD(sender: UITapGestureRecognizer){
        
        let b = sender.view as! UIButton
        
        if b.tag == 1 {
            
            var vc = TeamEdit(nibName: "TeamEdit",bundle: nil)
            vc.main = self
            
            var popover = UIPopoverController(contentViewController: vc)
            popover.popoverContentSize = CGSize(width: 300, height: view.bounds.height * 0.6)
            popover.presentPopoverFromRect(b.frame, inView: view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            
        } else if b.tag == 2 {
            
            var vc = GameEdit(nibName: "GameEdit",bundle: nil)
            vc.main = self
            
            var popover = UIPopoverController(contentViewController: vc)
            popover.popoverContentSize = CGSize(width: 500, height: 300)
            popover.presentPopoverFromRect(b.frame, inView: view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            
        }
        
    }
    
    @IBAction func dataTPD(sender: AnyObject) {
        
        var vc = DataDisplay(nibName: "DataDisplay",bundle: nil)
        
        var nav = UINavigationController(rootViewController: vc)
        
        presentViewController(nav, animated: true, completion: nil)
        
    }
    
}