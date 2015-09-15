//
//  GameDetail.swift
//  stats-football
//
//  Created by grobinson on 9/11/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GameDetail: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    var main: MainCTRL!
    
    @IBOutlet weak var teamPK: UIPickerView!
    @IBOutlet weak var saveBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamPK.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 2
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return main.teamsTBL.teams.count
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        let team = main.teamsTBL.teams[row]
        
        return String(team.name)
        
    }

    @IBAction func saveTPD(sender: AnyObject) {
        
        saveData()
        
    }
    
    func saveData() -> Bool {
        
        let away = main.teamsTBL.teams[teamPK.selectedRowInComponent(0)]
        let home = main.teamsTBL.teams[teamPK.selectedRowInComponent(1)]
        
        let game = Game(away: away, home: home)
        
        game.save(nil)
        
        main.gamesTBL.games.insert(game, atIndex: 0)
        main.gamesTBL.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
        
        return true
        
    }
    
}