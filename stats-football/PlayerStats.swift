//
//  PlayerStats.swift
//  stats-football
//
//  Created by grobinson on 9/23/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

func JP(item: AnyObject){
    
    println(item)
    
}
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
        var infractionPoint = 100
        var hasPenaltyWithSpot = false
        sequence.getPenalties()
        for penalty in reverse(sequence.penalties) {
            JP("DISTANCE: \(penalty.distance)")
            if let x = penalty.endX {
                
                hasPenaltyWithSpot = true
                
                JP("ENFORCEMENT: \(penalty.enforcement)")
                
                if penalty.enforcement == "spot of foul" {
                    
                    let spot = Yardline(yardline: x)
                    
                    JP("PENALTY SPOT: \(spot.spot)")
                    
                    if penalty.team.object.isEqual(sequence.team.object) {
                        infractionPoint = spot.penaltyPlus(penalty.distance)
                    } else {
                        infractionPoint = spot.penaltyMinus(penalty.distance)
                    }
                    JP("INFRACTION POINT: \(infractionPoint)")
                    break
                    
                }
                
            }
            
        }
        // ========================================================
        // ========================================================
        
            if !sequence.replay || true {
                
                let score = Filters.score(sequence)
                
                var cx = sequence.startX.yardToFull(false)
                
                // FIND LAST SPOT
                // ========================================================
                // ========================================================
                var lastPlayWithSpot: Int?
                sequence.getPlays()
                for (i,play) in enumerate(reverse(sequence.plays)) {
                    
                    if let spot = play.endX {
                        
                        if !hasPenaltyWithSpot { lastPlayWithSpot = sequence.plays.count-1-i }
                        
                        break
                        
                    }
                    
                }
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
                        
                        var endX = x.yardToFull(false)
                        if endX >= 100 { endX = 100 }
                        if endX <= 0 { endX = 0 }
                        
                        switch play.key {
                        case "pass":
                        // PASS ++++++++++++++++++++++++++++++++++++++++++
                            
                            if cx < infractionPoint {
                                
                                if endX > infractionPoint { endX = infractionPoint }
                                
                                var stat: Stat = Stat()
                                stat.playtype = sequence.key
                                stat.key = "completion"
                                stat.player = play.player_a
                                stat.value = (endX - cx)
                                if pos {
                                    stat.team = sequence.game.home
                                } else {
                                    stat.team = sequence.game.away
                                }
                                
                                if let lp = lastPlayWithSpot {
                                    if lp == i { stat.score = score[pos.toInt()] }
                                }
                                
                                stats.append(stat)
                                
//                                stat = Stat()
//                                stat.playtype = sequence.key
//                                stat.key = "reception"
//                                stat.player = play.player_b!
//                                stat.value = (endX - cx)
//                                if !pos {
//                                    stat.team = sequence.game.home
//                                } else {
//                                    stat.team = sequence.game.away
//                                }
//                                
//                                if let lp = lastPlayWithSpot {
//                                    if lp == i { stat.score = score[pos.toInt()] }
//                                }
//                                
//                                stats.append(stat)
                                
                            }
                            
                        // PASS ++++++++++++++++++++++++++++++++++++++++++
                        case "interception":
                        // INTERCEPTION ++++++++++++++++++++++++++++++++++
                            
                            if cx < infractionPoint {
                                
                                if endX > infractionPoint { endX = infractionPoint }
                                
                                var stat: Stat = Stat()
                                stat.playtype = sequence.key
                                stat.key = "int_thrown"
                                stat.player = play.player_a
                                if pos {
                                    stat.team = sequence.game.home
                                } else {
                                    stat.team = sequence.game.away
                                }
                                
                                stats.append(stat)
//                                stat = [
//                                    "playtype": sequence.key,
//                                    "player": play.player_a,
//                                    "key": "int_thrown"
//                                ]
//                                
//                                stats[team]?.append(stat)
//                                
//                                stat = [
//                                    "playtype": sequence.key,
//                                    "player": play.player_b!,
//                                    "key": play.key
//                                ]
//                                
//                                if let lp = lastPlayWithSpot {
//                                    let opp = !pos
//                                    stat["score"] = score[opp.toInt()].string
//                                }
//                                
//                                stats[teamSide(!pos)]?.append(stat)
                                
                            }
                        
                        // INTERCEPTION ++++++++++++++++++++++++++++++++++
                        case "return":
                        // RETURN ++++++++++++++++++++++++++++++++++++++++
                            
                            if cx < infractionPoint {
                                
                                if endX > infractionPoint { endX = infractionPoint }
                                
//                                if let previous = prev {
//                                    
//                                    stat = [
//                                        "playtype": sequence.key,
//                                        "player": play.player_a,
//                                        "value": ((endX - cx) * -1),
//                                        "key": previous.key+"_return"
//                                    ]
//                                    
//                                }
//                                
//                                if let lp = lastPlayWithSpot {
//                                    if lp == i { stat["score"] = score[pos.toInt()].string }
//                                }
//                                
//                                stats[team]?.append(stat)
                                
                            }
                        
                        // RETURN ++++++++++++++++++++++++++++++++++++++++
                        case "fumble":
                        // FUBMLE ++++++++++++++++++++++++++++++++++++++++
                            
                            if cx < infractionPoint {
                                
                                if endX > infractionPoint { endX = infractionPoint }
                                
//                                stat = [
//                                    "playtype": sequence.key,
//                                    "player": play.player_a,
//                                    "key": play.key,
//                                    "value": (endX - cx)
//                                ]
//                                
//                                if let lp = lastPlayWithSpot {
//                                    if lp == i { stat["score"] = score[pos.toInt()].string }
//                                }
//                                
//                                stats[team]?.append(stat)
//                                
//                                if let b = play.player_b {
//                                    
//                                    stat = [
//                                        "playtype": sequence.key,
//                                        "player": b,
//                                        "key": play.key+"_recovery",
//                                        "value": (endX - cx)
//                                    ]
//                                    
//                                    let tmp_pos = sequence.game.home.object.isEqual(play.team!.object)
//                                    
//                                    if let lp = lastPlayWithSpot {
//                                        if lp == i { stat["score"] = score[tmp_pos.toInt()].string }
//                                    }
//                                    
//                                    stats[teamSide(tmp_pos)]?.append(stat)
//                                    
//                                }
                                
                            }
                            
                        // FUBMLE ++++++++++++++++++++++++++++++++++++++++
                        case "field goal made":
                        // FIELD GOAL MADE +++++++++++++++++++++++++++++++
                            
                            if cx < infractionPoint {
                                
                                if endX > infractionPoint { endX = infractionPoint }
                                
//                                stat = [
//                                    "playtype": sequence.key,
//                                    "player": play.player_a,
//                                    "key": play.key,
//                                    "value": (100 - endX)
//                                ]
//                                
//                                if let lp = lastPlayWithSpot {
//                                    if lp == i { stat["score"] = score[pos.toInt()].string }
//                                }
//                                
//                                stats[team]?.append(stat)
                                
                            }
                            
                        // FIELD GOAL MADE +++++++++++++++++++++++++++++++
                        case "field goal attempted":
                        // FIELD GOAL ATTEMPTED ++++++++++++++++++++++++++
                            
                            if cx < infractionPoint {
                                
                                if endX > infractionPoint { endX = infractionPoint }
                                
//                                stat = [
//                                    "playtype": sequence.key,
//                                    "player": play.player_a,
//                                    "key": play.key,
//                                    "value": (100 - endX)
//                                ]
//                                
//                                stats[team]?.append(stat)
                                
                            }
                            
                        // FIELD GOAL ATTEMPTED ++++++++++++++++++++++++++
                        case "punt","kick":
                            
                            ()
                        // KICKS +++++++++++++++++++++++++++++++++++++++++
                            
//                            stat = [
//                                "playtype": sequence.key,
//                                "player": play.player_a,
//                                "key": play.key,
//                                "value": (endX - cx)
//                            ]
//                            
//                            stats[team]?.append(stat)
                            
                        // KICKS +++++++++++++++++++++++++++++++++++++++++
                        default:
                        // DEFAULT +++++++++++++++++++++++++++++++++++++++
                            
                            if cx < infractionPoint {
                                
                                if endX > infractionPoint { endX = infractionPoint }
                                
//                                stat = [
//                                    "playtype": sequence.key,
//                                    "player": play.player_a,
//                                    "key": play.key,
//                                    "value": (endX - cx)
//                                ]
//                                
//                                stats[team]?.append(stat)
                                
                            }
                        
                        // DEFAULT ++++++++++++++++++++++++++++++++++++++
                        }
                        
                        cx = endX
                        
                    } else {
                        
                        switch play.key {
                        case "incomplete":
                            
                            var stat: Stat = Stat()
                            stat.playtype = sequence.key
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
                    switch play.key {
                    case "punt","kick":
                        
                        pos = !pos
                        
                    case "fumble":
                        
                        //                        if let team = play.team { pos = team.object.isEqual(sequence.team.object) }
                        ()
                        
                    case "interception","recovery":
                        
                        pos = !pos
                        
                    default:
                        
                        ()
                        
                    }
                    // ++++++++++++++++++++++++++++++++
                    
                    prev = play
                    
                }
                // ========================================================
                // ========================================================
                
            }
        
//        println("-+-+-+-+-+-+STATS-STATS-STATS-STATS-STATS-STATS-+-+-+-+-+-+")
//        println(stats)
//        println("-+-+-+-+-+-+STATS-STATS-STATS-STATS-STATS-STATS-+-+-+-+-+-+")
        
        return stats
    
    }
    
}