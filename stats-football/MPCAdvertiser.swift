//
//  MPCAdvertiser.swift
//  stats-football
//
//  Created by grobinson on 9/20/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MPCAdvertiser: NSObject {
    
    private let serviceType = "stats-connect"
    private var myPeerID: MCPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
    private var advertiser: MCNearbyServiceAdvertiser!
    var session: MCSession!
    
    override init(){
        
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        
        super.init()
        
        advertiser.delegate = self
        session.delegate = self
        
    }
    
    func startAdvertising(){ advertiser.startAdvertisingPeer() }
    func stopAdvertising(){ advertiser.stopAdvertisingPeer() }
    
}

extension MPCAdvertiser: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        
        println("\(myPeerID) DID NOT START ADVERTISING")
        
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        
        println("\(myPeerID) DID RECEIVE INVITATION")
        
        invitationHandler(true,session)
        
    }
    
}

extension MPCAdvertiser: MCSessionDelegate {
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
        println("\(myPeerID) DID FINISH RECEIVING RESOURCE")
        
    }
    
    func session(session: MCSession!, didReceiveCertificate certificate: [AnyObject]!, fromPeer peerID: MCPeerID!, certificateHandler: ((Bool) -> Void)!) {
        
        println("\(myPeerID) DID RECEIVE CERIFICATE")
        
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        
        println("\(myPeerID) DID RECEIVE DATA")
        
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
        println("\(myPeerID) DID RECEIVE STREAM")
        
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
        println("\(myPeerID) DID START RECEIVING RESOURCE")
        
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        
        println("\(myPeerID) DID CHANGE STATE: \(state.stringValue())")
        
    }
    
}