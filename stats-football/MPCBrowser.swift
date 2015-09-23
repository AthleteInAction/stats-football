//
//  MPCAdvertiser.swift
//  stats-football
//
//  Created by grobinson on 9/20/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol MPCBrowserDelegate {
    
    func availablePeersChanged()
    
}

class MPCBrowser: NSObject {
    
    private let serviceType = "stats-connect"
    private var myPeerID: MCPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
    var browser: MCNearbyServiceBrowser!
    var devices = [Int:MCPeerID]()
    var session: MCSession!
    var delegate: MPCBrowserDelegate!
    
    override init(){
        
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        
        super.init()
        
        browser.delegate = self
        session.delegate = self
        
        startBrowsing()
        
    }
    
    func startBrowsing(){ browser.startBrowsingForPeers() }
    func stopBrowsing(){ browser.stopBrowsingForPeers() }
    
}

extension MPCBrowser: MCSessionDelegate {
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
        println("\(myPeerID.displayName) DID START RECEIVING RESOURCE")
        
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
        println("\(myPeerID.displayName) DID RECEIVE STREAM")
        
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        
        println("\(myPeerID.displayName) DID RECEIVE DATA")
        
    }
    
    func session(session: MCSession!, didReceiveCertificate certificate: [AnyObject]!, fromPeer peerID: MCPeerID!, certificateHandler: ((Bool) -> Void)!) {
        
        println("\(myPeerID.displayName) DID RECEIVE CERTIFICATE")
        
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
        println("\(myPeerID.displayName) DID FINISH RECEIVING RESOURCE WITH NAME: \(resourceName)")
        
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        
        println("\(myPeerID.displayName) DID CHANGE STATE \(state.stringValue())")
        
    }
    
}

extension MPCBrowser: MCNearbyServiceBrowserDelegate {
    
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        
        println("\(myPeerID.displayName) DID NOT START BROWSING FOR PEERS")
        
    }
    
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        
        println("\(myPeerID.displayName) FOUND PEER: \(peerID) : \(peerID.hash)")
        
        devices[peerID.hash] = peerID
        
        println("+++++++++")
        for device in devices {
            
            println(device)
            
        }
        println("+++++++++")
        
        delegate.availablePeersChanged()
        
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        
        println("\(myPeerID.displayName) LOST PEER: \(peerID)")
        
        if let device = devices[peerID.hash] { devices[peerID.hash] = nil }
        
        println("----------")
        for device in devices {
            
            println(device)
            
        }
        println("----------")
        
        delegate.availablePeersChanged()
        
    }
    
}