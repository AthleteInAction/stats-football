//
//  PlayPOP.swift
//  stats-football
//
//  Created by grobinson on 9/6/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PlayPOP: UIViewController,UIPopoverControllerDelegate {

    var pop: UIPopoverController!
    
    var tracker: Tracker!
    
    @IBOutlet weak var leftTable: PlayNumberSelector!
    @IBOutlet weak var keyTable: PlayKeySelectorOLD!
    @IBOutlet weak var rightTable: PlayNumberSelector!
    @IBOutlet weak var cancelBTN: UIButton!
    @IBOutlet weak var enterBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pop.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    @IBAction func enterTPD(sender: UIButton) {
        
        dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        
        dismissViewControllerAnimated(false, completion: nil)
        
        return false
        
    }
    
}
