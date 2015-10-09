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
    @IBOutlet weak var color2BTN: UIButton!
    @IBOutlet var primaryTXT: [UITextField]!
    @IBOutlet var secondaryTXT: [UITextField]!
    
    var nameTXT: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorBTN.backgroundColor = team.primary
        color2BTN.backgroundColor = team.secondary
        colorBTN.layer.cornerRadius = 5
        color2BTN.layer.cornerRadius = 5
        setColorTXT(0, color: team.primary)
        setColorTXT(1, color: team.secondary)
        
        for txt in primaryTXT {
            txt.delegate = self
            txt.addTarget(self, action: "txtCHG:", forControlEvents: UIControlEvents.EditingChanged)
        }
        for txt in secondaryTXT {
            txt.delegate = self
            txt.addTarget(self, action: "txtCHG:", forControlEvents: UIControlEvents.EditingChanged)
        }
        
        rosterTBL.delegate = self
        rosterTBL.dataSource = self
        
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
    
    func txtCHG(sender: UITextField) -> Bool {
        
        JP2("CHANGED: \(sender.tag)")
        
        if sender.tag == 0 {
            
            if primaryTXT[0].text == "" || primaryTXT[1].text == "" || primaryTXT[2].text == "" {
                
                return false
                
            }
            
            let color = UIColor(red: CGFloat(primaryTXT[0].text.toInt()!)/255, green: CGFloat(primaryTXT[1].text.toInt()!)/255, blue: CGFloat(primaryTXT[2].text.toInt()!)/255, alpha: 1)
            
            setColor(0, color: color)
            
        } else {
            
            if secondaryTXT[0].text == "" || secondaryTXT[1].text == "" || secondaryTXT[2].text == "" {
                
                return false
                
            }
            
            let color = UIColor(red: CGFloat(secondaryTXT[0].text.toInt()!)/255, green: CGFloat(secondaryTXT[1].text.toInt()!)/255, blue: CGFloat(secondaryTXT[2].text.toInt()!)/255, alpha: 1)
            
            setColor(1, color: color)
            
        }
        
        return true
        
    }
    
    func setColor(i: Int,color _color: UIColor){
        
        if i == 0 {
            
            colorBTN.backgroundColor = _color
            team.primary = _color
            
        } else {
            
            color2BTN.backgroundColor = _color
            team.secondary = _color
            
        }
        
        team.save(nil)
        
        setColorTXT(i, color: _color)
        
        main.teamsTBL.reloadData()
        main.gamesTBL.getData()
        
    }
    
    func setColorTXT(i: Int,color _color: UIColor){
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        _color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        var red: Int = Int(round(r * 255))
        var green: Int = Int(round(g * 255))
        var blue: Int = Int(round(b * 255))
        
        if i == 0 {
            
            primaryTXT[0].text = red.string()
            primaryTXT[1].text = green.string()
            primaryTXT[2].text = blue.string()
            
        } else {
            
            secondaryTXT[0].text = red.string()
            secondaryTXT[1].text = green.string()
            secondaryTXT[2].text = blue.string()
            
        }
        
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
    
    @IBAction func colorTPD(sender: UIButton) {
        
        let vc = ColorPicker(nibName: "ColorPicker",bundle: nil)
        vc.delegate = self
        vc.index = sender.tag
        vc.color = sender.backgroundColor
        
        var popover = UIPopoverController(contentViewController: vc)
        popover.popoverContentSize = CGSize(width: 480, height: 480)
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
    
    func colorSelected(i: Int,color: UIColor) {
        
        setColor(i, color: color)
        
    }
    
}