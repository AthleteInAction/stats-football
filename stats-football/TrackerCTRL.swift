//
//  ViewController.swift
//  stats-football
//
//  Created by grobinson on 8/24/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import Foundation
import UIKit

class TrackerCTRL: UIViewController,UIPopoverControllerDelegate {
    
    var game: Game!
    
    var selectedPlayKey: String?
    
    var index: Int = 0
    
    var popover: UIPopoverController!
    
    var numbers: [Player] = []
    var test: [Int] = [3,67,89,5,43,11,2,13]
    
    @IBOutlet weak var playTypeSelector: UISegmentedControl!
    @IBOutlet weak var field: Field!
    @IBOutlet weak var qtrSelector: UIStepper!
    @IBOutlet weak var qtrTXT: UILabel!
    @IBOutlet weak var downSelector: UIStepper!
    @IBOutlet weak var downTXT: UILabel!
    @IBOutlet weak var posSelector: UISegmentedControl!
    @IBOutlet weak var sideSwitch: UIButton!
    @IBOutlet weak var cancelBTN: UIButton!
    @IBOutlet weak var enterBTN: UIButton!
    @IBOutlet weak var sequenceTBL: SequenceTBL!
    @IBOutlet weak var playTBL: PlayTBL!
    @IBOutlet weak var penaltyTBL: PenaltyTBL!
    @IBOutlet weak var fimg: UIImageView!
    @IBOutlet weak var rightPTY: PenaltyBTN!
    @IBOutlet weak var leftPTY: PenaltyBTN!
    @IBOutlet weak var replaySwitch: UISwitch!
    
    let playTypes: [String] = ["kickoff","freekick","down","pat"]
    let playTypesRev: [String:Int] = ["kickoff":0,"freekick":1,"down":2,"pat":3]
    
    var rightPos: Bool = true
    var rightHome: Bool = true
    
    var newPlay: Play?
    var newPenalty: Penalty?
    var kickPenalty: Penalty?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(game.away.name) @ \(game.home.name)"
        
        rightPTY.team = game.home
        leftPTY.team = game.away
        
        field.tracker = self
        
        sequenceTBL.tracker = self
        playTBL.tracker = self
        penaltyTBL.tracker = self
        
        field.fd.hidden = true
        
        disableCancelBTN()
        disableEnterBTN()
        
        if game.sequences.count > 0 { selectSequence(0) } else { addSequence() }
        
        sequenceTBL.reload()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    @IBAction func playTypeChanged(sender: AnyObject) {
        
        let s = game.sequences[index]
        
        let p = playTypes[playTypeSelector.selectedSegmentIndex]
        
        s.key = p
        
        switch p {
        case "down":
            
            s.down = Int(downSelector.value)
            s.fd = s.startX.plus(10)
            
        default:
            
            s.down = nil
            s.fd = nil
            
        }
        
        s.save(nil)
        
        sequenceTBL.reload()
        
        updateBoard()
        
    }
    
    func fieldTOuchesMoved(touches: Set<NSObject>) -> Bool {
        
        if newPlay == nil && newPenalty == nil { return false }
        
        let t: UITouch = touches.first as! UITouch
        let l: CGPoint = t.locationInView(field)
        
        field.showCrosses()
        
        let min: CGFloat = field.ratio
        let max: CGFloat = 119 * field.ratio
        let vmin: CGFloat = 10
        let vmax: CGFloat = field.bounds.height - 10
        
        var x = round(l.x / field.ratio) * field.ratio
        var y = l.y
        
        if x < min { x = min }
        if x > max { x = max }
        if y < vmin { y = vmin }
        if y > vmax { y = vmax }
        
        field.crossH.center.y = y
        field.crossV.center.x = x
        
        return true
        
    }
    
    func fieldTOuchesEnded(touches: Set<NSObject>) -> Bool {
        
        if newPlay != nil || newPenalty != nil {
            
            enableEnterBTN()
            
        }
        
        return true
        
    }
    
    func markerMoved(){
        
        
        
    }
    
