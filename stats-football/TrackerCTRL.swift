//
//  ViewController.swift
//  stats-football
//
//  Created by grobinson on 8/24/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import Foundation
import UIKit

class TrackerCTRL: UIViewController {
    
    var selectedPlayKey: String?
    
    var keySelector: UIAlertController!
    
    var log: [Sequence] = []
    var index: Int = 0
    var drawings: [UIView] = []
    
    var awayTeam = "LHS"
    var homeTeam = "WG"

    @IBOutlet weak var leftNumbers: NumberSelector!
    @IBOutlet weak var playKeySelector: PlaykeyTBL!
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
    @IBOutlet weak var fimg: UIImageView!
    @IBOutlet weak var penaltyBTN: UIButton!
    
    let playTypes: [String] = ["kickoff","freekick","down","pat"]
    let playTypesRev: [String:Int] = ["kickoff":0,"freekick":1,"down":2,"pat":3]
    
    var rightPos: Bool = true
    var rightHome: Bool = true
    
    var newPlay: Play?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        field.tracker = self
        playKeySelector.d = self
        
        sequenceTBL.tracker = self
        playTBL.tracker = self
        
        leftNumbers.d = self
        leftNumbers.numbers = [22,3,45,67,23,5,10,11,99]
        leftNumbers.numbers.sort({ $0 < $1 })
        
        field.fd.hidden = true
        
        disablePlayKeySelector()
        disableCancelBTN()
        disableEnterBTN()
        
        addSequence()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    @IBAction func playTypeChanged(sender: AnyObject) {
        
        let p = playTypes[playTypeSelector.selectedSegmentIndex]
        
        switch p {
        case "kickoff":
            
            field.fd.hidden = true
            field.los.hidden = false
            
        case "freekick":
            
            field.fd.hidden = true
            field.los.hidden = false
            
        case "down":
            
            field.fd.hidden = false
            field.los.hidden = false
            
        case "pat":
            
            field.fd.hidden = true
            field.los.hidden = false
            
        default:
            
            println("B")
            
        }
        
    }
    
    func fieldTOuchesMoved(touches: Set<NSObject>) -> Bool {
        
        if newPlay == nil { return false }
        
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
        
        if let p = newPlay {
            
            enableEnterBTN()
            
        }
        
        return true
        
    }
    
    func markerMoved(){
        
        
        
    }
    
    @IBAction func qtrChanged(sender: AnyObject) {
        
        qtrTXT.text = "\(Int(qtrSelector.value))"
        
    }
    
    @IBAction func downChanged(sender: AnyObject) {
        
        downTXT.text = "\(Int(downSelector.value))"
        
    }
    
    @IBAction func posChanged(sender: AnyObject) {
        
        let s = log[index]
        
        if s.pos_id == homeTeam {
            s.pos_id = awayTeam
        } else {
            s.pos_id = homeTeam
        }
        
        sequenceTBL.reload()
        
        updateBoard()
        
        draw()
        drawButtons()
        
    }
    
    @IBAction func switchTPD(sender: AnyObject) {
        
        rightHome = !rightHome
        
        updateBoard()
        
        draw()
        drawButtons()
        
    }
    
    @IBAction func cancelTPD(sender: AnyObject) {
        
        enableButtons()
        enableNumberSelector()
        disablePlayKeySelector()
        enableField()
        disableCancelBTN()
        disableEnterBTN()
        enableTables()
        field.hideCrosses()
        
        newPlay = nil
        tn = nil
        sn = nil
        
        draw()
        drawButtons()
        
    }
    
