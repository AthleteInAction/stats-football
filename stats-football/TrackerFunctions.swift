//
//  TrackerFunctions.swift
//  stats-football
//
//  Created by grobinson on 9/27/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import UIKit

extension Tracker {
    
    // SET DATA
    // ========================================================
    // ========================================================
    func setData(){
        
        JP("SET DATA")
        
        Loading.start()
        
        Rhino.run({
            
            self.game.getSequences()
            
            for _sequence in self.game.sequences {
                
                _sequence.getPlays()
                _sequence.getPenalties()
                
                _sequence.scoreSave(nil)
                
            }
            
        },completion: { () -> Void in
            
            if self.game.sequences.count == 0 { self.newSequence(1) }
            
            self.selectSequence(0)
            
            MPC.startAdvertising()
            
            Loading.stop()
            
            self.game.qtrScoring()
            
        })
        
    }
    // ========================================================
    // ========================================================
    
    
    // UPDATE SCOREBOARD
    // ========================================================
    // ========================================================
    func updateScoreboard(){
        
        let s = game.sequences[index]
        
        let pos_right = posRight(s)
        
        // Set Quarter
        // ++++++++++++++++++++++++++++++++++++++
        switch s.qtr {
        case 1: qtrTXT.text = "\(s.qtr)st QTR"
        case 2: qtrTXT.text = "\(s.qtr)nd QTR"
        case 3: qtrTXT.text = "\(s.qtr)rd QTR"
        case 4: qtrTXT.text = "\(s.qtr)th QTR"
        case 5...1000: qtrTXT.text = "OT \(s.qtr - 4)"
        default: "E"
        }
        
        qtrSEL.value = Double(s.qtr)
        // ++++++++++++++++++++++++++++++++++++++
        
        // Set Playtype
        // ++++++++++++++++++++++++++++++++++++++
        playTypeSEL.selectedSegmentIndex = s.key.int
        // ++++++++++++++++++++++++++++++++++++++
        
        // Set Down
        // ++++++++++++++++++++++++++++++++++++++
        downSEL.hidden = s.key != Playtype.Down
        downTXT.hidden = s.key != Playtype.Down
        field.line.center.x = s.startX.toX(pos_right)
        if let x = s.fd {
            
            field.fd.center.x = x.toX(pos_right)
            if x.spot >= 100 { field.fd.backgroundColor = UIColor.redColor() } else { field.fd.backgroundColor = UIColor.yellowColor() }
        
        }
        field.fd.hidden = s.fd == nil
        // ++++++++++++++++++++++++++++++++++++++
        
        // Set Side
        // ++++++++++++++++++++++++++++++++++++++
        if game.right_home {
            
            rightTEAM.setTitle(game.home.short, forState: .Normal)
            rightTEAM.backgroundColor = game.home.primary
            rightTEAM.setTitleColor(game.home.secondary, forState: .Normal)
            
            leftTEAM.setTitle(game.away.short, forState: .Normal)
            leftTEAM.backgroundColor = game.away.primary
            leftTEAM.setTitleColor(game.away.secondary, forState: .Normal)
            
            rightPTY.team = game.home
            rightPTY.setTitle(game.home.short+" Penalty", forState: .Normal)
            
            leftPTY.team = game.away
            leftPTY.setTitle(game.away.short+" Penalty", forState: .Normal)
            
            leftStats = UIBarButtonItem(title: game.away.short+" Stats", style: .Plain, target: self, action: "statsTPD:")
            leftStats.tag = 0
            rightStats = UIBarButtonItem(title: game.home.short+" Stats", style: .Plain, target: self, action: "statsTPD:")
            rightStats.tag = 1
            
        } else {
            
            rightTEAM.setTitle(game.away.short, forState: .Normal)
            rightTEAM.backgroundColor = game.away.primary
            rightTEAM.setTitleColor(game.away.secondary, forState: .Normal)
            
            leftTEAM.setTitle(game.home.short, forState: .Normal)
            leftTEAM.backgroundColor = game.home.primary
            leftTEAM.setTitleColor(game.home.secondary, forState: .Normal)
            
            rightPTY.team = game.away
            rightPTY.setTitle(game.away.short+" Penalty", forState: .Normal)
            
            leftPTY.team = game.home
            leftPTY.setTitle(game.home.short+" Penalty", forState: .Normal)
            
            leftStats = UIBarButtonItem(title: game.home.short+" Stats", style: .Plain, target: self, action: "statsTPD:")
            leftStats.tag = 1
            rightStats = UIBarButtonItem(title: game.away.short+" Stats", style: .Plain, target: self, action: "statsTPD:")
            rightStats.tag = 0
            
        }
        // ++++++++++++++++++++++++++++++++++++++
        
        field.line.backgroundColor = s.team.primary
        
        toolbar.items = [leftStats,sep,rightStats,flexSpace,eraseBTN,flexSpace,exportBTN,sep,docs]
        
        tosTXT.hidden = s.score == .None
        tosTXT.text = s.score_time
        
        rightBALL.hidden = !pos_right
        leftBALL.hidden = pos_right
        
        updateDown()
        updateScore()
        updateArrows()
        updateLog()
        
    }
    // ========================================================
    // ========================================================
    
