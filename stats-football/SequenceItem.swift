//
//  SequenceItem.swift
//  stats-football
//
//  Created by grobinson on 10/18/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

@IBDesignable class SequenceItem: UIView {
    
    private var sequence: Sequence!
    
    @IBOutlet weak var primary: UIView!
    @IBOutlet weak var qtrTXT: UILabel!
    @IBOutlet weak var teamTXT: UILabel!
    @IBOutlet weak var downTXT: UILabel!
    @IBOutlet weak var spotTXT: UILabel!
    @IBOutlet weak var scoreTXT: UILabel!
    @IBOutlet weak var nextVW: UIView!
    @IBOutlet weak var fromTXT: UILabel!
    @IBOutlet weak var selector: UIView!
    
    init(frame _frame: CGRect,sequence _sequence: Sequence){
        
        sequence = _sequence
        
        super.init(frame: _frame)
        
        loadViewFromNib()
        
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        loadViewFromNib()
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        loadViewFromNib()
        
    }
    
    override func drawRect(rect: CGRect) {
        
        for v in subviews {
            
            if v.tag == -1 { v.removeFromSuperview() }
            
        }
        
        primary.backgroundColor = sequence.team.primary
        
        switch sequence.qtr {
        case 1: qtrTXT.text = "1st QTR"
        case 2: qtrTXT.text = "2nd QTR"
        case 3: qtrTXT.text = "3rd QTR"
        case 4: qtrTXT.text = "4th QTR"
        default: qtrTXT.text = "OT \(sequence.qtr-4)"
        }
        
        qtrTXT.textColor = sequence.team.secondary
        teamTXT.textColor = sequence.team.secondary
        downTXT.textColor = sequence.team.secondary
        spotTXT.textColor = sequence.team.secondary
        scoreTXT.textColor = sequence.team.secondary
        fromTXT.textColor = sequence.team.secondary
        
        var btm: [String] = []
        
        if let play = sequence.plays.first {
            
            btm.append(play.key.displayShort)
            
        }
        
        if let penalty = sequence.penalties.first {
            
            btm.append("Penalty")
            
        }
        
        if sequence.score != .None {
            
            var txt = sequence.score.short
            
            if sequence.score_time != "" {
                
                txt += " "+sequence.score_time
                
            }
            
            btm.append(txt)
            
        }
        
        scoreTXT.text = " / ".join(btm)
        
//        if let play = sequence.plays.first {
//            
//            playVW.hidden = false
//            switch play.key as Key {
//            case .Pass,.Interception,.Incomplete:
//                playVW.backgroundColor = Filters.colors(.Pass, alpha: 0.6)
//            case .Run:
//                playVW.backgroundColor = Filters.colors(.Run, alpha: 0.6)
//            default: ()
//            playVW.backgroundColor = Filters.colors(play.key, alpha: 0.6)
//            }
//            
//        } else {
//            
//            playVW.hidden = true
//            
//        }
//        
//        if let penalty = sequence.penalties.first {
//            
//            penaltyVW.hidden = false
//            penaltyVW.backgroundColor = Filters.colors(.Penalty, alpha: 0.6)
//            
//        } else {
//            
//            penaltyVW.hidden = true
//            
//        }
        
        teamTXT.text = sequence.team.short
        
        let t: String!
        
        switch sequence.startX.spot {
        case 50:
            
            t = 50.string()
            
        case 1...49:
            
            t = "\(sequence.team.short) \(sequence.startX.toShort())"
            
        case 51...99:
            
            t = "\(sequence.game.oppositeTeam(team: sequence.team).short) \(sequence.startX.toShort())"
            
        default:
            
            if sequence.startX.spot < 50 {
                t = "\(sequence.team.short) ENDZONE"
            } else {
                t = "\(sequence.game.oppositeTeam(team: sequence.team).short) ENDZONE"
            }
            
        }
        
        spotTXT.text = t
        
        switch sequence.key as Playtype {
        case .Kickoff:
            
            downTXT.text = "Kickoff"
            
        case .Freekick:
            
            downTXT.text = "Freekick"
            
        case .PAT:
            
            downTXT.text = "PAT"
            
        case .Down:
            
            var fd: String!
            
            if let f = sequence.fd {
                fd = "\(f)"
            } else {
                fd = "nil"
            }
            
            var d: String!
            
            if let dd = sequence.down {
                d = "\(dd)"
            } else {
                d = "nil"
            }
            
            var togo = "\(sequence.fd!.spot - sequence.startX.spot)"
            if sequence.fd!.spot >= 100 { togo = "G" }
            
            switch d {
            case 1.string():
                d = "1st"
            case 2.string():
                d = "2nd"
            case 3.string():
                d = "3rd"
            case 4.string():
                d = "4th"
            default:
                ()
            }
            
            downTXT.text = "\(d) and \(togo)"
            
        default:
            
            downTXT.text = "Error"
            
        }
        
    }
    
    func loadViewFromNib(){
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "SequenceItem", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        view.frame = bounds
        
        self.addSubview(view)
        
    }
    
}