    @IBAction func penaltyTPD(sender: UIButton) {
        
//        var alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
//        
//        var homeSel = UIAlertAction(title: "WG", style: UIAlertActionStyle.Default) { action -> Void in
//            
//            
//            
//        }
//        
//        var awaySel = UIAlertAction(title: "LHS", style: UIAlertActionStyle.Default) { action -> Void in
//            
//            
//            
//        }
//        
//        alert.addAction(homeSel)
//        alert.addAction(awaySel)
//        
//        if let popoverController = alert.popoverPresentationController {
//            
//            popoverController.sourceView = sender
//            popoverController.sourceRect = sender.bounds
//            
//        }
//        
//        presentViewController(alert, animated: true, completion: nil)
        
        var pop = PenaltyPOP(nibName: "PenaltyPOP",bundle: nil)
        pop.tracker = self
        
        var pc = UIPopoverController(contentViewController: pop)
        
        pc.popoverContentSize = CGSize(width: 300, height: 800)
        pc.presentPopoverFromRect(sender.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        
    }
    
    @IBAction func enterTPD(sender: AnyObject) {
        
        if let n = newPlay {
            
            let s = log[index]
            
            let pos_right: Bool = (s.pos_id == homeTeam && rightHome) || (s.pos_id == awayTeam && !rightHome)
            
            let x = field.toY(field.crossV.center.x).fullToYard(pos_right)
            
            n.endX = x
            n.endY = Int(round((field.crossH.center.y / field.bounds.height) * 100))
            
            s.plays.append(n)
            
            playTBL.reloadData()
            
            newPlay = nil
            
            disableCancelBTN()
            disableEnterBTN()
            enableNumberSelector()
            enableButtons()
            enableField()
            enableTables()
            field.hideCrosses()
            
            draw()
            drawButtons()
            
        }
        
    }
    
    func drawButtons(){
        
        let s = log[index]
        
        for v in field.subviews {
            
            if v.tag == -1 { v.removeFromSuperview() }
            
        }
        
        for (i,play) in enumerate(s.plays) {
            
            if play.key != "penalty" {
                
                var button = PointBTN.buttonWithType(.Custom) as! PointBTN
                button.frame = CGRectMake(0,0,20,20)
                button.layer.cornerRadius = 0.5 * button.bounds.size.width
                button.titleLabel?.font = UIFont.systemFontOfSize(12)
                button.tag = -1
                button.index = i
                
                let pos_right: Bool = (s.pos_id == homeTeam && rightHome) || (s.pos_id == awayTeam && !rightHome)
                
                var x = field.toX(play.endX!.yardToFull(pos_right))
                var y = field.toP(play.endY!)
                
                button.center = CGPoint(x: x, y: CGFloat(y))
                
                var color = UIColor.blackColor()
                
                switch play.key {
                case "run":
                    color = UIColor(red: 57/255, green: 140/255, blue: 183/255, alpha: 1)
                case "pass":
                    color = UIColor(red: 53/255, green: 255/255, blue: 63/255, alpha: 1)
                case "kick","punt":
                    color = UIColor(red: 255/255, green: 120/255, blue: 0, alpha: 1)
                case "penalty":
                    color = UIColor(red: 255/255, green: 228/255, blue: 0, alpha: 1)
                case "interception":
                    color = UIColor(red: 255/255, green: 47/255, blue: 47/255, alpha: 1)
                default:
                    color = UIColor.blackColor()
                }
                
                button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                button.backgroundColor = color
                
                if play.key == "fumble" {
                    
                    if let r = play.pos_id {
                        
                        if r != s.pos_id {
                            
                            button.backgroundColor = UIColor.redColor()
                            
                        }
                        
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
        
        let s = log[index]
        
        for v in field.subviews {
            
            if v.tag == -2 { v.removeFromSuperview() }
            
        }
        
        let pos_right: Bool = (s.pos_id == homeTeam && rightHome) || (s.pos_id == awayTeam && !rightHome)
        
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
            
            let s = log[index]
            
            let pos_right: Bool = (s.pos_id == homeTeam && rightHome) || (s.pos_id == awayTeam && !rightHome)
            
            s.plays[b.index].endX = field.toY(x).fullToYard(pos_right)
            s.plays[b.index].endY = Int(round((y / field.bounds.height) * 100))
            
            field.showCrosses()
            field.crossV.center.x = x
            field.crossH.center.y = y
            
            playTBL.reloadData()
            
            draw()
            
        }
        
        if sender.state == UIGestureRecognizerState.Ended {
            
            field.hideCrosses()
            
        }
        
    }
    
    var tn: Int?
    var sn: Int?
    func button2Tapped(sender: UITapGestureRecognizer){
        
        let b: PointBTN = sender.view as! PointBTN
        
        let s = log[index]
        
        var alert = UIAlertController(title: "Options", message: nil, preferredStyle: .Alert)
        
        var tackle = UIAlertAction(title: "Tackle", style: UIAlertActionStyle.Default) { action -> Void in
            
            self.tn = b.index
            self.enableNumberSelector()
            self.disableField()
            self.enableCancelBTN()
            
        }
        
        var sack = UIAlertAction(title: "Sack", style: UIAlertActionStyle.Default) { action -> Void in
            
            self.sn = b.index
            self.enableNumberSelector()
            self.disableField()
            self.enableCancelBTN()
            
        }
        
        var fumble = UIAlertAction(title: "Fumble", style: UIAlertActionStyle.Default) { action -> Void in
            
            self.newPlay = Play()
            self.newPlay?.key = "fumble"
            self.newPlay?.player_a = b.titleLabel?.text?.toInt()
            
            var alert2 = UIAlertController(title: "Recovery", message: nil, preferredStyle: .Alert)
            
            var away = UIAlertAction(title: self.awayTeam, style: .Default, handler: { action -> Void in
                
                self.newPlay?.pos_id = self.awayTeam
                
                self.enableNumberSelector()
                self.disableField()
                
            })
            
            var home = UIAlertAction(title: self.homeTeam, style: .Default, handler: { action -> Void in
                
                self.newPlay?.pos_id = self.homeTeam
                
                self.enableNumberSelector()
                self.disableField()
                
            })
            
            var no = UIAlertAction(title: "No Recovery", style: .Default, handler: { action -> Void in
                
                self.enableField()
                
            })
            
            var cancel2 = UIAlertAction(title: "Cancel", style: .Default, handler: { action -> Void in
                
                
                
            })
            
            alert2.addAction(home)
            alert2.addAction(away)
            alert2.addAction(no)
            alert2.addAction(cancel2)
            
            self.presentViewController(alert2, animated: true, completion: nil)
            
        }
        
        var delete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { action -> Void in
            
            var alert3 = UIAlertController(title: nil, message: "Delete this play?", preferredStyle: UIAlertControllerStyle.Alert)
            
            var delete2 = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { action -> Void in
                
                let play = s.plays[b.index]
                s.plays.removeAtIndex(b.index)
                
                self.playTBL.deleteRowsAtIndexPaths([NSIndexPath(forRow: b.index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
                
                self.draw()
                self.drawButtons()
                
            }
            
            var cancel3 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { action -> Void in
                
                
                
            }
            
            alert3.addAction(delete2)
            alert3.addAction(cancel3)
            
            self.presentViewController(alert3, animated: true, completion: nil)
            
        }
        
        var cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { action -> Void in
            
            
            
        }
        
        alert.addAction(tackle)
        alert.addAction(sack)
        alert.addAction(fumble)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func button3Tapped(sender: UITapGestureRecognizer) -> Bool {
        
        if let p = newPlay { return false }
        
        let b: PointBTN = sender.view as! PointBTN
        
        var alert = UIAlertController(title: nil, message: "Delete this play?", preferredStyle: UIAlertControllerStyle.Alert)
        
        var delete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { action -> Void in
            
            self.log[self.index].plays.removeAtIndex(b.index)
            
            self.playTBL.deleteRowsAtIndexPaths([NSIndexPath(forRow: b.index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
            
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
    
    func fieldTPD(){
        
        if enterBTN.userInteractionEnabled {
            
            enterTPD(1)
            
        }
        
    }
    
    @IBAction func newTPD(sender: AnyObject) {
        
        let s = log[index]
        
//        let k = KickoffFilter.run(self, original: s)
        addSequence()
        
    }
    
    func updateBoard(){
        
        let s = log[index]
        
        qtrSelector.value = Double(s.qtr)
        qtrTXT.text = "\(s.qtr)"
        
        if let d = s.down {
            downSelector.value = Double(d)
        }
        
        field.fd.hidden = true
        
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
        
        let pos_right: Bool = (s.pos_id == homeTeam && rightHome) || (s.pos_id == awayTeam && !rightHome)
        
        if pos_right {
            
            posSelector.selectedSegmentIndex = 1
            
        } else {
            
            posSelector.selectedSegmentIndex = 0
            
        }
        
        field.los.moveTo(s.startX,pos_right: pos_right)
        
        if let fd = s.fd {
            
            field.fd.hidden = false
            field.fd.moveTo(fd, pos_right: pos_right)
            
        }
        
        field.ball.center.x = field.los.center.x
        field.ball.center.y = (CGFloat(s.startY) / 100) * field.bounds.height
        
    }
    
    func createSequence() -> Sequence {
        
        var s = Sequence()
        
        if let prev = log.first {
            
            switch prev.key {
            case "kickoff":
                s = KickoffFilter.run(self,original: prev)
            case "freekick":
                s.key = "down"
            case "down":
                s.key = "down"
            case "pat":
                s.key = "kickoff"
            default:
                println("NOTHING")
            }
            
        } else {
            
            s.pos_id = homeTeam
            s.qtr = 1
            s.key = "kickoff"
            s.startX = -40
            s.startY = 50
            
        }
        
        return s
        
    }
    
    func addSequence(){
        
        let s = createSequence()
        
        log.insert(s,atIndex: 0)
        sequenceTBL.reload()
        
        selectSequence(0)
        
    }
    
    func numberSelected(n: Int){
        
        if let p = newPlay {
            
            newPlay?.player_b = n
            
            disableNumberSelector()
            enableField()
            
        } else {
            
            if let t = tn {
                
                log[index].plays[t].tackles.append(n)
                
                disableCancelBTN()
                enableField()
                
                tn = nil
                sn = nil
                
                draw()
                
            } else if let s = sn {
                
                log[index].plays[s].sacks.append(n)
                
                disableCancelBTN()
                enableField()
                
                tn = nil
                sn = nil
                
                draw()
                
            } else {
                
                newPlay = Play()
                newPlay?.player_a = n
                
                disableNumberSelector()
                enablePlayKeySelector()
                enableCancelBTN()
                disableButtons()
                disableField()
                disableTables()
                
            }
            
        }
        
    }
    
    func playKeySelected(key: String){
        
        newPlay?.key = key
        
        switch key {
        case "pass","interception":
            
            disablePlayKeySelector()
            enableNumberSelector()
            
        case "penalty":
            
            var rAlert = UIAlertController(title: "Replay Down?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            
            var yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action -> Void in
                
                self.log[self.index].replay = true
                
                self.disablePlayKeySelector()
                self.enableField()
                
            })
            
            var no = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { action -> Void in
                
                self.log[self.index].replay = false
                
                self.disablePlayKeySelector()
                self.enableField()
                
            })
            
            var cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { action -> Void in
                
                
                
            })
            
            rAlert.addAction(yes)
            rAlert.addAction(no)
            rAlert.addAction(cancel)
            
            var dAlert = UIAlertController(title: "Distance", message: nil, preferredStyle: .Alert)
            
            var d5 = UIAlertAction(title: "5 yards", style: UIAlertActionStyle.Default, handler: { action -> Void in
                
                self.newPlay?.penaltyDistance = 5
                
                self.presentViewController(rAlert, animated: true, completion: nil)
                
            })
            
            var d10 = UIAlertAction(title: "10 yards", style: UIAlertActionStyle.Default, handler: { action -> Void in
                
                self.newPlay?.penaltyDistance = 10
                
                self.presentViewController(rAlert, animated: true, completion: nil)
                
            })
            
            var d15 = UIAlertAction(title: "15 yards", style: UIAlertActionStyle.Default, handler: { action -> Void in
                
                self.newPlay?.penaltyDistance = 15
                
                self.presentViewController(rAlert, animated: true, completion: nil)
                
            })
            
            dAlert.addAction(d5)
            dAlert.addAction(d10)
            dAlert.addAction(d15)
            dAlert.addAction(cancel)
            
            presentViewController(dAlert, animated: true, completion: nil)
            
        case "tackle":
            
            let s = log[index]
            
            var prev: Play?
            
            var i = 0
            
            for play in s.plays {
                
                if let p = play.endX {
                    
                    prev = play
                    
                    break
                    
                }
                
                i++
                
            }
            
            if let p = prev {
                
                log[index].plays[i].tackles.append(newPlay!.player_a)
                
            }
            
            cancelTPD(1)
            
        default:
            
            disablePlayKeySelector()
            enableField()
            
        }
        
    }
    
    func updateSequence(){
        
        
        
    }
    
    func selectSequence(i: Int){
        println("SELECT SEQUENCE \(i)")
        index = i
        sequenceTBL.selectRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.Top)
        sequenceSelected()
        
    }
    
    func sequenceSelected(){
        
        let s = log[index]
        
        playTBL.reloadData()
        
        updateBoard()
        
        draw()
        drawButtons()
        
    }
    
    func sequenceDeleted(){
        
//        log = sequenceTBL.log
        
    }
    
    func draw(){
        
        let s = log[index]
        
        switch playTypes[playTypeSelector.selectedSegmentIndex] {
        case "kickoff":
            if s.plays.count == 0 {
                playKeySelector.keys = ["kick"]
            } else {
                playKeySelector.keys = ["return","lateral","recovery"]
            }
        default:
            playKeySelector.keys = ["run","pass","interception"]
        }
        
        playKeySelector.keys.append("penalty")
        
        playKeySelector.reloadData()
        
        field.draw()
        
    }
    
    
    
    
    
    // SWITCHES
    // ===============================================================
    // ===============================================================
    func disablePlayKeySelector(){
        
        playKeySelector.alpha = 0.3
        playKeySelector.userInteractionEnabled = false
        
    }
    func enablePlayKeySelector(){
        
        playKeySelector.alpha = 1.0
        playKeySelector.userInteractionEnabled = true
        
    }
    func disableNumberSelector(){
        
        leftNumbers.alpha = 0.3
        leftNumbers.userInteractionEnabled = false
        
    }
    func enableNumberSelector(){
        
        leftNumbers.alpha = 1.0
        leftNumbers.userInteractionEnabled = true
        
    }
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
        
        playTBL.alpha = 0.3
        sequenceTBL.alpha = 0.3
        playTBL.userInteractionEnabled = false
        sequenceTBL.userInteractionEnabled = false
        
    }
    func enableTables(){
        
        playTBL.alpha = 1
        sequenceTBL.alpha = 1
        playTBL.userInteractionEnabled = true
        sequenceTBL.userInteractionEnabled = true
        
    }
    func disablePenaltyButton(){
        
        penaltyBTN.alpha = 0.3
        penaltyBTN.userInteractionEnabled = false
        
    }
    func enablePenaltyButton(){
        
        penaltyBTN.alpha = 1
        penaltyBTN.userInteractionEnabled = true
        
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