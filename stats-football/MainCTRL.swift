//
//  MainCTRL.swift
//  stats-football
//
//  Created by grobinson on 9/10/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class MainCTRL: UIViewController {

    @IBOutlet weak var teamsTBL: TeamsTBL!
    @IBOutlet weak var gamesTBL: GamesTBL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamesTBL.main = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    @IBAction func teamsTPD(sender: AnyObject) {
        
        teamsTBL.getData()
        
    }
    
    @IBAction func gamesTPD(sender: AnyObject) {
        
        gamesTBL.getData()
        
    }
    
    @IBAction func newTeamTPD(sender: AnyObject) {
        
        var vc = TeamDetail(nibName: "TeamDetail",bundle: nil)
        vc.main = self
        
        var popover = UIPopoverController(contentViewController: vc)
        popover.popoverContentSize = CGSize(width: 300, height: view.bounds.height * 0.6)
        popover.presentPopoverFromRect(sender.frame, inView: view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        
    }
    
    @IBAction func newGameTPD(sender: AnyObject) {
        
        var vc = GameDetail(nibName: "GameDetail",bundle: nil)
        vc.main = self
        
        var popover = UIPopoverController(contentViewController: vc)
        popover.popoverContentSize = CGSize(width: 500, height: 300)
        popover.presentPopoverFromRect(sender.frame, inView: view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        
    }
    
}