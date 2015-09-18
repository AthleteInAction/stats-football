//
//  TeamDetail.swift
//  stats-football
//
//  Created by grobinson on 9/18/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class TeamDetail: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var team: Team!
    var main: MainCTRL!
    
    @IBOutlet weak var rosterTBL: UITableView!
    @IBOutlet weak var newBTN: UIButton!
    @IBOutlet weak var shortTXT: UITextField!
    @IBOutlet weak var colorBTN: UIButton!
    
    var nameTXT: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorBTN.layer.cornerRadius = 5
        
        rosterTBL.delegate = self
        rosterTBL.dataSource = self
        
        team.getRoster()
        
        rosterTBL.reloadData()
        
        edgesForExtendedLayout = UIRectEdge()
        
        var done = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneTPD:")
        navigationItem.setLeftBarButtonItem(done, animated: true)
        
        nameTXT = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
        nameTXT.text = team.name
        nameTXT.font = UIFont.systemFontOfSize(19)
        nameTXT.textColor = UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1)
        nameTXT.backgroundColor = UIColor.clearColor()
        nameTXT.textAlignment = .Center
        nameTXT.delegate = self
        
        shortTXT.delegate = self
        shortTXT.text = team.short
        
        navigationItem.titleView = nameTXT
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        dismissKeyboard()
        
    }
    
    func dismissKeyboard(){
        
        nameTXT.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == nameTXT {
            
            if nameTXT.text != "" {
                
                if nameTXT.text != team.name {
                    
                    team.name = nameTXT.text
                    team.save(nil)
                    main.teamsTBL.reloadData()
                    
                }
                
            } else {
                
                return false
                
            }
            
            dismissKeyboard()
            nameTXT.endEditing(true)
            
        }
        
        if textField == shortTXT {
            
            if shortTXT.text != "" {
                
                if shortTXT.text != team.short {
                    
                    team.short = shortTXT.text
                    team.save(nil)
                    
                }
                
            } else {
                
                return false
                
            }
            
            dismissKeyboard()
            nameTXT.endEditing(true)
            
        }
        
        return true
        
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        if textField == nameTXT {
            
            if nameTXT.text != "" {
                
                if nameTXT.text != team.name {
                    
                    team.name = nameTXT.text
                    team.save(nil)
                    main.teamsTBL.reloadData()
                    
                }
            
            } else {
                
                nameTXT.text = team.name
                
            }
            
        }
        
        if textField == shortTXT {
            
            if shortTXT.text != "" {
                
                if shortTXT.text != team.short {
                    
                    team.short = shortTXT.text
                    team.save(nil)
                    
                }
                
            } else {
                
                shortTXT.text = team.short
                
            }
            
        }
        
        return true
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return team.roster.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        let player = team.roster[indexPath.row]
        
        var s = "#\(player.number)"
        if let first = player.first_name { s += " \(first)" }
        if let last = player.last_name { s += " \(last)" }
        
        cell.textLabel?.text = s
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let player = team.roster[indexPath.row]
            
            player.delete(nil)
            
            team.roster.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            
        }
        
    }

    @IBAction func newTPD(sender: UIButton) {
        
        let vc = PlayerEdit(nibName: "PlayerEdit",bundle: nil)
        vc.teamDetail = self
        var nav = UINavigationController(rootViewController: vc)
        
        var popover = UIPopoverController(contentViewController: nav)
        popover.popoverContentSize = CGSize(width: 283, height: 360)
        popover.presentPopoverFromRect(sender.frame, inView: view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
        
    }
    
    func doneTPD(sender: UIBarButtonItem){
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func colorTPD(sender: AnyObject) {
        
//        let popoverVC = ColorPicker(nibName: "ColorPicker",bundle: nil)
//        let popoverVC = main.storyboard?.instantiateViewControllerWithIdentifier("colorPickerPopover") as! ColorPicker
//        
//        popoverVC.modalPresentationStyle = .Popover
//        popoverVC.preferredContentSize = CGSizeMake(284, 446)
//        if let popoverController = popoverVC.popoverPresentationController {
//            popoverController.sourceView = sender as! UIView
//            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
//            popoverController.permittedArrowDirections = .Any
//            popoverVC.delegate = self
//        }
//        presentViewController(popoverVC, animated: true, completion: nil)
        
    }
    
    func setButtonColor(color: UIColor){
        
        colorBTN.backgroundColor = color
        
    }
    
}