//
//  PlayerStats.swift
//  stats-football
//
//  Created by grobinson on 9/23/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//
extension Bool {
    
    func toInt() -> Int {
        
        if self {
            return 1
        } else {
            return 0
        }
        
    }
    
}
extension Stats {
    
    private static func teamSide(t: Bool) -> String {
        
        if t {
            return "home"
        } else {
            return "away"
        }
        
    }
    
    static func player(sequence _sequence: Sequence) -> [Stat] {
        
        var stats: [Stat] = []
        
        let sequence = _sequence
        
        // LOOP THROUGH PENALTIES
        // ========================================================
        // ========================================================
        var infractionPoint = Yardline(spot: 100)
        var hasPenaltyWithSpot = false
        var enforcedFromPreviousSpot = false
        for penalty in reverse(sequence.penalties) {
            JP("DISTANCE: \(penalty.distance)")
            if let x = penalty.endX {
                
                hasPenaltyWithSpot = true
                
                JP("ENFORCEMENT: \(penalty.enforcement.displayKey)")
                
                if penalty.enforcement != Key.DeadBallSpot {
                    
                    JP("PENALTY SPOT: \(x.spot)")
                    
                    if penalty.team.object.isEqual(sequence.team.object) {
                        
                        if x.spot < (penalty.distance * 2) {
                            
                            infractionPoint = Yardline(spot: x.spot * 2)
                            
                        } else {
                            
                            infractionPoint = x.increment(penalty.distance)
                            
                        }
                        
                    } else {
                        
                        if x.spot > (100 - (penalty.distance * 2)) {
                            
                            infractionPoint = Yardline(spot: x.spot - (100 - x.spot))
                            
                        } else {
                            
                            infractionPoint = x.increment(penalty.distance * -1)
                            
                        }
                        
                    }
                    
                    JP("INFRACTION POINT: \(infractionPoint.spot)")
                    
                    if penalty.enforcement == Key.PreviousSpot {
                        
                        enforcedFromPreviousSpot = true
                        
                        infractionPoint = Yardline(spot: sequence.startX.spot)
                        
                    }
                    
                    break
                    
                }
                
            }
            
        }
        // ========================================================
        // ========================================================
        
            if !sequence.replay || true {
                
                let score = Filters.score(sequence)
                
                var cx = sequence.startX
                
                // FIND LAST SPOT
                // ========================================================
                // ========================================================
                var lastPlayWithSpot: Int?
                for (i,play) in enumerate(reverse(sequence.plays)) {
                    
                    if let spot = play.endX {
                        
                        if !hasPenaltyWithSpot { lastPlayWithSpot = sequence.plays.count-1-i }
                        
                        break
                        
                    }
                    
                }
                // ========================================================
                // ========================================================
                
                
                // PRE PLAYS
                // ========================================================
                // ========================================================
                var noRushes = false
                var rushAttempt: Int = 0
                var endedBehindLine = false
                var rushPlay = true
                var passPlay = false
                var endOfPassPlay: Int?
                var fumbleI: Int?
                var prePrev: Play?
                var vx = Yardline(spot: sequence.startX.spot)
                for (i,play) in enumerate(sequence.plays) {
                    
                    switch play.key as Key {
                    case .Pass:
                        
                        passPlay = true
                        
                    case .Pass,.Punt,.FGA,.FGM,.Incomplete,.Interception:
                        
                        rushPlay = false
                        if vx.spot <= sequence.startX.spot { noRushes = true }
                        
                    case .Run:
                        
                        if let fi = fumbleI {
                            if i >= fi { break }
                        }
                        
                        if vx.spot <= sequence.startX.spot || play.endX?.spot <= sequence.startX.spot { rushAttempt = i }
                        
                    case .Lateral:
                        
                        if passPlay { endOfPassPlay = i }
                        
                        if rushPlay {
                            
                            if let fi = fumbleI {
                                if i >= fi { break }
                            }
                            
                            if vx.spot <= sequence.startX.spot || play.endX?.spot <= sequence.startX.spot { rushAttempt = i }
                            
                        }
                        
                    case .Fumble:
                        
                        if passPlay { endOfPassPlay = i }
                        
                        if let f = fumbleI {} else { fumbleI = i }
                        
                        if let p = prePrev {
                            
                            if vx.spot <= sequence.startX.spot { endedBehindLine = true }
                            
                        }
                        
                    default: ()
                    }
                    
                    if let x = play.endX { vx = x }
                    prePrev = play
                    
                }
                if vx.spot <= sequence.startX.spot {
                    if let f = fumbleI {  } else { endedBehindLine = true }
                }
                JP("RUSH ATTEMPT: \(rushAttempt) : RUSH-PLAY: \(rushPlay) : BEHIND LINE: \(endedBehindLine) : NORUSHES: \(noRushes) : FUMBLE-I: \(fumbleI)")
                // ========================================================
                // ========================================================
                
                
                // LOOP THROUGH PLAYS
                // ========================================================
                // ========================================================
                var pos = sequence.game.home.object.isEqual(sequence.team.object)
                var prev: Play?
                for (i,play) in enumerate(sequence.plays) {
                    
                    let team = teamSide(pos)
                    
                    // SPOTS -----------------------------
                    // SPOTS -----------------------------
                    if let x = play.endX {
                        
                        var endX = x
                        if endX.spot >= 100 { endX.spot = 100 }
                        if endX.spot <= 0 { endX.spot = 0 }
                        
                        switch play.key as Key {
                        case .Pass:
                        // PASS +++++++++++++++++++++++++++++++++++++++++
                            
                            if cx.spot < infractionPoint.spot {
                                
                                if endX.spot > infractionPoint.spot { endX = infractionPoint }
                                
                                var stat: Stat = Stat()
                                stat.attempt = true
                                stat.playtype = sequence.key.string
                                stat.key = "completion"
                                stat.player = play.player_a
                                stat.value = (endX.spot - cx.spot)
                                if pos {
                                    stat.team = sequence.game.home
                                } else {
                                    stat.team = sequence.game.away
                                }
                                
                                if let lp = lastPlayWithSpot {
                                    if lp == i { stat.score = score[pos.toInt()] }
                                }
                                
                                stats.append(stat)
                                
                                stat = Stat()
                                stat.attempt = true
                                stat.playtype = sequence.key.string
                                stat.key = "reception"
                                stat.player = play.player_b!
                                stat.value = (endX.spot - cx.spot)
                                if pos {
                                    stat.team = sequence.game.home
                                } else {
                                    stat.team = sequence.game.away
                                }
                                
                                if let lp = lastPlayWithSpot {
                                    if lp == i { stat.score = score[pos.toInt()] }
                                }
                                
                                stats.append(stat)
                                
                            }
                            
                        // PASS ++++++++++++++++++++++++++++++++++++++++++
                        case .Interception:
                        // INTERCEPTION ++++++++++++++++++++++++++++++++++
                            
                            if enforcedFromPreviousSpot || sequence.replay { break }
                            
                            var stat: Stat = Stat()
                            stat.playtype = sequence.key.string
                            stat.key = "int_thrown"
                            stat.player = play.player_a
                            if pos {
                                stat.team = sequence.game.home
                            } else {
                                stat.team = sequence.game.away
                            }
                            
                            stats.append(stat)
                            
                        // INTERCEPTION ++++++++++++++++++++++++++++++++++
                        case .Incomplete:
                        // INCOMPLETE ++++++++++++++++++++++++++++++++++++
                            
                            if enforcedFromPreviousSpot || sequence.replay { break }
                            
                            var stat: Stat = Stat()
                            stat.playtype = sequence.key.string
                            stat.key = "incompletion"
                            stat.player = play.player_a
                            if pos {
                                stat.team = sequence.game.home
                            } else {
                                stat.team = sequence.game.away
                            }
                            
                            stats.append(stat)
                            
                        // INCOMPLETE ++++++++++++++++++++++++++++++++++++
                        case .Return:
                        // RETURNS +++++++++++++++++++++++++++++++++++++++
                            
                            if let p = prev {
                                
                                JP2("A == CX: \(cx.spot) : END-X: \(endX.spot) : INFRACTION POINT: \(infractionPoint.spot)")
                                JP2("B == CX: \(cx.opposite().spot) : END-X: \(endX.opposite().spot) : INFRACTION POINT: \(infractionPoint.opposite().spot)")
                                
                                if cx.opposite().spot < infractionPoint.opposite().spot {
                                    
                                    if endX.opposite().spot > infractionPoint.opposite().spot { endX = infractionPoint.opposite() }
                                    
                                    if p.key == .Punt {
                                        
                                        var stat = Stat()
                                        stat.attempt = true
                                        stat.playtype = sequence.key.string
                                        stat.key = "punt_return"
                                        stat.player = play.player_a
                                        stat.value = (endX.spot - cx.opposite().spot)
                                        
                                        if pos {
                                            stat.team = sequence.game.home
                                        } else {
                                            stat.team = sequence.game.away
                                        }
                                        
                                        if let lp = lastPlayWithSpot {
                                            if lp == i { stat.score = score[pos.toInt()] }
                                        }
                                        
                                        stats.append(stat)
                                        
                                    }
                                    
                                    if p.key == .Kick {
                                        
                                        var stat = Stat()
                                        stat.attempt = true
                                        stat.playtype = sequence.key.string
                                        stat.key = "kick_return"
                                        stat.player = play.player_a
                                        stat.value = (endX.spot - cx.opposite().spot)
                                        
                                        if pos {
                                            stat.team = sequence.game.home
                                        } else {
                                            stat.team = sequence.game.away
                                        }
                                        
                                        if let lp = lastPlayWithSpot {
                                            if lp == i { stat.score = score[pos.toInt()] }
                                        }
                                        
                                        stats.append(stat)
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        // RETURNS +++++++++++++++++++++++++++++++++++++++
//                        case "interception":
//                        // INTERCEPTION ++++++++++++++++++++++++++++++++++
//                            
//                            if cx < infractionPoint {
//                                
//                                if endX > infractionPoint { endX = infractionPoint }
//                                
//                                var stat: Stat = Stat()
//                                stat.playtype = sequence.key
//                                stat.key = "int_thrown"
//                                stat.player = play.player_a
//                                if pos {
//                                    stat.team = sequence.game.home
//                                } else {
//                                    stat.team = sequence.game.away
//                                }
//                                
//                                stats.append(stat)
////                                stat = [
////                                    "playtype": sequence.key,
////                                    "player": play.player_a,
////                                    "key": "int_thrown"
////                                ]
////                                
////                                stats[team]?.append(stat)
////                                
////                                stat = [
////                                    "playtype": sequence.key,
////                                    "player": play.player_b!,
////                                    "key": play.key
////                                ]
////                                
////                                if let lp = lastPlayWithSpot {
////                                    let opp = !pos
////                                    stat["score"] = score[opp.toInt()].string
////                                }
////                                
////                                stats[teamSide(!pos)]?.append(stat)
//                                
//                            }
//                        
//                        // INTERCEPTION ++++++++++++++++++++++++++++++++++
//                        case "return":
//                        // RETURN ++++++++++++++++++++++++++++++++++++++++
//                            
//                            if cx < infractionPoint {
//                                
//                                if endX > infractionPoint { endX = infractionPoint }
//                                
////                                if let previous = prev {
////                                    
////                                    stat = [
////                                        "playtype": sequence.key,
////                                        "player": play.player_a,
////                                        "value": ((endX - cx) * -1),
////                                        "key": previous.key+"_return"
////                                    ]
////                                    
////                                }
////                                
////                                if let lp = lastPlayWithSpot {
////                                    if lp == i { stat["score"] = score[pos.toInt()].string }
////                                }
////                                
////                                stats[team]?.append(stat)
//                                
//                            }
//                        
//                        // RETURN ++++++++++++++++++++++++++++++++++++++++
//                        case "fumble":
//                        // FUBMLE ++++++++++++++++++++++++++++++++++++++++
//                            
//                            if cx < infractionPoint {
//                                
//                                if endX > infractionPoint { endX = infractionPoint }
//                                
////                                stat = [
////                                    "playtype": sequence.key,
////                                    "player": play.player_a,
////                                    "key": play.key,
////                                    "value": (endX - cx)
////                                ]
////                                
////                                if let lp = lastPlayWithSpot {
////                                    if lp == i { stat["score"] = score[pos.toInt()].string }
////                                }
////                                
////                                stats[team]?.append(stat)
////                                
////                                if let b = play.player_b {
////                                    
////                                    stat = [
////                                        "playtype": sequence.key,
////                                        "player": b,
////                                        "key": play.key+"_recovery",
////                                        "value": (endX - cx)
////                                    ]
////                                    
////                                    let tmp_pos = sequence.game.home.object.isEqual(play.team!.object)
////                                    
////                                    if let lp = lastPlayWithSpot {
////                                        if lp == i { stat["score"] = score[tmp_pos.toInt()].string }
////                                    }
////                                    
////                                    stats[teamSide(tmp_pos)]?.append(stat)
////                                    
////                                }
//                                
//                            }
//                            
//                        // FUBMLE ++++++++++++++++++++++++++++++++++++++++
//                        case "field goal made":
//                        // FIELD GOAL MADE +++++++++++++++++++++++++++++++
//                            
//                            if cx < infractionPoint {
//                                
//                                if endX > infractionPoint { endX = infractionPoint }
//                                
////                                stat = [
////                                    "playtype": sequence.key,
////                                    "player": play.player_a,
////                                    "key": play.key,
////                                    "value": (100 - endX)
////                                ]
////                                
////                                if let lp = lastPlayWithSpot {
////                                    if lp == i { stat["score"] = score[pos.toInt()].string }
////                                }
////                                
////                                stats[team]?.append(stat)
//                                
//                            }
//                            
//                        // FIELD GOAL MADE +++++++++++++++++++++++++++++++
//                        case "field goal attempted":
//                        // FIELD GOAL ATTEMPTED ++++++++++++++++++++++++++
//                            
//                            if cx < infractionPoint {
//                                
//                                if endX > infractionPoint { endX = infractionPoint }
//                                
////                                stat = [
////                                    "playtype": sequence.key,
////                                    "player": play.player_a,
////                                    "key": play.key,
////                                    "value": (100 - endX)
////                                ]
////                                
////                                stats[team]?.append(stat)
//                                
//                            }
//                            
//                        // FIELD GOAL ATTEMPTED ++++++++++++++++++++++++++
//                        case "punt","kick":
//                            
//                            ()
//                        // KICKS +++++++++++++++++++++++++++++++++++++++++
//                            
////                            stat = [
////                                "playtype": sequence.key,
////                                "player": play.player_a,
////                                "key": play.key,
////                                "value": (endX - cx)
////                            ]
////                            
////                            stats[team]?.append(stat)
//                            
//                        // KICKS +++++++++++++++++++++++++++++++++++++++++
                        case .Run:
                        // RUN +++++++++++++++++++++++++++++++++++++++
                            
                            if let f = fumbleI {
                                if i >= f { break }
                            }
                            
                            if passPlay {
                                
                                
                                
                            } else {
                                
                                if noRushes { break }
                                
                                if cx.spot < infractionPoint.spot {
                                    
                                    if endX.spot > infractionPoint.spot { endX = infractionPoint }
                                    
                                    if endedBehindLine {
                                        
                                        if rushAttempt == i {
                                            
                                            var stat: Stat = Stat()
                                            stat.attempt = true
                                            stat.value = (endX.spot - sequence.startX.spot)
                                            if sequence.plays.count > i+1 {
                                                
                                                let next = sequence.plays[i+1]
                                                if next.key == .Lateral {
                                                    
                                                    stat.value = (next.endX!.spot - sequence.startX.spot)
                                                    
                                                }
                                                
                                            }
                                            stat.playtype = sequence.key.string
                                            stat.key = play.key.string
                                            stat.player = play.player_a
                                            
                                            if pos {
                                                stat.team = sequence.game.home
                                            } else {
                                                stat.team = sequence.game.away
                                            }
                                            
                                            if let lp = lastPlayWithSpot {
                                                if lp == i { stat.score = score[pos.toInt()] }
                                            }
                                            
                                            stats.append(stat)
                                            
                                        }
                                        
                                    } else {
                                        
                                        if i < rushAttempt { break }
                                        
                                        var stat: Stat = Stat()
                                        stat.attempt = rushAttempt == i
                                        JP("\(play.player_a) : CX: \(cx.spot) : [\(i)]")
                                        if cx.spot <= sequence.startX.spot {
                                            
                                            stat.value = (endX.spot - sequence.startX.spot)
                                            
                                            if sequence.plays.count > i+1 {
                                                
                                                let next = sequence.plays[i+1]
                                                if next.key == .Lateral {
                                                    
                                                    stat.value = (next.endX!.spot - sequence.startX.spot)
                                                    
                                                }
                                                
                                            }
                                            
                                        } else {
                                            
                                            stat.value = (endX.spot - cx.spot)
                                            
                                            if sequence.plays.count > i+1 {
                                                
                                                let next = sequence.plays[i+1]
                                                if next.key == .Lateral {
                                                    
                                                    stat.value = (next.endX!.spot - cx.spot)
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        stat.playtype = sequence.key.string
                                        stat.key = play.key.string
                                        stat.player = play.player_a
                                        
                                        if pos {
                                            stat.team = sequence.game.home
                                        } else {
                                            stat.team = sequence.game.away
                                        }
                                        
                                        if let lp = lastPlayWithSpot {
                                            if lp == i { stat.score = score[pos.toInt()] }
                                        }
                                        
                                        stats.append(stat)
                                        
                                    }
                                    
                                }
                                
                            }
                        
                        // RUN +++++++++++++++++++++++++++++++++++++++++++
                        case .Lateral:
                        // LATERAL +++++++++++++++++++++++++++++++++++++++
                            
                            if rushPlay {
                                
                                if let f = fumbleI {
                                    if i >= f { break }
                                }
                                if noRushes { break }
                                
                                if cx.spot < infractionPoint.spot {
                                    
                                    if endX.spot > infractionPoint.spot { endX = infractionPoint }
                                    
                                    if endedBehindLine {
                                        
                                        if rushAttempt == i {
                                            
                                            var stat: Stat = Stat()
                                            stat.attempt = true
                                            stat.value = (endX.spot - sequence.startX.spot)
                                            if sequence.plays.count > i+1 {
                                                
                                                let next = sequence.plays[i+1]
                                                if next.key == .Lateral {
                                                    
                                                    stat.value = (next.endX!.spot - sequence.startX.spot)
                                                    
                                                }
                                                
                                            }
                                            stat.playtype = sequence.key.string
                                            stat.key = Key.Run.string
                                            stat.player = play.player_a
                                            
                                            if pos {
                                                stat.team = sequence.game.home
                                            } else {
                                                stat.team = sequence.game.away
                                            }
                                            
                                            if let lp = lastPlayWithSpot {
                                                if lp == i { stat.score = score[pos.toInt()] }
                                            }
                                            
                                            stats.append(stat)
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        // LATERAL +++++++++++++++++++++++++++++++++++++++
                        default:
                        // DEFAULT +++++++++++++++++++++++++++++++++++++++
                            
                            ()
                        
                        // DEFAULT ++++++++++++++++++++++++++++++++++++++
                        }
                        
                        cx = endX
                        
                    } else {
                        
                        switch play.key as Key {
                        case .Incomplete:
                            
                            var stat: Stat = Stat()
                            stat.playtype = sequence.key.string
                            stat.key = "incompletion"
                            stat.player = play.player_a
                            if pos {
                                stat.team = sequence.game.home
                            } else {
                                stat.team = sequence.game.away
                            }
                            
                            stats.append(stat)
                            
                        default:
                            ()
                        }
                        
                    }
                    // SPOTS -----------------------------
                    // SPOTS -----------------------------
                    
                    // CHECK FOR CHANGE IN POSSESSION
                    // ++++++++++++++++++++++++++++++++
                    switch play.key as Key {
                    case .Punt,.Kick,.Interception,.Recovery:
                        
                        pos = !pos
                        
                    case .Fumble:
                        
                        //                        if let team = play.team { pos = team.object.isEqual(sequence.team.object) }
                        ()
                        
                    default:
                        
                        ()
                        
                    }
                    // ++++++++++++++++++++++++++++++++
                    
                    prev = play
                    
                }
                // ========================================================
                // ========================================================
                
            }
        
        return stats
    
    }
    
}