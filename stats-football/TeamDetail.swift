//
//  TeamDetail.swift
//  stats-football
//
//  Created by grobinson on 9/18/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class TeamDetail: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ColorPickerPTC {
    
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
        colorBTN.backgroundColor = team.color
        
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
                    main.gamesTBL.getData()
                    
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
                    main.teamsTBL.reloadData()
                    main.gamesTBL.getData()
                    
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
                    main.gamesTBL.getData()
                    
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
                    main.teamsTBL.reloadData()
                    main.gamesTBL.getData()
                    
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
        
        let player = team.roster[indexPath.row]
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        
        editPlayer(player,sender: cell,v: tableView)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let player = team.roster[indexPath.row]
            
            player.delete(nil)
            main.teamsTBL.reloadData()
            main.gamesTBL.getData()
            
            team.roster.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            
        }
        
    }

    @IBAction func newTPD(sender: UIButton) {
        
        editPlayer(nil,sender: sender,v: self.view)
        
    }
    
    func doneTPD(sender: UIBarButtonItem){
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func colorTPD(sender: AnyObject) {
        
        let vc = ColorPicker(nibName: "ColorPicker",bundle: nil)
        vc.delegate = self
        
        var popover = UIPopoverController(contentViewController: vc)
        popover.popoverContentSize = CGSize(width: 480, height: 440)
        popover.presentPopoverFromRect(sender.frame, inView: view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
        
    }
    
    func editPlayer(player: Player?,sender: AnyObject,v: UIView){
        
        let vc = PlayerEdit(nibName: "PlayerEdit",bundle: nil)
        vc.teamDetail = self
        vc.editPlayer = player
        var nav = UINavigationController(rootViewController: vc)
        
        var popover = UIPopoverController(contentViewController: nav)
        popover.popoverContentSize = CGSize(width: 283, height: 360)
        popover.presentPopoverFromRect(sender.frame, inView: v, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
        
    }
    
    func colorSelected(color: UIColor) {
        
        team.color = color
        team.save(nil)
        main.teamsTBL.reloadData()
        main.gamesTBL.getData()
        colorBTN.backgroundColor = color
        
    }
    
}