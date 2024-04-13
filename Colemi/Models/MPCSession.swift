//
//  MPC.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/13/24.
//

import Foundation
import MultipeerConnectivity

struct MPCSessionConstants {
    static let kKeyIdentity: String = "identity"
}

class MPCSession: NSObject {
    
    var peerDataHandler: ((Data, MCPeerID) -> Void)?
    var peerConnectedHandler: ((MCPeerID) -> Void)?
    var peerDisconnectedHandler: ((MCPeerID) -> Void)?
    
    private let mcSession: MCSession
    private let mcAdvertiser: MCNearbyServiceAdvertiser
    private let mcBrowser: MCNearbyServiceBrowser
    private let localPeerID = MCPeerID(displayName: UIDevice.current.name)
    private let serviceString: String
    private let identityString: String
    private var peerInvitee: MCPeerID?
    
    init(service: String, identity: String) {
        
        mcSession = MCSession(peer: localPeerID, securityIdentity: nil, encryptionPreference: .none)
        serviceString = service
        identityString = identity
        
        // discoveryInfo 先改成 nil，原本是這個 [MPCSessionConstants.kKeyIdentity: identityString]
        mcAdvertiser = MCNearbyServiceAdvertiser(peer: localPeerID, discoveryInfo: nil, serviceType: serviceString)
        mcBrowser = MCNearbyServiceBrowser(peer: localPeerID, serviceType: serviceString)
        
        super.init()
        
        mcSession.delegate = self
        mcAdvertiser.delegate = self
        mcBrowser.delegate = self
    }
    
    // MARK: - MPCSession Methods
    
    func start() {
        mcAdvertiser.startAdvertisingPeer()
        mcBrowser.startBrowsingForPeers()
    }
    
    func suspend() {
        mcAdvertiser.stopAdvertisingPeer()
        mcBrowser.stopBrowsingForPeers()
    }
    
    func invalidate() {
        suspend()
        mcSession.disconnect()
    }
    
//    func sendDataToAllPeers(data: Data) {
//        sendData(data: data, peers: mcSession.connectedPeers, mode: .reliable)
//    }

    func sendData(colorToSend: UserDataReadyToSend, peers:[MCPeerID], mode: MCSessionSendDataMode) {
        do {
            let data = try JSONEncoder().encode(colorToSend)
            try mcSession.send(data, toPeers: peers, with: mode)
        } catch let error {
            NSLog("Error sending data: \(error)")
        }
    }
}

// MARK: - MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate

extension MPCSession: MCNearbyServiceBrowserDelegate {
    // 查找別人
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
//        guard let identityValue = info?[MPCSessionConstants.kKeyIdentity] else {
//            return
//        }
        // if identityValue == identityString {
            browser.invitePeer(peerID, to: mcSession, withContext: nil, timeout: 10)
        // }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // 處理 lost peer 後
    }
}

extension MPCSession: MCNearbyServiceAdvertiserDelegate {
    // 讓自己可以被查詢到
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, mcSession)
    }
}

// MARK: - MCSessionDelegate

extension MPCSession: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            peerConnected(peerID: peerID)
        case .notConnected:
            peerDisconnected(peerID: peerID)
        case .connecting:
            break
        @unknown default:
            fatalError("Unhandled MCSessionState")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let handler = peerDataHandler {
            DispatchQueue.main.async {
                handler(data, peerID)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
    
    
    // MARK: - `MPCSession` private methods.
    
    private func peerConnected(peerID: MCPeerID) {
        print("Hi")
        if let handler = peerConnectedHandler {
            DispatchQueue.main.async {
                handler(peerID)
            }
        }
//        if mcSession.connectedPeers.count == maxNumPeers {
//            self.suspend()
//        }
        
        sendData(colorToSend: UserDataReadyToSend(color: "012345") , peers: [peerID], mode: .reliable)
    }

    private func peerDisconnected(peerID: MCPeerID) {
        if let handler = peerDisconnectedHandler {
            DispatchQueue.main.async {
                handler(peerID)
            }
        }
//        if mcSession.connectedPeers.count < maxNumPeers {
//            self.start()
//        }
    }
}