    func updateLog(){
        
        let s = game.sequences[index]
        
        eraseBTN.enabled = s.plays.count > 0 || s.penalties.count > 0
        
    }
    
    
    // UPDATE ARROWS
    func updateArrows(){
        
        let s = game.sequences[index]
        
        let pos_right = posRight(s)
        
        // Arrows
        // ++++++++++++++++++++++++++++++++++++++
        if pos_right {
            
            field.arrows.image = UIImage(named: "arrows-left.png")
            field.arrows.frame = CGRect(x: field.line.center.x, y: 0, width: -1053, height: 63)
            field.arrows.center.y = field.bounds.height/2
            
        } else {
            
            field.arrows.image = UIImage(named: "arrows.png")
            field.arrows.frame = CGRect(x: field.line.center.x, y: 0, width: 1053, height: 63)
            field.arrows.center.y = field.bounds.height/2
            
        }
        // ++++++++++++++++++++++++++++++++++++++
        
    }
    
    
    // UPDATE SCORE
    func updateScore(){
        
        Rhino.run({
            
            self.game.getScore()
            
        }, completion: { () -> Void in
            
            if self.game.right_home {
                
                self.leftSCORE.text = self.game.away.score.string()
                self.rightSCORE.text = self.game.home.score.string()
                
            } else {
                
                self.leftSCORE.text = self.game.home.score.string()
                self.rightSCORE.text = self.game.away.score.string()
                
            }
            
            MPC.sendGame(self.game)
            
        })
        
    }
    
    
    // UPDATE DOWN
    // ========================================================
    // ========================================================
    func updateDown(){
        
        let s = game.sequences[index]
        
        let pos_right = posRight(s)
        
        var down = ""
        if let d = s.down {
            
            switch d {
            case 2:
                down += "2nd and "
            case 3:
                down += "3rd and "
            case 4:
                down += "4th and "
            default:
                down += "1st and "
            }
            
            downSEL.selectedSegmentIndex = d-1
            
            lastDOWN = d
            
        }
        
        if let first = s.fd {
            
            let a = s.startX.spot
            let b = first.spot
            
            var togo = "\(b - a)"
            
            if first.spot >= 100 { togo = "G" }
            
            down += togo
            
            lastFD = first
            
        }
        
        if s.key == .Down {
            
            downTXT.text = down
            
        }
        
        let ip = NSIndexPath(forRow: index, inSection: 0)
        sequenceTBL.reloadRowsAtIndexPaths([ip], withRowAnimation: .None)
        sequenceTBL.selectRowAtIndexPath(ip, animated: false, scrollPosition: .None)
        
    }
    // ========================================================
    // ========================================================
    
    
    // SELECT SEQUENCE
    // ========================================================
    // ========================================================
    func selectSequence(i: Int) -> Bool {
        
        lastDOWN = nil
        lastFD = nil
        
        if game.sequences.count == 0 { return false }
        
        switch i {
        case 0 ... (game.sequences.count - 1):
            
            index = i
            
        default:
            
            JP("INDEX OUT OF RANGE: \(i)")
            index = 0
            
            return false
            
        }
        
        sequenceTBL.reload()
        
        updateScoreboard()
        
        field.setNeedsDisplay()
        drawButtons()
        
        return true
        
    }
    // ========================================================
    // ========================================================
    
    
    // FIELD DOUBLE TAPPED
    // ========================================================
    // ========================================================
    func field2TPD(sender: UITapGestureRecognizer){
        
        let location = sender.locationInView(field)
        
        if enterOn {
            
            go()
            
        } else {
            
            if newPlay == nil && newPenalty == nil {
                
                startPlay(location)
                
            }
            
        }
        
    }
    // ========================================================
    // ========================================================
    
    
    // START PLAY
    // ========================================================
    // ========================================================
    func startPlay(location: CGPoint) -> Bool {
        
        let f = CGRect(x: location.x - (field.bounds.width / 2), y: location.y, width: field.bounds.width, height: field.bounds.height)
        
        var nsel = NumberSelector(nibName: "NumberSelector",bundle: nil)
        nsel.title = "Player"
        nsel.tracker = self
        nsel.type = "player_a"
        nsel.newPlay = Play(s: game.sequences[index])
        
        var nav = UINavigationController(rootViewController: nsel)
        
        popover = UIPopoverController(contentViewController: nav)
        popover.delegate = self
        popover.popoverContentSize = CGSize(width: 500, height: view.bounds.height * 0.85)
        popover.presentPopoverFromRect(CGRect(x: field.bounds.width/2, y: field.bounds.height, width: 0, height: 0), inView: field, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
        
        return true
        
    }
    // ========================================================
    // ========================================================
    
    
    // GO
    // ========================================================
    // ========================================================
    func go() -> Bool {
        
        if field.crossH.hidden { return false }
        
        let s = game.sequences[index]
        
        let pos_right = posRight(s)
        
        let x = Yardline(x: field.crossV.center.x, pos_right: pos_right)
        
        if let n = newPlay {
            
            n.endX = x
            n.endY = Int(round((field.crossH.center.y / field.bounds.height) * 100))
            
            if pos_right { n.endY = 100 - n.endY! }
            
            n.save(nil)
            
            s.plays.append(n)
            
            field.setNeedsDisplay()
            drawButtons()
            
            cancelTPD(1)
            
            s.scoreSave(nil)
            updateScoreboard()
            
        }
        
        if let penalty = newPenalty {
            
            penalty.endX = x
            
            penalty.save(nil)
            
            s.penalties.append(penalty)
            
            field.setNeedsDisplay()
            drawButtons()
            
            cancelTPD(1)
            
            s.scoreSave(nil)
            updateScoreboard()
            
        }
        
        return true
        
    }
    // ========================================================
    // ========================================================
    
    
    // FIELD TOUCHES BEGAN
    // ========================================================
    // ========================================================
    func fieldTouchesBegan(touches: Set<NSObject>) -> Bool {
        
        if newPlay == nil && newPenalty == nil { return false }
        
        let s = game.sequences[index]
        
        let pos_right = posRight(s)
        
        let t: UITouch = touches.first as! UITouch
        let l: CGPoint = t.locationInView(field)
        
        let min: CGFloat = ratio
        let max: CGFloat = 119 * ratio
        let vmin: CGFloat = 10
        let vmax: CGFloat = field.bounds.height - ratio
        
        var x = round(l.x / ratio) * ratio
        var y = l.y
        
        if x < min { x = min }
        if x > max { x = max }
        if y < vmin { y = vmin }
        if y > vmax { y = vmax }
        
        if let n = newPlay {
            
            n.endX = Yardline(x: x, pos_right: pos_right)
            n.endY = Int(round((y / field.bounds.height) * 100))
            if pos_right { n.endY = 100 - n.endY! }
            
            n.save(nil)
            
            s.plays.append(n)
            
            field.setNeedsDisplay()
            drawButtons()
            
        }
        
        if let n = newPenalty {
            
            n.endX = Yardline(x: x, pos_right: pos_right)
            
            switch n.enforcement as Key {
            case .Declined,.Offset,.OnKick:
                
                n.endY = Int(round((y / field.bounds.height) * 100))
                if pos_right { n.endY = 100 - n.endY! }
                
            default:()
            }
            
            n.save(nil)
            
            s.penalties.append(n)
            
            field.setNeedsDisplay()
            drawButtons()
            
        }
        
        return true
        
    }
    // ========================================================
    // ========================================================
    
    
    // FIELD TOUCHES MOVED
    // ========================================================
    // ========================================================
    func fieldTouchesMoved(touches: Set<NSObject>) -> Bool {
        
        if newPlay == nil && newPenalty == nil { return false }
        
        let s = game.sequences[index]
        
        let pos_right = posRight(s)
        
        let t: UITouch = touches.first as! UITouch
        let l: CGPoint = t.locationInView(field)
        
        let min: CGFloat = ratio
        let max: CGFloat = 119 * ratio
        let vmin: CGFloat = 10
        let vmax: CGFloat = field.bounds.height - ratio
        
        var x = round(l.x / ratio) * ratio
        var y = l.y
        
        if x < min { x = min }
        if x > max { x = max }
        if y < vmin { y = vmin }
        if y > vmax { y = vmax }
        
        field.showCrosses()
        
        field.crossH.center.y = y
        field.crossV.center.x = x
        
        if s.plays.count == 1 {
            
            if let play = newPlay {
                
                let pct: CGFloat = y / field.bounds.height
                
                switch play.key as Key {
                case .Run:
                    
                    let r = settings.runSections
                    let ss = settings.sectionSize(pct: pct, height: field.bounds.height, sections: r)
                    
                    let _frame = CGRect(x: 0, y: ss[0], width: field.bounds.width, height: ss[1])
                    field.highlight.backgroundColor = Filters.colors(.Run, alpha: 1)
                    field.highlight.frame = _frame
                    field.highlight.hidden = false
                    
                case .Pass,.Incomplete,.Interception:
                    
                    let r = settings.passSections
                    let ss = settings.sectionSize(pct: pct, height: field.bounds.height, sections: r)
                    
                    let _frame = CGRect(x: 0, y: ss[0], width: field.bounds.width, height: ss[1])
                    field.highlight.backgroundColor = Filters.colors(.Pass, alpha: 1)
                    field.highlight.frame = _frame
                    field.highlight.hidden = false
                    
                default:
                    
                    ()
                    
                }
                
            }
            
        }
        
        if let p = newPlay {
            
            if let play = s.plays.last {
                
                play.endX = Yardline(x: x, pos_right: pos_right)
                play.endY = Int(round((y / field.bounds.height) * 100))
                if pos_right { play.endY = 100 - play.endY! }
                
                field.setNeedsDisplay()
                drawButtons()
                
                let ip = NSIndexPath(forRow: index, inSection: 0)
                sequenceTBL.reloadRowsAtIndexPaths([ip], withRowAnimation: .None)
                sequenceTBL.selectRowAtIndexPath(ip, animated: true, scrollPosition: .None)
                
            }
            
        }
        
        if let p = newPenalty {
            
            if let penalty = s.penalties.last {
                
                penalty.endX = Yardline(x: x, pos_right: pos_right)
                
                switch penalty.enforcement as Key {
                case .Declined,.Offset,.OnKick:
                    
                    penalty.endY = Int(round((y / field.bounds.height) * 100))
                    if pos_right { penalty.endY = 100 - penalty.endY! }
                    
                default:()
                }
                
                field.setNeedsDisplay()
                drawButtons()
                
                let ip = NSIndexPath(forRow: index, inSection: 0)
                sequenceTBL.reloadRowsAtIndexPaths([ip], withRowAnimation: .None)
                sequenceTBL.selectRowAtIndexPath(ip, animated: true, scrollPosition: .None)
                
            }
            
        }
        
        return true
        
    }
    // ========================================================
    // ========================================================
    
    
    // FIELD TOUCHES ENDED
    // ========================================================
    // ========================================================
    func fieldTouchesEnded(touches: Set<NSObject>) -> Bool {
        
        let s = game.sequences[index]
        
        if let play = newPlay {
            
            if let _play = s.plays.last {
                
                _play.save(nil)
                s.scoreSave(nil)
                updateScoreboard()
                
            }
            
        }
        
        if let penalty = newPenalty {
            
            if let _penalty = s.penalties.last {
                
                _penalty.save(nil)
                s.scoreSave(nil)
                updateScoreboard()
                
            }
            
        }
        
        cancelTPD(1)
        
        return true
        
    }
    // ========================================================
    // ========================================================
    
    
    // CREATE SEQUENCE
    // ========================================================
    // ========================================================
    func createSequence() -> Sequence {
        
        if let prev = game.sequences.first {
            
            return NextFilter.run(sequence: prev)
            
        } else {
            
            let sequence = Sequence(game: game)
            
            sequence.team = game.away
            sequence.startX = Yardline(spot: kickoff_yardline.int())
            sequence.key = .Kickoff
            sequence.qtr = 1
            
            return sequence
            
        }
        
    }
    // ========================================================
    // ========================================================
    
    
    // NEW SEQUENCE
    // ========================================================
    // ========================================================
    func newSequence(sender: AnyObject){
        
        if game.sequences.count > 0 {
            
            let s = game.sequences[index]
            
            if s.score != .None && s.score_time == "" {
                
                var txt: UITextField!
                
                func addTextField(_txt: UITextField!){
                    
                    _txt.placeholder = "Time of Score"
                    _txt.keyboardType = UIKeyboardType.NumberPad
                    txt = _txt
                    
                }
                
                let conf = UIAlertController(title: "Time of Score", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                
                let save = UIAlertAction(title: "Save", style: .Default) { (action) -> Void in
                    
                    s.score_time = txt.text
                    self.tosTXT.text = txt.text
                    s.save(nil)
                    
                    self.ns()
                    
                }
                
                let skip = UIAlertAction(title: "Skip", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
                    
                    self.ns()
                    
                })
                
                conf.addAction(save)
                conf.addAction(skip)
                
                conf.addTextFieldWithConfigurationHandler(addTextField)
                
                presentViewController(conf, animated: true, completion: nil)
                
            } else {
                
                self.ns()
                
            }
            
        } else {
            
            ns()
            
        }
        
    }
    func ns(){
        
        add.enabled = false
        
        let S = createSequence()
        S.save(nil)
        
        game.sequences.insert(S, atIndex: 0)
        sequenceTBL.sequences = game.sequences
        
        let ip = NSIndexPath(forRow: 0, inSection: 0)
        sequenceTBL.insertRowsAtIndexPaths([ip], withRowAnimation: .Top)
        
        selectSequence(0)
        
        MPC.sendGame(game)
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "enablePLUS:", userInfo: nil, repeats: false)
        
    }
    func enablePLUS(timer: NSTimer){
        
        add.enabled = true
        
    }
    // ========================================================
    // ========================================================
    
    
    // TOUCHES BEGAN
    // ========================================================
    // ========================================================
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        
    }
    // ========================================================
    // ========================================================
    
    
    // TOS END
    // ========================================================
    // ========================================================
    func tosEND(sender: AnyObject){
        
        let s = game.sequences[index]
        
        s.score_time = tosTXT.text
        
        s.save(nil)
        
        let ip = NSIndexPath(forRow: index, inSection: 0)
        sequenceTBL.reloadRowsAtIndexPaths([ip], withRowAnimation: .None)
        sequenceTBL.selectRowAtIndexPath(ip, animated: true, scrollPosition: .None)
        
    }
    // ========================================================
    // ========================================================
    
    func eraseTPD(sender: UIBarButtonItem){
        
        let s = game.sequences[index]
        
        if let penalty = s.penalties.last {
            
            let i = s.penalties.count - 1
            
            penalty.delete(nil)
            s.penalties.removeAtIndex(i)
            
            field.setNeedsDisplay()
            drawButtons()
            
            s.scoreSave(nil)
            updateScoreboard()
            
            let ip = NSIndexPath(forRow: index, inSection: 0)
            sequenceTBL.reloadRowsAtIndexPaths([ip], withRowAnimation: .None)
            sequenceTBL.selectRowAtIndexPath(ip, animated: true, scrollPosition: .None)
            
        } else {
            
            if let play = s.plays.last {
                
                let i = s.plays.count - 1
                
                play.delete(nil)
                s.plays.removeAtIndex(i)
                
                field.setNeedsDisplay()
                drawButtons()
                
                s.scoreSave(nil)
                updateScoreboard()
                
                let ip = NSIndexPath(forRow: index, inSection: 0)
                sequenceTBL.reloadRowsAtIndexPaths([ip], withRowAnimation: .None)
                sequenceTBL.selectRowAtIndexPath(ip, animated: true, scrollPosition: .None)
                
            }
            
        }
        
    }
    
}