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
    var peerUIColor: UIColor?
    let colorModel = ColorModel()
    var mixColor: UIColor?
    
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
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var nearbyColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var mixColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
        if peerUIColor == colorModel.sunnyColors[0] {
            switch userManager.selectedUIColor {
            case colorModel.sunnyColors[1]:
                mixColorView.backgroundColor = colorModel.sunnyColorsMix[0]
            case colorModel.sunnyColors[2]:
                mixColorView.backgroundColor = colorModel.sunnyColorsMix[1]
            default:
                mixColorView.backgroundColor = peerUIColor
            }
        }
        
        if peerUIColor == colorModel.sunnyColors[1] {
            switch userManager.selectedUIColor {
            case colorModel.sunnyColors[0]:
                mixColorView.backgroundColor = colorModel.sunnyColorsMix[0]
            case colorModel.sunnyColors[2]:
                mixColorView.backgroundColor = colorModel.sunnyColorsMix[2]
            default:
                mixColorView.backgroundColor = peerUIColor
            }
        }
        
        if peerUIColor == colorModel.sunnyColors[2] {
            switch userManager.selectedUIColor {
            case colorModel.sunnyColors[0]:
                mixColorView.backgroundColor = colorModel.sunnyColorsMix[1]
            case colorModel.sunnyColors[1]:
                mixColorView.backgroundColor = colorModel.sunnyColorsMix[2]
            default:
                mixColorView.backgroundColor = peerUIColor
            }
        }
        
        mixColor = mixColorView.backgroundColor
    }
    
    lazy var saveMixColorButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(saveMixColorButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func saveMixColorButtonTapped() {
        userManager.selectedUIColor = mixColor
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpUI() {
        view.backgroundColor = .darkGray
        view.addSubview(findColorLabel)
        view.addSubview(distanceLabel)
        view.addSubview(myColorView)
        view.addSubview(nearbyColorView)
        view.addSubview(nearbyDeviceNameLabel)
        view.addSubview(passDataButton)
        view.addSubview(mixColorButton)
        view.addSubview(mixColorView)
        view.addSubview(saveMixColorButton)
        
        NSLayoutConstraint.activate([
            findColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            findColorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            distanceLabel.topAnchor.constraint(equalTo: findColorLabel.bottomAnchor, constant: 100),
            
            myColorView.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 50),
            myColorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            myColorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            myColorView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            nearbyColorView.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 50),
            nearbyColorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            nearbyColorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            nearbyColorView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            nearbyDeviceNameLabel.topAnchor.constraint(equalTo: myColorView.bottomAnchor, constant: 20),
            nearbyDeviceNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            passDataButton.heightAnchor.constraint(equalToConstant: 50),
            passDataButton.widthAnchor.constraint(equalToConstant: 100),
            passDataButton.topAnchor.constraint(equalTo: nearbyDeviceNameLabel.bottomAnchor, constant: 20),
            passDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mixColorButton.heightAnchor.constraint(equalToConstant: 50),
            mixColorButton.widthAnchor.constraint(equalToConstant: 100),
            mixColorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            mixColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mixColorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            mixColorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mixColorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            mixColorView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            saveMixColorButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            saveMixColorButton.heightAnchor.constraint(equalToConstant: 50),
            saveMixColorButton.widthAnchor.constraint(equalToConstant: 100),
            saveMixColorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
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
        let peerUIColor = colorData.color
        showGetDataAlert(color: peerUIColor)
        nearbyColorView.backgroundColor = UIColor(hex: peerUIColor)
        self.peerUIColor = UIColor(hex: peerUIColor)
    }
    
    func disconnectedFromPeer(peer: MCPeerID) {
        // mpc?.invalidate()
    }
}
