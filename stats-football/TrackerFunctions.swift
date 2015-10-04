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
            
        },completion: { () -> Void in
            
            if self.game.sequences.count == 0 { self.newSequence(1) }
            
            self.selectSequence(0)
            
            self.MPC.startAdvertising()
            
            Loading.stop()
            
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
        
        // Set Replay
        // ++++++++++++++++++++++++++++++++++++++
        replaySWI.setOn(s.replay, animated: true)
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
        if rightHome {
            
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
            
        }
        // ++++++++++++++++++++++++++++++++++++++
        
        rightBALL.hidden = !pos_right
        leftBALL.hidden = pos_right
        
        updateDown()
        updateScore()
        
    }
    // ========================================================
    // ========================================================
    
    
    // UPDATE SCORE
    func updateScore(){
//        
//        let s = game.sequences[index]
//        
//        game.getScore()
//        
//        if rightHome {
//            
//            leftSCORE.text = game.away.score.string()
//            rightSCORE.text = game.home.score.string()
//            
//        } else {
//            
//            leftSCORE.text = game.home.score.string()
//            rightSCORE.text = game.away.score.string()
//            
//        }
//        
//        MPC.sendGame(game)
        
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
        
        let s = game.sequences[index]
        
        playTBL.reload()
        penaltyTBL.reload()
        
        updateScoreboard()
        
        field.setNeedsDisplay()
        drawButtons()
        
        setSeeks()
        
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
        popover.popoverContentSize = CGSize(width: 220, height: view.bounds.height * 0.6)
        popover.presentPopoverFromRect(field.frame, inView: field, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
        
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
            
            playTBL.plays.append(n)
            
            let ip = NSIndexPath(forRow: playTBL.plays.count-1, inSection: 0)
            
            playTBL.insertRowsAtIndexPaths([ip], withRowAnimation: UITableViewRowAnimation.Top)
            
            field.setNeedsDisplay()
            drawButtons()
            
            cancelTPD(1)
            
            updateScore()
            
        }
        
        if let penalty = newPenalty {
            
            penalty.endX = x
            
            penalty.save(nil)
            
            s.penalties.append(penalty)
            penaltyTBL.penalties.append(penalty)
            
            let ip = NSIndexPath(forRow: penaltyTBL.penalties.count-1, inSection: 0)
            
            penaltyTBL.insertRowsAtIndexPaths([ip], withRowAnimation: UITableViewRowAnimation.Top)
            
            field.setNeedsDisplay()
            drawButtons()
            
            cancelTPD(1)
            
            updateScore()
            
        }
        
        return true
        
    }
    // ========================================================
    // ========================================================
    
    
    // FIELD TOUCHES MOVED
    // ========================================================
    // ========================================================
    func fieldTOuchesMoved(touches: Set<NSObject>) -> Bool {
        
        if newPlay == nil && newPenalty == nil { return false }
        
        let s = game.sequences[index]
        
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
        
        if s.plays.count == 0 {
            
            if let p = newPlay {
                
                var pct: CGFloat {
                    
                    return y / field.bounds.height
                    
                }
                
                switch p.key as Key {
                case .Run:
                    
                    let r = settings.runSections
                    let ss = settings.sectionSize(pct: pct, height: field.bounds.height, sections: r)
                    
                    let _frame = CGRect(x: 0, y: ss[0], width: field.bounds.width, height: ss[1])
                    field.highlight.backgroundColor = Filters.colors(.Run, alpha: 1)
                    field.highlight.frame = _frame
                    field.highlight.hidden = false
                
                case .Pass,.Incomplete:
                    
                    let r = settings.passSections
                    let ss = settings.sectionSize(pct: pct, height: field.bounds.height, sections: r)
                    
                    let _frame = CGRect(x: 0, y: ss[0], width: field.bounds.width, height: ss[1])
                    field.highlight.backgroundColor = Filters.colors(.Pass, alpha: 1)
                    field.highlight.frame = _frame
                    field.highlight.hidden = false
                    
                default: ()
                }
                
            }
            
        }
        
        return true
        
    }
    // ========================================================
    // ========================================================
    
    
    // FIELD TOUCHES ENDED
    // ========================================================
    // ========================================================
    func fieldTOuchesEnded(touches: Set<NSObject>) -> Bool {
        
        if newPlay != nil || newPenalty != nil { enterOn = true }
        
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
            sequence.startX = Yardline(spot: 40)
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
        
        let S = createSequence()
        
        S.save(nil)
        
        game.sequences.insert(S, atIndex: 0)
        sequenceTBL.sequences = game.sequences
        
        let ip = NSIndexPath(forRow: 0, inSection: 0)
        sequenceTBL.insertRowsAtIndexPaths([ip], withRowAnimation: .Top)
        
        selectSequence(0)
        
        MPC.sendGame(game)
        
    }
    // ========================================================
    // ========================================================
    
}