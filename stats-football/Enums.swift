//
//  Scores.swift
//  stats-football
//
//  Created by grobinson on 9/27/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
import Foundation

enum Scores {
    
    case Touchdown
    case Safety
    case FieldGoal
    case ExtraPoint
    case Conversion
    case None
    
    var string: String {
        
        switch self {
        case .Touchdown: return "touchdown"
        case .Safety: return "safety"
        case .FieldGoal: return "fieldgoal"
        case .ExtraPoint: return "extrapoint"
        case .Conversion: return "conversion"
        default: return ""
        }
        
    }
    
    var display: String {
        
        switch self {
        case .Touchdown: return "TOUCHDOWN"
        case .Safety: return "SAFETY"
        case .FieldGoal: return "FIELD GOAL"
        case .ExtraPoint: return "EXTRA POINT"
        case .Conversion: return "CONVERSION"
        default: return ""
        }
        
    }
    
    var value: Int {
        
        switch self {
        case .Touchdown: return 6
        case .Safety,Conversion: return 2
        case .FieldGoal: return 3
        case .ExtraPoint: return 1
        default: return 0
        }
        
    }
    
}



enum Playtype {
    
    case Kickoff
    case Freekick
    case Down
    case PAT
    
    var int: Int {
        
        switch self {
        case .Kickoff: return 0
        case .Freekick: return 1
        case .Down: return 2
        case .PAT: return 3
        default: return 0
        }
        
    }
    
    var string: String {
        
        switch self {
        case .Kickoff: return "kickoff"
        case .Freekick: return "freekick"
        case .Down: return "down"
        case .PAT: return "pat"
        default: return "e"
        }
        
    }
    
}


enum Key {
    
    case Run
    case Kneel
    case Pass
    case Throw
    case Reception
    case Incomplete
    case Interception
    case Sack
    case Fumble
    case FumbledSnap
    case BadSnap
    case Return
    case Kick
    case Punt
    case Lateral
    case FGA
    case FGM
    case Block
    case Recovery
    case PreviousSpot
    case SpotOfFoul
    case DeadBallSpot
    case Declined
    case Offset
    case OnKick
    case ReplayDown
    case AutoFirst
    case Penalty
    case Spot
    case Five
    case Ten
    case Fifteen
    
    case Home
    case Away
    case NoRecovery
    
    case Yes
    case No
    
    var string: String {
        
        switch self {
        case .Run: return "run"
        case .Kneel: return "kneel"
        case .Pass: return "pass"
        case .Throw: return "pass"
        case .Reception: return "reception"
        case .Incomplete: return "incomplete"
        case .Interception: return "interception"
        case .Sack: return "sack"
        case .FumbledSnap: return "fumbled_snap"
        case .BadSnap: return "bad_snap"
        case .Fumble: return "fumble"
        case .Return: return "return"
        case .Kick: return "kick"
        case .Punt: return "punt"
        case .Lateral: return "lateral"
        case .FGA: return "fga"
        case .FGM: return "fgm"
        case .Block: return "block"
        case .Recovery: return "recovery"
        case .PreviousSpot: return "previous_spot"
        case .SpotOfFoul: return "spot_of_foul"
        case .DeadBallSpot: return "dead_ball_spot"
        case .Declined: return "declined"
        case .Offset: return "offset"
        case .OnKick: return "onkick"
        case .ReplayDown: return "replay_down"
        case .AutoFirst: return "auto_first"
        case .Penalty: return "penalty"
        case .Spot: return "spot"
        case .Five: return "5"
        case .Ten: return "10"
        case .Fifteen: return "15"
        case .Yes: return "yes"
        case .No: return "no"
        default: return "E"
        }
        
    }
    
