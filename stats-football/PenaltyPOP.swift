//
//  PenaltyPOP.swift
//  stats-football
//
//  Created by grobinson on 9/7/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class PenaltyPOP: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate {
    
    var tracker: TrackerCTRL!
    var pop: UIPopoverController!
    var numbers: [Int] = []
    
    @IBOutlet weak var yardSEL: UISegmentedControl!
    @IBOutlet weak var replaySEL: UISwitch!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var enterBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Penalty"
        
        pop.delegate = self
        
        let getRandom = randomSequenceGenerator(min: 1, max: 99)
        
        for _ in 1...34 {
            
            numbers.append(getRandom())
            
        }
        
        numbers.sort( {$0 < $1 } )
        
        table.delegate = self
        table.dataSource = self
        
        self.edgesForExtendedLayout = UIRectEdge()
        
    }
    
    func randomSequenceGenerator(#min: Int,max: Int) -> () -> Int {
        var numbers: [Int] = []
        return {
            if numbers.count == 0 {
                numbers = Array(min ... max)
            }
            
            let index = Int(arc4random_uniform(UInt32(numbers.count)))
            return numbers.removeAtIndex(index)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numbers.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        let n = numbers[indexPath.row]
        
        cell.textLabel?.text = "#\(n)"
        
        return cell
        
    }

    @IBAction func enterTPD(sender: AnyObject) {
        
        dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        
        dismissViewControllerAnimated(false, completion: nil)
        
        return false
        
    }
    
}
