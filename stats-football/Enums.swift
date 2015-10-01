//
//  Scores.swift
//  stats-football
//
//  Created by grobinson on 9/27/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

enum Scores {
    
    case Touchdown
    case Safety
    case FieldGoal
    case ExtraPoint
    case Conversion
    case None
    
    var string: String {
        
        switch self {
        case .Touchdown:
            return "touchdown"
        case .Safety:
            return "safety"
        case .FieldGoal:
            return "fieldgoal"
        case .ExtraPoint:
            return "extrapoint"
        case .Conversion:
            return "conversion"
        default:
            return ""
        }
        
    }
    
    var value: Int {
        
        switch self {
        case .Touchdown:
            return 6
        case .Safety:
            return 2
        case .FieldGoal:
            return 3
        case .ExtraPoint:
            return 1
        case .Conversion:
            return 2
        default:
            return 0
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
    case Pass
    case Incomplete
    case Interception
    case Fumble
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
    case Penalty
    case Spot
    case Five
    case Ten
    case Fifteen
    
    var string: String {
        
        switch self {
        case .Run: return "run"
        case .Pass: return "pass"
        case .Incomplete: return "incomplete"
        case .Interception: return "interception"
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
        case .Penalty: return "penalty"
        case .Spot: return "spot"
        case .Five: return "5"
        case .Ten: return "10"
        case .Fifteen: return "15"
        default: return "E"
        }
        
    }
    
    var displayKey: String {
        
        switch self {
        case .Run: return "Run"
        case .Pass: return "Pass"
        case .Incomplete: return "Incomplete"
        case .Interception: return "Interception"
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
        case .DeadBallSpot: return "Dead Ball Spot"
        case .Declined: return "Declined"
        case .Offset: return "Offset"
        case .OnKick: return "Enforced on Kick"
        case .Penalty: return "Penalty"
        case .Spot: return "Spot"
        case .Five: return "5 Yards"
        case .Ten: return "10 Yards"
        case .Fifteen: return "15 Yards"
        default: return "E"
        }
        
    }
    
    var int: Int {
        
        switch self {
        case .Five: return 5
        case .Ten: return 10
        case .Fifteen: return 15
        default: return 30
        }
        
    }
    
}
extension String {
    
    func toKey() -> Key {
        
        switch self {
        case "run": return .Run
        case "pass": return .Pass
        case "incomplete": return .Incomplete
        case "interception": return .Interception
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
        case "penalty": return .Penalty
        case "spot": return .Spot
        default: return .Run
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