    func new(location: CGPoint){
        
        let f = CGRect(x: location.x - (field.bounds.width / 2), y: location.y, width: field.bounds.width, height: field.bounds.height)
        
        var nsel = NumberSelector(nibName: "NumberSelector",bundle: nil)
        nsel.title = "Player"
        nsel.tracker = self
        nsel.type = "player_a"
        nsel.newPlay = Play(s: game.sequences[index])
        
        var nav = UINavigationController(rootViewController: nsel)
        
        popover = UIPopoverController(contentViewController: nav)
        popover.delegate = self
        popover.popoverContentSize = CGSize(width: 220, height: view.bounds.height * 0.6)
        popover.presentPopoverFromRect(field.frame, inView: field, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
        
    }
    
    @IBAction func qtrChanged(sender: AnyObject) {
        
        let s = game.sequences[index]
        
        s.qtr = Int(qtrSelector.value)
        
        qtrTXT.text = "\(Int(qtrSelector.value))"
        
        s.save(nil)
        
        sequenceTBL.reload()
        
    }
    
    @IBAction func downChanged(sender: AnyObject) {
        
        let s = game.sequences[index]
        
        s.down = Int(downSelector.value)
        
        downTXT.text = "\(Int(downSelector.value))"
        
        s.save(nil)
        
        sequenceTBL.reload()
        
    }
    
    @IBAction func posChanged(sender: AnyObject) {
        
        let s = game.sequences[index]
        
        if s.team.object!.isEqual(game.home.object) {
            s.team = game.away
        } else {
            s.team = game.home
        }
        
        s.save(nil)
        
        sequenceTBL.reload()
        
        updateBoard()
        
        draw()
        drawButtons()
        
    }
    
    @IBAction func switchTPD(sender: AnyObject) {
        
        rightHome = !rightHome
        
        sequenceTBL.reload()
        
        updateBoard()
        
        draw()
        drawButtons()
        
    }
    
    @IBAction func replayCHG(sender: AnyObject) {
        
        let s = game.sequences[index]
        
        s.replay = replaySwitch.on
        
        s.save(nil)
        
        sequenceTBL.reload()
        
    }
    
    @IBAction func cancelTPD(sender: AnyObject) {
        
        enableButtons()
        enableField()
        disableCancelBTN()
        disableEnterBTN()
        enableTables()
        field.hideCrosses()
        
        newPlay = nil
        newPenalty = nil
        tn = nil
        sn = nil
        
        draw()
        drawButtons()
        
    }
    
    @IBAction func penaltyTPD(sender: PenaltyBTN) {
        
        let s = game.sequences[index]
        
        let newPenalty = Penalty(s: s)
        newPenalty.team = sender.team
        
        var vc = KeySelector(nibName: "KeySelector",bundle: nil)
        vc.tracker = self
        vc.title = "\(sender.team.short) Penalty"
        vc.newPenalty = newPenalty
        vc.type = "penalty_distance"
        
        var nav = UINavigationController(rootViewController: vc)
        
        popover = UIPopoverController(contentViewController: nav)
        popover.delegate = self
        popover.popoverContentSize = CGSize(width: 283, height: view.bounds.height * 0.6)
        popover.presentPopoverFromRect(field.frame, inView: field, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
        
    }
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        
        println("SHOULD DISMISS")
        
        cancelTPD(1)
        
        return true
        
    }
    
    @IBAction func enterTPD(sender: AnyObject) {
        
        go()
        
    }
    
    func go() -> Bool {
        
        if field.crossH.hidden { return false }
        
        let s = game.sequences[index]
        
        let x = field.toY(field.crossV.center.x).fullToYard(posRight(s))
        
        if let n = newPlay {
            
            println("NEW PLAY")
            n.endX = x
            n.endY = Int(round((field.crossH.center.y / field.bounds.height) * 100))
            
            n.save(nil)
            
            s.plays.append(n)
            
            playTBL.reloadData()
            
            newPlay = nil
            
            disableCancelBTN()
            disableEnterBTN()
            enableButtons()
            enableField()
            enableTables()
            field.hideCrosses()
            
            draw()
            drawButtons()
            
        }
        
        if let penalty = newPenalty {
            
            println("NEW PENALTY")
            penalty.endX = x
            
            penalty.save(nil)
            
            s.penalties.append(penalty)
            
            penaltyTBL.reloadData()
            playTBL.reloadData()
            
            newPenalty = nil
            
            disableCancelBTN()
            disableEnterBTN()
            enableButtons()
            enableField()
            enableTables()
            field.hideCrosses()
            
            draw()
            drawButtons()
            
        }
        
        return true
        
    }
    
    func drawButtons(){
        
        let s = game.sequences[index]
        
        for v in field.subviews {
            
            if v.tag == -1 || v.tag == -3 { v.removeFromSuperview() }
            
        }
        
        for (i,penalty) in enumerate(s.penalties) {
            
            if let x = penalty.endX {
                
                let dir = posRight2(penalty.object.team)
                
                var v = PenaltyMKR(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                v.tracker = self
                v.index = i
                v.tag = -3
                v.dir = dir
                v.setMKR(x)
                
                var tap2 = UITapGestureRecognizer()
                tap2.numberOfTapsRequired = 2
                tap2.addTarget(self, action: "penalty2Tapped:")
                v.addGestureRecognizer(tap2)
                
                field.addSubview(v)
                
            }
            
        }
        
        for (i,play) in enumerate(s.plays) {
            
            if let endX = play.endX {
                
                var button = PointBTN.buttonWithType(.Custom) as! PointBTN
                button.frame = CGRectMake(0,0,20,20)
                button.layer.cornerRadius = 0.5 * button.bounds.size.width
                button.titleLabel?.font = UIFont.systemFontOfSize(12)
                button.tag = -1
                button.index = i
                
                var x = field.toX(play.endX!.yardToFull(posRight(s)))
                var y = field.toP(play.endY!)
                
                button.center = CGPoint(x: x, y: CGFloat(y))
                
                var color = Filters.colors(play.key, alpha: 1.0)
                var textColor = Filters.textColors(play.key, alpha: 1.0)
                
                button.setTitleColor(textColor, forState: UIControlState.Normal)
                button.backgroundColor = color
                
                if play.key == "fumble" {
                    
                    if let r = play.team {
                        
                        button.backgroundColor = r.color
                        
                    }
                    
                }
                
                if let p = play.player_b {
                    button.setTitle("\(p)", forState: UIControlState.Normal)
                } else {
                    button.setTitle("\(play.player_a)", forState: UIControlState.Normal)
                }
                
                var pan = UIPanGestureRecognizer()
                pan.addTarget(self, action: "buttonDragged:")
                
                var tap2 = UITapGestureRecognizer()
                tap2.numberOfTapsRequired = 2
                tap2.addTarget(self, action: "button2Tapped:")
                
                button.addGestureRecognizer(pan)
                button.addGestureRecognizer(tap2)
                
                field.addSubview(button)
                
            }
            
        }
        
    }
    
    func drawSubButtons(playIndex: Int){
        
        let s = game.sequences[index]
        
        let pos_right = posRight(s)
        
        for play in s.plays {
            
            if play.key != "penalty" {
                
                var g = 0
                
                for (i,tackle) in enumerate(play.tackles) {
                    
                    var r: Float = 36.0/*distance*/
                    var o: Float = ((315/*start*/ + 45) * (Float(M_PI) / 180)) + ((Float(g+1) * 45/*spacing*/) * (Float(M_PI) / 180))
                    var x: Float = cos(o) * r
                    var y: Float = sin(o) * r
                    
                    let xx = field.toX(play.endX!.yardToFull(pos_right))
                    let yy = (CGFloat(play.endY!) / 100) * field.bounds.height
                    
                    var t = SubBTN.buttonWithType(.Custom) as! SubBTN
                    t.frame = CGRectMake(0,0,20,20)
                    t.center = CGPoint(x: xx - CGFloat(x), y: yy - CGFloat(y))
                    t.layer.cornerRadius = 0.5 * t.bounds.size.width
                    t.backgroundColor = UIColor.brownColor()
                    t.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    t.titleLabel?.font = UIFont.systemFontOfSize(12)
                    t.setTitle("\(tackle)", forState: .Normal)
                    t.tag = -2
                    t.index = g
                    t.play = play
                    t.type = "tackle"
                    t.itemIndex = i
                    t.buttonIndex = g
                    
                    var tap = UITapGestureRecognizer()
                    tap.numberOfTapsRequired = 2
                    tap.addTarget(self, action: "subTapped:")
                    
                    t.addGestureRecognizer(tap)
                    
                    field.addSubview(t)
                    
                    g++
                    
                }
                
                for (i,sack) in enumerate(play.sacks) {
                    
                    var r: Float = 36.0/*distance*/
                    var o: Float = ((315/*start*/ + 45) * (Float(M_PI) / 180)) + ((Float(g+1) * 45/*spacing*/) * (Float(M_PI) / 180))
                    var x: Float = cos(o) * r
                    var y: Float = sin(o) * r
                    
                    let xx = field.toX(play.endX!.yardToFull(pos_right)) - CGFloat(x)
                    let yy = ((CGFloat(play.endY!) / 100) * field.bounds.height) - CGFloat(y)
                    
                    var t = SubBTN.buttonWithType(.Custom) as! SubBTN
                    t.frame = CGRectMake(0,0,20,20)
                    t.center = CGPoint(x: xx, y: yy)
                    t.layer.cornerRadius = 0.5 * t.bounds.size.width
                    t.backgroundColor = UIColor.purpleColor()
                    t.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    t.titleLabel?.font = UIFont.systemFontOfSize(12)
                    t.setTitle("\(sack)", forState: .Normal)
                    t.tag = -2
                    t.index = g
                    t.play = play
                    t.type = "sack"
                    t.itemIndex = i
                    t.buttonIndex = g
                    
                    var tap = UITapGestureRecognizer()
                    tap.numberOfTapsRequired = 2
                    tap.addTarget(self, action: "subTapped:")
                    
                    t.addGestureRecognizer(tap)
                    
                    field.addSubview(t)
                    
                    g++
                    
                }
                
            }
            
        }
        
    }
    
    func subTapped(sender: UITapGestureRecognizer){
        
        let b: SubBTN = sender.view as! SubBTN
        
        switch b.type {
        case "tackle":
            b.play.tackles.removeAtIndex(b.itemIndex)
        default:
            b.play.sacks.removeAtIndex(b.itemIndex)
        }
        
        draw()
        
    }
    
    var bLast: CGPoint!
    
    func buttonDragged(sender: UIPanGestureRecognizer){
        
        let t = sender.translationInView(field)
        
        let b: PointBTN = sender.view as! PointBTN
        
        let s = game.sequences[index]
        let play = s.plays[b.index]
        
        if sender.state == UIGestureRecognizerState.Began {
            
            bLast = sender.view?.center
            
        }
        
        if sender.state == UIGestureRecognizerState.Changed {
            
            let min = field.ratio
            let max = 119 * field.ratio
            let vmin = b.bounds.height / 2
            let vmax = field.bounds.height - (b.bounds.height / 2)
            
            var x = round((t.x + bLast.x) / field.ratio) * field.ratio
            var y = t.y + bLast.y
            
            if x < min { x = min }
            if x > max { x = max }
            if y < vmin { y = vmin }
            if y > vmax { y = vmax }
            
            sender.view?.center.x = x
            sender.view?.center.y = y
            
            play.endX = field.toY(x).fullToYard(posRight(s))
            play.endY = Int(round((y / field.bounds.height) * 100))
            
            field.showCrosses()
            field.crossV.center.x = x
            field.crossH.center.y = y
            
            playTBL.reloadData()
            
            draw()
            
        }
        
        if sender.state == UIGestureRecognizerState.Ended {
            
            play.save(nil)
            
            field.hideCrosses()
            
        }
        
    }
    
    var tn: Int?
    var sn: Int?
    func button2Tapped(sender: UITapGestureRecognizer){
        
        let b: PointBTN = sender.view as! PointBTN
        
        let s = game.sequences[index]
        
        var alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        var tackle = UIAlertAction(title: "Tackle", style: UIAlertActionStyle.Default) { action -> Void in
            
            var nsel = NumberSelector(nibName: "NumberSelector",bundle: nil)
            nsel.tracker = self
            nsel.type = "tackle"
            nsel.newPlay = Play(s: s)
            nsel.i = b.index
            
            var nav = UINavigationController(rootViewController: nsel)
            
            self.popover = UIPopoverController(contentViewController: nav)
            self.popover.delegate = self
            self.popover.popoverContentSize = CGSize(width: 283, height: self.view.bounds.height * 0.6)
            self.popover.presentPopoverFromRect(b.frame, inView: self.field, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
            
        }
        
        var sack = UIAlertAction(title: "Sack", style: UIAlertActionStyle.Default) { action -> Void in
            
            var nsel = NumberSelector(nibName: "NumberSelector",bundle: nil)
            nsel.tracker = self
            nsel.type = "sack"
            nsel.newPlay = Play(s: s)
            nsel.i = b.index
            
            var nav = UINavigationController(rootViewController: nsel)
            
            self.popover = UIPopoverController(contentViewController: nav)
            self.popover.delegate = self
            self.popover.popoverContentSize = CGSize(width: 283, height: self.view.bounds.height * 0.6)
            self.popover.presentPopoverFromRect(b.frame, inView: self.field, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
            
        }
        
        var fumble = UIAlertAction(title: "Fumble", style: UIAlertActionStyle.Default) { action -> Void in
            
            var alert2 = UIAlertController(title: "Recovery", message: nil, preferredStyle: .ActionSheet)
            
            var away = UIAlertAction(title: String(self.game.away.short), style: .Default, handler: { action -> Void in
                
                self.newPlay = Play(s: s)
                self.newPlay?.key = "fumble"
                self.newPlay?.player_a = b.titleLabel?.text?.toInt()
                self.newPlay?.team = self.game.away
                
                var nsel = NumberSelector(nibName: "NumberSelector",bundle: nil)
                nsel.tracker = self
                nsel.newPlay = self.newPlay
                nsel.type = "player_b"
                
                var nav = UINavigationController(rootViewController: nsel)
                
                self.popover = UIPopoverController(contentViewController: nav)
                self.popover.delegate = self
                self.popover.popoverContentSize = CGSize(width: 283, height: self.view.bounds.height * 0.6)
                self.popover.presentPopoverFromRect(b.frame, inView: self.field, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
                
            })
            
            var home = UIAlertAction(title: String(self.game.home.short), style: .Default, handler: { action -> Void in
                
                self.newPlay = Play(s: s)
                self.newPlay?.key = "fumble"
                self.newPlay?.player_a = b.titleLabel?.text?.toInt()
                self.newPlay?.team = self.game.home
                
                var nsel = NumberSelector(nibName: "NumberSelector",bundle: nil)
                nsel.tracker = self
                nsel.newPlay = self.newPlay
                nsel.type = "player_b"
                
                var nav = UINavigationController(rootViewController: nsel)
                
                self.popover = UIPopoverController(contentViewController: nav)
                self.popover.delegate = self
                self.popover.popoverContentSize = CGSize(width: 283, height: self.view.bounds.height * 0.6)
                self.popover.presentPopoverFromRect(b.frame, inView: self.field, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
                
            })
            
            var no = UIAlertAction(title: "No Recovery", style: .Default, handler: { action -> Void in
                
                self.newPlay = Play(s: s)
                self.newPlay?.key = "fumble"
                self.newPlay?.player_a = b.titleLabel?.text?.toInt()
                
                self.spot()
                
            })
            
            var cancel2 = UIAlertAction(title: "Cancel", style: .Default, handler: { action -> Void in
                
                
                
            })
            
            alert2.addAction(home)
            alert2.addAction(away)
            alert2.addAction(no)
            alert2.addAction(cancel2)
            
            if let popoverController2 = alert2.popoverPresentationController {
                
                popoverController2.sourceView = b
                popoverController2.sourceRect = b.bounds
                
            }
            
            self.presentViewController(alert2, animated: false, completion: nil)
            
        }
        
        var delete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { action -> Void in
            
            var alert3 = UIAlertController(title: nil, message: "Delete this play?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            var delete2 = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { action -> Void in
                
                let play = s.plays[b.index]
                play.delete(nil)
                s.plays.removeAtIndex(b.index)
                
                self.playTBL.deleteRowsAtIndexPaths([NSIndexPath(forRow: b.index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
                
                self.draw()
                self.drawButtons()
                
            }
            
            var cancel3 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { action -> Void in
                
                self.newPlay = nil
                
            }
            
            alert3.addAction(delete2)
            alert3.addAction(cancel3)
            
            if let popoverController3 = alert3.popoverPresentationController {
                
                popoverController3.sourceView = b
                popoverController3.sourceRect = b.bounds
                
            }
            
            self.presentViewController(alert3, animated: true, completion: nil)
            
        }
        
        alert.addAction(tackle)
        alert.addAction(sack)
        alert.addAction(fumble)
        alert.addAction(delete)
        
        if let popoverController = alert.popoverPresentationController {
            
            popoverController.sourceView = b
            popoverController.sourceRect = b.bounds
            
        }
        
        presentViewController(alert, animated: false, completion: nil)
        
    }
    
    func penalty2Tapped(sender: UITapGestureRecognizer){
        
        let b: PenaltyMKR = sender.view as! PenaltyMKR
        
        let s = game.sequences[index]
        
        var alert = UIAlertController(title: "Delete this penalty?", message: nil, preferredStyle: .ActionSheet)
        
        var yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive) { action -> Void in
            
            let penalty = s.penalties[b.index]
            
            penalty.delete(nil)
            
            s.penalties.removeAtIndex(b.index)
            self.penaltyTBL.deleteRowsAtIndexPaths([NSIndexPath(forRow: b.index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
            
            self.draw()
            self.drawButtons()
            
        }
        
        var no = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) { action -> Void in
            
            
            
        }
        
        alert.addAction(yes)
        alert.addAction(no)
        
        if let popoverController = alert.popoverPresentationController {
            
            popoverController.sourceView = b
            popoverController.sourceRect = b.bounds
            
        }
        
        presentViewController(alert, animated: false, completion: nil)
        
    }
    
    func button3Tapped(sender: UITapGestureRecognizer) -> Bool {
        
        if let p = newPlay { return false }
        
        let b: PointBTN = sender.view as! PointBTN
        
        var alert = UIAlertController(title: nil, message: "Delete this play?", preferredStyle: UIAlertControllerStyle.Alert)
        
        var delete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { action -> Void in
            
            self.game.sequences[self.index].plays.removeAtIndex(b.index)
            
            self.playTBL.deleteRowsAtIndexPaths([NSIndexPath(forRow: b.index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
            
            self.draw()
            self.drawButtons()
            
        }
        
        var cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { action -> Void in
            
            
            
        }
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        return false
        
    }
    
    func fieldTPD(sender: UITapGestureRecognizer){
        
        let location = sender.locationInView(field)
        
        if enterBTN.userInteractionEnabled {
            
            enterTPD(1)
            
        } else {
            
            if newPlay == nil && newPenalty == nil {
                
                new(location)
                
            }
            
        }
        
    }
    
    @IBAction func newTPD(sender: AnyObject) {
        
        let s = game.sequences[index]
        
//        let k = KickoffFilter.run(self, original: s)
        addSequence()
        
    }
    
    func updateBoard(){
        
        let s = game.sequences[index]
        
        qtrSelector.value = Double(s.qtr)
        qtrTXT.text = "\(s.qtr)"
        
        if let d = s.down {
            downSelector.value = Double(d)
            downTXT.text = "\(d)"
        }
        
        field.fd.hidden = (s.fd == nil)
        downSelector.hidden = (s.down == nil)
        downTXT.hidden = (s.down == nil)
        
        switch s.key {
        case "kickoff":
            playTypeSelector.selectedSegmentIndex = 0
        case "freekick":
            playTypeSelector.selectedSegmentIndex = 1
        case "down":
            playTypeSelector.selectedSegmentIndex = 2
        default:
            playTypeSelector.selectedSegmentIndex = 3
        }
        
        let pos_right = posRight(s)
        
        if pos_right {
            
            posSelector.selectedSegmentIndex = 1
            
        } else {
            
            posSelector.selectedSegmentIndex = 0
            
        }
        
        field.los.moveTo(s.startX,pos_right: pos_right)
        
        if let fd = s.fd {
            
            field.fd.moveTo(fd, pos_right: pos_right)
            
        }
        
        if rightHome {
            
            rightPTY.team = game.home
            rightPTY.setTitle(String(game.home.short), forState: UIControlState.Normal)
            leftPTY.team = game.away
            leftPTY.setTitle(String(game.away.short), forState: UIControlState.Normal)
            
        } else {
            
            rightPTY.team = game.away
            rightPTY.setTitle(String(game.away.short), forState: UIControlState.Normal)
            leftPTY.team = game.home
            leftPTY.setTitle(String(game.home.short), forState: UIControlState.Normal)
            
        }
        
        replaySwitch.setOn(s.replay, animated: true)
        
        field.ball.center.x = field.los.center.x
        field.ball.center.y = (CGFloat(s.startY) / 100) * field.bounds.height
        
    }
    
    func createSequence() -> Sequence {
        
        if let prev = game.sequences.first {
            
            switch prev.key {
            case "kickoff","freekick":
                return KickFilter.run(self,original: prev)
            case "pat":
                return PATFilter.run(self, original: prev)
            default:
                return DownFilter.run(self,original: prev)
            }
            
        } else {
            
            var s = Sequence()
            s.team = game.away
            s.qtr = 1
            s.key = "kickoff"
            s.startX = -40
            s.startY = 50
            
            return s
            
        }
        
    }
    
    func addSequence(){
        
        var s = createSequence()
        s.game = game
        s.save(nil)
        
        if let prev = game.sequences.first { prev.save(nil) }
        
        game.sequences.insert(s,atIndex: 0)
        
        sequenceTBL.reload()
        
        selectSequence(0)
        
    }
    
    func numberSelected(n: Int){
        
        if let p = newPlay {
            
            newPlay?.player_b = n
            
            enableField()
            
        } else {
            
            if let t = tn {
                
                game.sequences[index].plays[t].tackles.append(n)
                
                disableCancelBTN()
                enableField()
                
                tn = nil
                sn = nil
                
                draw()
                
            } else if let s = sn {
                
                game.sequences[index].plays[s].sacks.append(n)
                
                disableCancelBTN()
                enableField()
                
                tn = nil
                sn = nil
                
                draw()
                
            } else {
                
                newPlay = Play(s: game.sequences[index])
                newPlay?.player_a = n
                
                enableCancelBTN()
                disableButtons()
                disableField()
                disableTables()
                
            }
            
        }
        
    }
    
    func updateSequence(){
        
        
        
    }
    
    func selectSequence(i: Int){
        
        index = i
        sequenceTBL.selectRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.Top)
        sequenceSelected()
        
    }
    
    func sequenceSelected(){
        
        let s = game.sequences[index]
        s.getPlays()
        s.getPenalties()
        
        playTBL.reloadData()
        penaltyTBL.reloadData()
        
        updateBoard()
        
        draw()
        drawButtons()
        
    }
    
    func sequenceDeleted(){
        
//        log = sequenceTBL.log
        
    }
    
    var keys: [String] = []
    func draw(){
        
        let s = game.sequences[index]
        
        switch playTypes[playTypeSelector.selectedSegmentIndex] {
        case "kickoff":
            if s.plays.count == 0 {
                keys = ["kick"]
            } else {
                keys = ["return"]
            }
        default:
            keys = ["run","pass","interception"]
        }
        
        field.draw()
        
    }
    
    
    
    
    
    // HELPERS
    // ===============================================================
    // ===============================================================
    func posRight(s: Sequence) -> Bool {
        
        return (s.team.object!.isEqual(game.home.object!) && rightHome) || (s.team.object!.isEqual(game.away.object!) && !rightHome)
        
    }
    func posRightPlay(p: Play) -> Bool {
        
        return (p.team!.object!.isEqual(game.home.object!) && rightHome) || (p.team!.object!.isEqual(game.away.object!) && !rightHome)
        
    }
    func posRight2(team: TeamObject) -> Bool {
        
        return (team.isEqual(game.home.object!) && rightHome) || (team.isEqual(game.away.object!) && !rightHome)
        
    }
    func opTeam(team: Team) -> Team {
        
        if team.object.isEqual(game.home.object) {
            return game.away
        } else {
            return game.away
        }
        
    }
    // ===============================================================
    // ===============================================================
    
    
    
    // SWITCHES
    // ===============================================================
    // ===============================================================
    func disableButtons(){
        
        posSelector.alpha = 0.3
        sideSwitch.alpha = 0.3
        qtrSelector.alpha = 0.3
        qtrTXT.alpha = 0.3
        playTypeSelector.alpha = 0.3
        downSelector.alpha = 0.3
        downTXT.alpha = 0.3
        posSelector.userInteractionEnabled = false
        sideSwitch.userInteractionEnabled = false
        qtrSelector.userInteractionEnabled = false
        playTypeSelector.userInteractionEnabled = false
        downSelector.userInteractionEnabled = false
        
    }
    func enableButtons(){
        
        posSelector.alpha = 1
        sideSwitch.alpha = 1
        qtrSelector.alpha = 1
        qtrTXT.alpha = 1
        playTypeSelector.alpha = 1
        downSelector.alpha = 1
        downTXT.alpha = 1
        posSelector.userInteractionEnabled = true
        sideSwitch.userInteractionEnabled = true
        qtrSelector.userInteractionEnabled = true
        playTypeSelector.userInteractionEnabled = true
        downSelector.userInteractionEnabled = true
        
    }
    func disablePlayLog(){
        
        sequenceTBL.alpha = 0.3
        sequenceTBL.userInteractionEnabled = false
        
    }
    func enablePlayLog(){
        
        sequenceTBL.alpha = 1
        sequenceTBL.userInteractionEnabled = true
        
    }
    func disableCancelBTN(){
        
        cancelBTN.alpha = 0.3
        cancelBTN.userInteractionEnabled = false
        
    }
    func enableCancelBTN(){
        
        cancelBTN.alpha = 1
        cancelBTN.userInteractionEnabled = true
        
    }
    func disableField(){
        
        field.alpha = 0.3
        fimg.alpha = 0.3
        field.userInteractionEnabled = false
        
    }
    func enableField(){
        
        field.alpha = 1
        fimg.alpha = 1
        field.userInteractionEnabled = true
        
    }
    func disableEnterBTN(){
        
        enterBTN.alpha = 0.3
        enterBTN.userInteractionEnabled = false
        
    }
    func enableEnterBTN(){
        
        enterBTN.alpha = 1
        enterBTN.userInteractionEnabled = true
        
    }
    func disableTables(){
        
        penaltyTBL.alpha = 0.3
        playTBL.alpha = 0.3
        sequenceTBL.alpha = 0.3
        penaltyTBL.userInteractionEnabled = false
        playTBL.userInteractionEnabled = false
        sequenceTBL.userInteractionEnabled = false
        
    }
    func enableTables(){
        
        penaltyTBL.alpha = 1
        playTBL.alpha = 1
        sequenceTBL.alpha = 1
        penaltyTBL.userInteractionEnabled = true
        playTBL.userInteractionEnabled = true
        sequenceTBL.userInteractionEnabled = true
        
    }
    func disablePenaltyButton(){
        
        rightPTY.alpha = 0.3
        rightPTY.userInteractionEnabled = false
        leftPTY.alpha = 0.3
        leftPTY.userInteractionEnabled = false
        
    }
    func enablePenaltyButton(){
        
        rightPTY.alpha = 1
        rightPTY.userInteractionEnabled = true
        leftPTY.alpha = 1
        leftPTY.userInteractionEnabled = true
        
    }
    func spot(){
        
        enableField()
        disableButtons()
        disableTables()
        enableEnterBTN()
        enableCancelBTN()
        
    }
    // ===============================================================
    // ===============================================================
    
}

extension Int {
    
    func aYard() -> Int {
        
        if self > 0 && self < 100 {
            
            if self > 50 { return 100 - self }
            if self < 50 { return self * -1 }
            
        }
        
        if self < 1 {
            return ((self * -1) + 100) * -1
        }
        
        return self
        
    } // Gets the yard vale
    
    func aX() -> Int {
        
        if self > -50 && self < 0 {
            return self * -1
        }
        if self < 50 && self > 0 {
            return 100 - self
        }
        
        return self
        
    }
    
}

extension Array {
    
    func removeDuplicates() -> [Int] {
        
        var c: [Int] = []
        var tmp: [Int] = []
        
        for a in self {
            
            let b: Int = a as! Int
            
            if !contains(tmp,b) {
                
                tmp.append(b)
                
            }
            
            c.append(b)
            
        }
        
        return tmp
        
    }
    
}