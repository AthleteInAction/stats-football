//
//  TeamDetail.swift
//  stats-football
//
//  Created by grobinson on 9/10/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TeamDetail: UIViewController,UITextFieldDelegate {

    var main: MainCTRL!
    
    @IBOutlet weak var nameTXT: UITextField!
    @IBOutlet weak var shortTXT: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTXT.delegate = self
        shortTXT.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        nameTXT.endEditing(true)
        shortTXT.endEditing(true)
        
    }

    @IBAction func saveTPD(sender: AnyObject) {
        
        saveData()
        
    }
    
    func saveData() -> Bool {
        
        if nameTXT.text == "" || shortTXT.text == "" { return false }
        
        nameTXT.endEditing(true)
        shortTXT.endEditing(true)
        
        let s = "\(domain)/api/v1/teams.json"
        
        var newTeam = [
            "team" : [
                "name" : nameTXT.text,
                "short" : shortTXT.text
            ]
        ]
        
        Alamofire.request(.POST, s, parameters: newTeam, encoding: .JSON)
            .responseJSON { (request, response, data, error) in
                
                if error == nil {
                    
                    if response?.statusCode == 201 {
                        
                        var json = JSON(data!)
                        
                        var team = Team(json: json["team"])
                        
                        self.main.teamsTBL.teams.insert(team, atIndex: 0)
                        self.main.teamsTBL.reloadData()
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    } else {
                        
                        println("Status Code Error: \(response?.statusCode)")
                        println(request)
                        
                    }
                    
                } else {
                    
                    println("Error!")
                    println(error)
                    println(request)
                    
                }
                
        }
        
        return true
        
    }
    
}