    var displayKey: String {
        
        switch self {
        case .Run: return "Run"
        case .Kneel: return "Kneel Down"
        case .Pass: return "Completion"
        case .Throw: return "Pass"
        case .Reception: return "Reception"
        case .Incomplete: return "Incomplete"
        case .Interception: return "Interception"
        case .Sack: return "Sack"
        case .FumbledSnap: return "Fumbled Snap"
        case .BadSnap: return "Bad Snap"
        case .Fumble: return "Fumble"
        case .Return: return "Return"
        case .Kick: return "Kick"
        case .Punt: return "Punt"
        case .Lateral: return "Lateral"
        case .FGA: return "Field Goal Missed"
        case .FGM: return "Field Goal Made"
        case .Block: return "Block"
        case .Recovery: return "Recovery"
        case .PreviousSpot: return "Previous Spot"
        case .SpotOfFoul: return "Spot of Foul"
        case .DeadBallSpot: return "After the Play"
        case .Declined: return "Declined"
        case .Offset: return "Offset"
        case .OnKick: return "Enforced on Kick"
        case .ReplayDown: return "Replay the Down"
        case .AutoFirst: return "Automatic First Down"
        case .Penalty: return "Penalty"
        case .Spot: return "Spot"
        case .Five: return "5 Yards"
        case .Ten: return "10 Yards"
        case .Fifteen: return "15 Yards"
        case .NoRecovery: return "No Recovery"
        case .Yes: return "Yes"
        case .No: return "No"
        default: return "E"
        }
        
    }
    
    var displayShort: String {
        
        switch self {
        case .Run: return "Run"
        case .Kneel: return "Kneel"
        case .Pass: return "Comp"
        case .Throw: return "Pass"
        case .Reception: return "Catch"
        case .Incomplete: return "Incomp"
        case .Interception: return "Int"
        case .Sack: return "Sack"
        case .FumbledSnap: return "Snap"
        case .BadSnap: return "Snap"
        case .Fumble: return "Fumble"
        case .Return: return "Return"
        case .Kick: return "Kick"
        case .Punt: return "Punt"
        case .Lateral: return "Lateral"
        case .FGA: return "FGMiss"
        case .FGM: return "FGMade"
        case .Block: return "Block"
        case .Recovery: return "Recov"
        case .PreviousSpot: return "Previous Spot"
        case .SpotOfFoul: return "Spot of Foul"
        case .DeadBallSpot: return "After the Play"
        case .Declined: return "Declined"
        case .Offset: return "Offset"
        case .OnKick: return "Enforced on Kick"
        case .ReplayDown: return "Replay Down"
        case .AutoFirst: return "Automatic First Down"
        case .Penalty: return "Penalty"
        case .Spot: return "Spot"
        case .Five: return "5 Yards"
        case .Ten: return "10 Yards"
        case .Fifteen: return "15 Yards"
        case .NoRecovery: return "No Recovery"
        case .Yes: return "Yes"
        case .No: return "No"
        default: return "E"
        }
        
    }
    
    var int: Int {
        
        switch self {
        case .Five: return 5
        case .Ten: return 10
        case .Fifteen: return 15
        default:
            
            fatalError("No distance value for \(self.string)")
            
        }
        
    }
    
    var bool: Bool { return self == .Yes }
    
}
extension String {
    
    func toKey() -> Key {
        
        switch self {
        case "run": return .Run
        case "kneel": return .Kneel
        case "pass": return .Pass
        case "reception": return .Reception
        case "incomplete": return .Incomplete
        case "interception": return .Interception
        case "sack": return .Sack
        case "fumbled_snap": return .FumbledSnap
        case "bad_snap": return .BadSnap
        case "fumble": return .Fumble
        case "return": return .Return
        case "kick": return .Kick
        case "punt": return .Punt
        case "lateral": return .Lateral
        case "fga": return .FGA
        case "fgm": return .FGM
        case "block": return .Block
        case "recovery": return .Recovery
        case "previous_spot": return .PreviousSpot
        case "spot_of_foul": return .SpotOfFoul
        case "dead_ball_spot": return .DeadBallSpot
        case "declined": return .Declined
        case "offset": return .Offset
        case "onkick": return .OnKick
        case "replay_down": return .ReplayDown
        case "auto_first": return .AutoFirst
        case "penalty": return .Penalty
        case "spot": return .Spot
        default: return .Run
        }
        
    }
    
    func toScore() -> Scores {
        
        switch self {
        case "touchdown": return .Touchdown
        case "safety": return .Safety
        case "fieldgoal": return .FieldGoal
        case "extrapoint": return .ExtraPoint
        case "conversion": return .Conversion
        default: return .None
        }
        
    }
    
}
extension Int {
    
    func toKey() -> Key {
        
        switch self {
        case 10: return .Ten
        case 15: return .Fifteen
        default: return .Five
        }
        
    }
    
}