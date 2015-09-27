//
//  ColorServiceManager.swift
//  ConnectedColors
//
//  Created by Ralf Ebert on 28/04/15.
//  Copyright (c) 2015 Ralf Ebert. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import CoreData
import SwiftyJSON

protocol MPCManagerReceiver {
    
    func receiveGame(game: [String:AnyObject])
    
}

protocol MPCManagerStateChanged {
    
    func stateChanged(state: MCSessionState)
    func peersChanged()
    
}

class MPCManager : NSObject {
    
    private let serviceType = "hjk546jk6375k7"
    private let myPeerId = MCPeerID(displayName: UIDevice.currentDevice().name)
    let serviceAdvertiser : MCNearbyServiceAdvertiser
    let serviceBrowser : MCNearbyServiceBrowser
    var devices: [MCPeerID] = []
    var receiver : MPCManagerReceiver?
    var stateMonitor: MPCManagerStateChanged?
    
    override init() {
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceBrowser.delegate = self
        
    }
    
    func startAdvertising(){ serviceAdvertiser.startAdvertisingPeer() }
    func startBrowsing(){ serviceBrowser.startBrowsingForPeers() }
    func stopAdvertising() { serviceAdvertiser.stopAdvertisingPeer() }
    func stopBrowsing(){ serviceBrowser.stopBrowsingForPeers() }
    
    deinit {
        
        println("DEINIT")
        stopAdvertising()
        stopBrowsing()
        
    }
    
    lazy var session: MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        session?.delegate = self
        return session
        }()
    
    func sendGame(game: Game){
        
        var homePlays: [[String:AnyObject]] = []
        var awayPlays: [[String:AnyObject]] = []
        var homeCurrent: [String:AnyObject]?
        var awayCurrent: [String:AnyObject]?
        
        var d: [[String:AnyObject]] = []
        
        var sequences = game.object.sequences.allObjects as! [SequenceObject]
        
        sequences.sort({ $0.created_at.compare($1.created_at) == NSComparisonResult.OrderedDescending })
        
        for sequence in sequences {
            
            if sequence.key == "down" || sequence.key == "pat" || true {
                
                if sequence.team.isEqual(game.home.object) {
                    
                    homeCurrent = [
                        "playtype": sequence.key,
                        "qtr": sequence.qtr.toInt()!,
                        "key": sequence.key
                    ]
                    
                    if let d = sequence.down { homeCurrent!["down"] = d.toInt()! }
                    if let d = sequence.fd {
                        
                        homeCurrent!["fd"] = d.toInt()!
                        
                        var los = sequence.startX.toInt()!
                        var fd2 = d.toInt()!
                        
                        if los < 0 {
                            los = los * -1
                        } else {
                            los = 100 - los
                        }
                        if fd2 < 0 {
                            fd2 = fd2 * -1
                        } else {
                            fd2 = 100 - fd2
                        }
                        
                        homeCurrent!["togo"] = fd2 - los
                        
                    }
                    
                } else if sequence.team.isEqual(game.away.object) {
                    
                    awayCurrent = [
                        "playtype": sequence.key,
                        "qtr": sequence.qtr.toInt()!,
                        "key": sequence.key
                    ]
                    
                    if let d = sequence.down { awayCurrent!["down"] = d.toInt()! }
                    if let d = sequence.fd {
                        
                        awayCurrent!["fd"] = d.toInt()!
                        
                        var los = sequence.startX.toInt()!
                        var fd2 = d.toInt()!
                        
                        if los < 0 {
                            los = los * -1
                        } else {
                            los = 100 - los
                        }
                        if fd2 < 0 {
                            fd2 = fd2 * -1
                        } else {
                            fd2 = 100 - fd2
                        }
                        
                        awayCurrent!["togo"] = fd2 - los
                        
                    }
                    
                }
                
                var plays = sequence.plays.allObjects as! [PlayObject]
                
                plays.sort({ $0.created_at.compare($1.created_at) == NSComparisonResult.OrderedAscending })
                
                for (i,play) in enumerate(plays) {
                    
                    let p = Play(play: play)
                    let final = p.serialize()
                    
                    if sequence.team.isEqual(game.home.object) {
                        
                        homePlays.append(final)
                        
                    } else if sequence.team.isEqual(game.away.object) {
                        
                        awayPlays.append(final)
                        
                    }
                    
                    break
                    
                }
                
            }
            
        }
        
        var home: [String:AnyObject] = [
            "name": game.home.name,
            "short": game.home.short,
            "plays": homePlays
        ]
        if let c = homeCurrent { home["current"] = c }
        
        var away: [String:AnyObject] = [
            "name": game.away.name,
            "short": game.away.short,
            "plays": awayPlays
        ]
        if let c = awayCurrent { away["current"] = c }
        
        var f: [String:AnyObject] = [
            "home": home,
            "away": away
        ]
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(f)
        
        if session.connectedPeers.count > 0 {
            
            var error: NSError?
            if !session.sendData(data,toPeers: session.connectedPeers, withMode: .Reliable, error: &error){
                
                println("SEND ERROR:")
                println(error)
                
            }
            
        } else {
            
            println("NO PEERS CONNECTED!")
            
        }
        
    }
    
}

extension MPCManager : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
    
}

extension MPCManager : MCNearbyServiceBrowserDelegate {
    
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        
        var found = false
        for device in devices {
            
            if device == peerID { found = true }
            
        }
        
        if !found {
            devices.append(peerID)
            stateMonitor?.peersChanged()
        }
        
        if lastPeer?.displayName == peerID.displayName {
            
            browser.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: 10)
            
        }
        
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        
        for (i,device) in enumerate(devices) {
            
            if device == peerID {
                
                devices.removeAtIndex(i)
                stateMonitor?.peersChanged()
                break
            
            }
            
        }
        
    }
    
}

extension MCSessionState {
    
    func stringValue() -> String {
        
        switch(self) {
        case .NotConnected: return "Not Connected"
        case .Connecting: return "Connecting"
        case .Connected: return "Connected"
        default: return "Unknown"
        }
        
    }
    
}

extension MPCManager : MCSessionDelegate {
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        
        stateMonitor?.stateChanged(state)
        
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        
        println("DID RECEIVE DATA: \(data.length) bytes")
        
        lastPeer = peerID
        
        let game = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [String:AnyObject]
        
        receiver?.receiveGame(game)
        
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
        NSLog("%@", "didReceiveStream")
        
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
        NSLog("%@", "didFinishReceivingResourceWithName")
        
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
        NSLog("%@", "didStartReceivingResourceWithName")
        
    }
    
}