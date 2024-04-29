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
    var animationShouldStop: Bool = false
    
    var nearbyColorViewWidthCons: NSLayoutConstraint?
    var nearbyColorViewHeightCons: NSLayoutConstraint?
    
    private var appearAnimator: UIViewPropertyAnimator?
    private var disappearAnimator: UIViewPropertyAnimator?
    
    lazy var findColorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "尋找附近的顏色中"
        label.font = UIFont(name: FontProperty.GenSenRoundedTW_R.rawValue, size: 24)
        label.textColor = .white
        
        return label
    }()
    
    //    lazy var distanceLabel: UILabel = {
    //        let label = UILabel()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.numberOfLines = 0
    //        label.text = "距離為"
    //        label.textColor = .white
    //
    //        return label
    //    }()
    
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
    
    lazy var midColorContainerView: UIView = {
        let view = UIView()
        
        if let selectedColor = userManager.selectedUIColor {
            view.backgroundColor = selectedColor
            
        } else {
            view.backgroundColor = .white
        }
        
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var bigColorContainerView: UIView = {
        let view = UIView()
        
        if let selectedColor = userManager.selectedUIColor {
            view.backgroundColor = selectedColor
            
        } else {
            view.backgroundColor = .white
        }
        
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var nearbyColorView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
    
            return view
        }()
    
    //
    //    lazy var mixColorView: UIView = {
    //        let view = UIView()
    //        view.backgroundColor = .white
    //        view.translatesAutoresizingMaskIntoConstraints = false
    //        view.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
    //
    //        return view
    //    }()
    
    //    lazy var nearbyDeviceNameLabel: UILabel = {
    //        let label = UILabel()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.numberOfLines = 0
    //        label.text = "早安少女"
    //        label.textColor = .white
    //
    //        return label
    //    }()
    
    //    lazy var passDataButton: UIButton = {
    //        let button = UIButton()
    //        button.setTitle("傳遞顏色", for: .normal)
    //        button.backgroundColor = ThemeColorProperty.lightColor.getColor()
    //        button.addTarget(self, action: #selector(passDataButtonTapped), for: .touchUpInside)
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        button.setTitleColor(ThemeColorProperty.darkColor.getColor(), for: .normal)
    //        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
    //        return button
    //    }()
    
    @objc func passDataButtonTapped() {
        if let peer = peer {
            mpc?.sendData(colorToSend: userDataReadyToSend, peers: [peer], mode: .reliable)
        }
    }
    
    //    lazy var mixColorButton: UIButton = {
    //        let button = UIButton()
    //        button.setTitle("Mix", for: .normal)
    //        button.backgroundColor = ThemeColorProperty.lightColor.getColor()
    //        button.addTarget(self, action: #selector(mixColorButtonTapped), for: .touchUpInside)
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        button.setTitleColor(ThemeColorProperty.darkColor.getColor(), for: .normal)
    //        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
    //        return button
    //    }()
    
    @objc func mixColorButtonTapped() {
        guard let peerUIColor = peerUIColor else {
            print("Can get peerUIColor!")
            return
        }
        
        if colorModel.sunnyColors.contains(peerUIColor) {
            // sunnyDayChangeColorView()
        } else {
            // rainyDayChangeColorView()
        }
        
        // mixColor = mixColorView.backgroundColor
    }
    
    //    func sunnyDayChangeColorView() {
    //        if peerUIColor == colorModel.sunnyColors[0] {
    //            switch userManager.selectedUIColor {
    //            case colorModel.sunnyColors[1]:
    //                mixColorView.backgroundColor = colorModel.sunnyColorsMix[0]
    //            case colorModel.sunnyColors[2]:
    //                mixColorView.backgroundColor = colorModel.sunnyColorsMix[1]
    //            default:
    //                mixColorView.backgroundColor = peerUIColor
    //            }
    //        }
    //
    //        if peerUIColor == colorModel.sunnyColors[1] {
    //            switch userManager.selectedUIColor {
    //            case colorModel.sunnyColors[0]:
    //                mixColorView.backgroundColor = colorModel.sunnyColorsMix[0]
    //            case colorModel.sunnyColors[2]:
    //                mixColorView.backgroundColor = colorModel.sunnyColorsMix[2]
    //            default:
    //                mixColorView.backgroundColor = peerUIColor
    //            }
    //        }
    //
    //        if peerUIColor == colorModel.sunnyColors[2] {
    //            switch userManager.selectedUIColor {
    //            case colorModel.sunnyColors[0]:
    //                mixColorView.backgroundColor = colorModel.sunnyColorsMix[1]
    //            case colorModel.sunnyColors[1]:
    //                mixColorView.backgroundColor = colorModel.sunnyColorsMix[2]
    //            default:
    //                mixColorView.backgroundColor = peerUIColor
    //            }
    //        }
    //    }
    //
    //    func rainyDayChangeColorView() {
    //        if peerUIColor == colorModel.rainColors[0] {
    //            switch userManager.selectedUIColor {
    //            case colorModel.rainColors[1]:
    //                mixColorView.backgroundColor = colorModel.rainColorsMix[0]
    //            case colorModel.rainColors[2]:
    //                mixColorView.backgroundColor = colorModel.rainColorsMix[1]
    //            default:
    //                mixColorView.backgroundColor = peerUIColor
    //            }
    //        }
    //
    //        if peerUIColor == colorModel.rainColors[1] {
    //            switch userManager.selectedUIColor {
    //            case colorModel.rainColors[0]:
    //                mixColorView.backgroundColor = colorModel.rainColorsMix[0]
    //            case colorModel.rainColors[2]:
    //                mixColorView.backgroundColor = colorModel.rainColorsMix[2]
    //            default:
    //                mixColorView.backgroundColor = peerUIColor
    //            }
    //        }
    //
    //        if peerUIColor == colorModel.rainColors[2] {
    //            switch userManager.selectedUIColor {
    //            case colorModel.rainColors[0]:
    //                mixColorView.backgroundColor = colorModel.rainColorsMix[1]
    //            case colorModel.rainColors[1]:
    //                mixColorView.backgroundColor = colorModel.rainColorsMix[2]
    //            default:
    //                mixColorView.backgroundColor = peerUIColor
    //            }
    //        }
    //    }
    
    //    lazy var saveMixColorButton: UIButton = {
    //        let button = UIButton()
    //        button.setTitle("Save", for: .normal)
    //        button.backgroundColor = ThemeColorProperty.lightColor.getColor()
    //        button.addTarget(self, action: #selector(saveMixColorButtonTapped), for: .touchUpInside)
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        button.setTitleColor(ThemeColorProperty.darkColor.getColor(), for: .normal)
    //        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
    //        return button
    //    }()
    
    @objc func saveMixColorButtonTapped() {
        userManager.selectedUIColor = mixColor
        userManager.selectedHexColor = mixColor?.toHexString()
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpUI() {
        view.backgroundColor = UIColor(hex: "#3c3c3c")
        view.addSubview(findColorLabel)
        // view.addSubview(distanceLabel)
        view.addSubview(bigColorContainerView)
        view.addSubview(midColorContainerView)
        view.addSubview(myColorView)
        view.addSubview(nearbyColorView)
        //        view.addSubview(nearbyDeviceNameLabel)
        //        view.addSubview(passDataButton)
        //        view.addSubview(mixColorButton)
        //        view.addSubview(mixColorView)
        //        view.addSubview(saveMixColorButton)
        
        nearbyColorViewWidthCons = nearbyColorView.widthAnchor.constraint(equalToConstant: 60)
        nearbyColorViewHeightCons = nearbyColorView.heightAnchor.constraint(equalToConstant: 60)
        
        nearbyColorViewWidthCons?.isActive = true
        nearbyColorViewHeightCons?.isActive = true
        
        NSLayoutConstraint.activate([
            findColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            findColorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            
            // distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // distanceLabel.topAnchor.constraint(equalTo: findColorLabel.bottomAnchor, constant: 50),
            bigColorContainerView.centerXAnchor.constraint(equalTo: myColorView.centerXAnchor),
            bigColorContainerView.centerYAnchor.constraint(equalTo: myColorView.centerYAnchor),
            bigColorContainerView.widthAnchor.constraint(equalTo: myColorView.widthAnchor, multiplier: 3),
            bigColorContainerView.heightAnchor.constraint(equalTo: bigColorContainerView.widthAnchor),
            
            midColorContainerView.centerXAnchor.constraint(equalTo: myColorView.centerXAnchor),
            midColorContainerView.centerYAnchor.constraint(equalTo: myColorView.centerYAnchor),
            midColorContainerView.widthAnchor.constraint(equalTo: myColorView.widthAnchor, multiplier: 2),
            midColorContainerView.heightAnchor.constraint(equalTo: midColorContainerView.widthAnchor),
            
            myColorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myColorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myColorView.widthAnchor.constraint(equalToConstant: 60),
            myColorView.heightAnchor.constraint(equalToConstant: 60),
            
                        nearbyColorView.topAnchor.constraint(equalTo: findColorLabel.bottomAnchor, constant: 100),
                        nearbyColorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            //
            //            nearbyDeviceNameLabel.topAnchor.constraint(equalTo: myColorView.bottomAnchor, constant: 20),
            //            nearbyDeviceNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //
            //            passDataButton.heightAnchor.constraint(equalToConstant: 50),
            //            passDataButton.widthAnchor.constraint(equalToConstant: 100),
            //            passDataButton.topAnchor.constraint(equalTo: nearbyDeviceNameLabel.bottomAnchor, constant: 20),
            //            passDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //
            //            mixColorButton.heightAnchor.constraint(equalToConstant: 50),
            //            mixColorButton.widthAnchor.constraint(equalToConstant: 100),
            //            mixColorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130),
            //            mixColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //
            //            mixColorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -230),
            //            mixColorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //            mixColorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            //            mixColorView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            //
            //            saveMixColorButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //            saveMixColorButton.heightAnchor.constraint(equalToConstant: 50),
            //            saveMixColorButton.widthAnchor.constraint(equalToConstant: 100),
            //            saveMixColorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130)
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myColorView.layer.cornerRadius = myColorView.frame.width / 2
        bigColorContainerView.layer.cornerRadius = bigColorContainerView.frame.width / 2
        midColorContainerView.layer.cornerRadius = midColorContainerView.frame.width / 2
        nearbyColorView.layer.cornerRadius = nearbyColorView.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationShouldStop = false
        containerViewAppearAnimate()
        mpc?.invalidate()
        mpc?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAnimation()
        mpc?.invalidate()
    }
    
    func connectedToPeer(peer: MCPeerID) {
        self.peer = peer
        // nearbyDeviceNameLabel.text = peer.displayName
        
        // doing
        nearbyColorViewWidthCons?.constant = 100
        nearbyColorViewHeightCons?.constant = 100
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
            self.nearbyColorView.layer.cornerRadius = self.nearbyColorView.frame.width / 2
        } completion: { _ in
            
        }
    }
    
    private func stopAnimation() {
        midColorContainerView.alpha = 0
        bigColorContainerView.alpha = 0
        animationShouldStop = true
    }
    
    private func containerViewAppearAnimate() {
        UIView.animate(withDuration: 0.6, delay: 0.5) {
            self.midColorContainerView.alpha = 0.3
        } completion: { _ in
            UIView.animate(withDuration: 0.6) {
                self.bigColorContainerView.alpha = 0.3
            } completion: { _ in
                self.containerViewDisappearAnimate()
            }
        }
    }
    
    private func containerViewDisappearAnimate() {
        UIView.animate(withDuration: 0.6) {
            self.midColorContainerView.alpha = 0
            self.bigColorContainerView.alpha = 0
        } completion: { _ in
            if !self.animationShouldStop {
                self.containerViewAppearAnimate()
            }
        }
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
        // nearbyColorView.backgroundColor = UIColor(hex: peerUIColor)
        self.peerUIColor = UIColor(hex: peerUIColor)
        

    }
    
    func disconnectedFromPeer(peer: MCPeerID) {
        // mpc?.invalidate()
    }
}
