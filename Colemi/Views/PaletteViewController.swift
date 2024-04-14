//
//  PaletteViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/13/24.
//

import UIKit
import MultipeerConnectivity

class PaletteViewController: UIViewController {
    
    let userManager = UserManager.shared
    let userDataReadyToSend = UserDataReadyToSend(color: "")
    var mpc: MPCSession?
    var peer: MCPeerID?
    
    lazy var findColorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "尋找附近的顏色中"
        label.textColor = .white
        
        return label
    }()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "距離為"
        label.textColor = .white
        
        return label
    }()
    
    lazy var myColorView: UIView = {
        let view = UIView()
        
        if let selectedColor = userManager.selectedUIColor {
            view.backgroundColor = selectedColor
        } else {
            view.backgroundColor = .white
        }
        
//        if let selectedColor = userManager.selectedColor {
//            view.backgroundColor = UIColor(red: selectedColor.red, green: selectedColor.green, blue: selectedColor.blue, alpha: selectedColor.alpha)
//        } else {
//            view.backgroundColor = .white
//        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var nearbyColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var nearbyDeviceNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "早安少女"
        
        return label
    }()
    
    lazy var passDataButton: UIButton = {
        let button = UIButton()
        button.setTitle("傳遞顏色", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(passDataButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func passDataButtonTapped() {
        if let peer = peer {
            mpc?.sendData(colorToSend: userDataReadyToSend, peers: [peer], mode: .reliable)
        }
    }
    
    lazy var mixColorButton: UIButton = {
        let button = UIButton()
        button.setTitle("Mix", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(mixColorButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func mixColorButtonTapped() {
        print("Hi")
    }
    
    private func setUpUI() {
        view.backgroundColor = .darkGray
        view.addSubview(findColorLabel)
        view.addSubview(distanceLabel)
        view.addSubview(myColorView)
        view.addSubview(nearbyDeviceNameLabel)
        view.addSubview(passDataButton)
        view.addSubview(mixColorButton)
        
        NSLayoutConstraint.activate([
            findColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            findColorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            distanceLabel.topAnchor.constraint(equalTo: findColorLabel.bottomAnchor, constant: 100),
            
            myColorView.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 50),
            myColorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myColorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            myColorView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            nearbyDeviceNameLabel.topAnchor.constraint(equalTo: myColorView.bottomAnchor, constant: 20),
            nearbyDeviceNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            passDataButton.heightAnchor.constraint(equalToConstant: 50),
            passDataButton.widthAnchor.constraint(equalToConstant: 100),
            passDataButton.topAnchor.constraint(equalTo: nearbyDeviceNameLabel.bottomAnchor, constant: 20),
            passDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mixColorButton.heightAnchor.constraint(equalToConstant: 50),
            mixColorButton.widthAnchor.constraint(equalToConstant: 100),
            mixColorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            mixColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        userDataReadyToSend.color = userManager.selectedHexColor ?? ""
        
        mpc = MPCSession(service: "colemi", identity: "")
        
        mpc?.peerConnectedHandler = connectedToPeer
        mpc?.peerDataHandler = dataReceivedHandler
        mpc?.peerDisconnectedHandler = disconnectedFromPeer
        
        mpc?.invalidate()
        mpc?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mpc?.invalidate()
    }
    
    func connectedToPeer(peer: MCPeerID) {
        self.peer = peer
        nearbyDeviceNameLabel.text = peer.displayName
    }
    
    func showGetDataAlert(color: String) {
        let alert = UIAlertController(title: "Data", message: "I'm awesome!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Get \(color)", style: .default)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func dataReceivedHandler(data: Data, peer: MCPeerID) {
        guard let colorData = try? JSONDecoder().decode(UserDataReadyToSend.self, from: data) else { return }
        showGetDataAlert(color: colorData.color)
    }
    
    func disconnectedFromPeer(peer: MCPeerID) {
        // mpc?.invalidate()
    }
}
