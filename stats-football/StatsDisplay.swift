//
//  StatsDisplay.swift
//  stats-football
//
//  Created by grobinson on 9/25/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class StatsDisplay: UIViewController {

    @IBOutlet weak var passingTBL: PassingTBL!
    @IBOutlet weak var rushingTBL: RushingTBL!
    @IBOutlet weak var receivingTBL: ReceivingTBL!
    @IBOutlet weak var puntReturnsTBL: PuntReturnTBL!
    @IBOutlet weak var kickReturnsTBL: PuntReturnTBL!
    
    var game: Game!
    var team: Team!
    private var _team: Team!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(team.name) Stats"
        
        var close = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "closeTPD:")
        
        navigationItem.setLeftBarButtonItem(close, animated: true)
        
        var tblView =  UIView(frame: CGRectZero)
        passingTBL.tableFooterView = tblView
        passingTBL.tableFooterView?.hidden = true
        passingTBL.backgroundColor = UIColor.clearColor()
        
        receivingTBL.tableFooterView = tblView
        receivingTBL.tableFooterView?.hidden = true
        receivingTBL.backgroundColor = UIColor.clearColor()
        
        rushingTBL.tableFooterView = tblView
        rushingTBL.tableFooterView?.hidden = true
        rushingTBL.backgroundColor = UIColor.clearColor()
        
        puntReturnsTBL.tableFooterView = tblView
        puntReturnsTBL.tableFooterView?.hidden = true
        puntReturnsTBL.backgroundColor = UIColor.clearColor()
        
        kickReturnsTBL.tableFooterView = tblView
        kickReturnsTBL.tableFooterView?.hidden = true
        kickReturnsTBL.backgroundColor = UIColor.clearColor()
        
        puntReturnsTBL.type = "Punt"
        kickReturnsTBL.type = "Kick"
        
        edgesForExtendedLayout = UIRectEdge()
        
        doStats()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func closeTPD(sender: UIBarButtonItem){
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func doStats(){
        
        if game.home.object.isEqual(team.object) {
            _team = game.home
        } else {
            _team = game.away
        }
        
        passingTBL.team = _team
        receivingTBL.team = _team
        rushingTBL.team = _team
        puntReturnsTBL.team = _team
        kickReturnsTBL.team = _team
        
        Loading.start()
        
        Rhino.run({
            
            self.game.getTotals()
        
        }, completion: { () -> Void in
            
            self.setData()
            
            Loading.stop()
            
        })
        
    }
    
    func setData(){
        
        passingTBL.passing = _team.passing
        receivingTBL.receiving = _team.receiving
        rushingTBL.rushing = _team.rushing
        puntReturnsTBL.returns = _team.puntReturns
        kickReturnsTBL.returns = _team.kickReturns
        
        passingTBL.reloadData()
        receivingTBL.reloadData()
        rushingTBL.reloadData()
        puntReturnsTBL.reloadData()
        kickReturnsTBL.reloadData()
        
    }

    @IBAction func sendTPD(sender: AnyObject) {
        
        let conf = UIAlertController(title: "Finished!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        conf.addAction(ok)
        
        let alert = UIAlertController(title: "Send \(_team.short) Stats", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        var txt: UITextField!
        
        func addTextField(_txt: UITextField!){
            
            _txt.placeholder = "Email"
            _txt.keyboardType = UIKeyboardType.EmailAddress
            _txt.text = last_email.string()
            txt = _txt
            
        }
        
        alert.addTextFieldWithConfigurationHandler(addTextField)
        
        let send = UIAlertAction(title: "Send", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            if txt.text != "" {
                
                Loading.start()
                
                self.game.sendStats(team: self._team, email: txt.text, completion: { (error) -> Void in
                    
                    if error == nil {
                        
                        
                        
                    } else {
                        
                        conf.message = "There was an error!"
                        
                    }
                    
                    self.presentViewController(conf, animated: true, completion: nil)
                    
                    Loading.stop()
                    
                })
            }
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive) { (action) -> Void in
            
            
            
        }
        
        alert.addAction(send)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
}