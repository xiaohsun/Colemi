//
//  PaletteViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/13/24.
//
// swiftlint:disable type_body_length

import UIKit
import MultipeerConnectivity

class PaletteViewController: UIViewController {
    
    let viewModel = PaletteViewModel()
    
    let userManager = UserManager.shared
    let userDataReadyToSend = UserDataReadyToSend(color: "")
    var mpc: MPCSession?
    var peer: MCPeerID?
    var peerUIColor: UIColor?
    let colorModel = ColorModel()
    var mixColor: UIColor?
    var animationShouldStop: Bool = false
    
    var myColorViewXCons: NSLayoutConstraint?
    var myColorViewYCons: NSLayoutConstraint?
    var myColorViewHeightCons: NSLayoutConstraint?
    var myColorViewWidthCons: NSLayoutConstraint?
    var nearbyColorViewHeightCons: NSLayoutConstraint?
    var nearbyColorViewWidthCons: NSLayoutConstraint?
    var mixColorViewHeightCons: NSLayoutConstraint?
    var mixColorViewWidthCons: NSLayoutConstraint?
    
    private var appearAnimator: UIViewPropertyAnimator?
    private var disappearAnimator: UIViewPropertyAnimator?
    
    lazy var findColorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "尋找附近的顏色中..."
        label.font = UIFont(name: FontProperty.GenSenRoundedTW_B.rawValue, size: 30)
        label.textColor = .white
        
        return label
    }()
    
    lazy var myColorView: UIView = {
        let view = UIView()
        
        let colorToday = userManager.colorToday
        
        if colorToday == "" {
            view.backgroundColor = .white
        } else {
            view.backgroundColor = UIColor(hex: colorToday)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var midColorContainerView: UIView = {
        let view = UIView()
        
        if let selectedColor = UIColor(hex: userManager.colorToday) {
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
        
        if let selectedColor = UIColor(hex: userManager.colorToday) {
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
    
    lazy var mixColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //    lazy var nearbyDeviceNameLabel: UILabel = {
    //        let label = UILabel()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.numberOfLines = 0
    //        label.text = "早安少女"
    //        label.textColor = .white
    //
    //        return label
    //    }()
    
    @objc func passDataButtonTapped() {
        //        if let peer = peer {
        //            mpc?.sendData(colorToSend: userDataReadyToSend, peers: [peer], mode: .reliable)
        //        }
    }
    
    lazy var mixColorButton: UIButton = {
        let button = UIButton()
        button.setTitle("Mix", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(mixColorButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: FontProperty.GenSenRoundedTW_B.rawValue, size: 20)
        button.setTitleColor(ThemeColorProperty.darkColor.getColor(), for: .normal)
        button.layer.cornerRadius = RadiusProperty.radiusTwenty.rawValue
        button.alpha = 0
        
        return button
    }()
    
    @objc func mixColorButtonTapped() {
        guard let peerUIColor = peerUIColor else {
            print("Can't get peerUIColor!")
            return
        }
        
        if colorModel.sunnyColors.contains(peerUIColor) {
            sunnyDayChangeColorView()
        } else {
            rainyDayChangeColorView()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.alpha = 0
        }
        
        mixColorAnimation()
        
        mixColor = mixColorView.backgroundColor
    }
    
    private func sunnyDayChangeColorView() {
        let colorToday = UIColor(hex: userManager.colorToday)
        
        if peerUIColor == colorModel.sunnyColors[0] {
            switch colorToday {
            case colorModel.sunnyColors[1]:
                mixColorView.backgroundColor = colorModel.sunnyColorsMix[0]
            case colorModel.sunnyColors[2]:
                mixColorView.backgroundColor = colorModel.sunnyColorsMix[1]
            default:
                mixColorView.backgroundColor = peerUIColor
            }
        }
        
        if peerUIColor == colorModel.sunnyColors[1] {
            switch colorToday {
            case colorModel.sunnyColors[0]:
                mixColorView.backgroundColor = colorModel.sunnyColorsMix[0]
            case colorModel.sunnyColors[2]:
                mixColorView.backgroundColor = colorModel.sunnyColorsMix[2]
            default:
                mixColorView.backgroundColor = peerUIColor
            }
        }
        
        if peerUIColor == colorModel.sunnyColors[2] {
            switch colorToday {
            case colorModel.sunnyColors[0]:
                mixColorView.backgroundColor = colorModel.sunnyColorsMix[1]
            case colorModel.sunnyColors[1]:
                mixColorView.backgroundColor = colorModel.sunnyColorsMix[2]
            default:
                mixColorView.backgroundColor = peerUIColor
            }
        }
    }
    
    private func rainyDayChangeColorView() {
        let colorToday = UIColor(hex: userManager.colorToday)
        
        if peerUIColor == colorModel.rainColors[0] {
            switch colorToday {
            case colorModel.rainColors[1]:
                mixColorView.backgroundColor = colorModel.rainColorsMix[0]
            case colorModel.rainColors[2]:
                mixColorView.backgroundColor = colorModel.rainColorsMix[1]
            default:
                mixColorView.backgroundColor = peerUIColor
            }
        }
        
        if peerUIColor == colorModel.rainColors[1] {
            switch colorToday {
            case colorModel.rainColors[0]:
                mixColorView.backgroundColor = colorModel.rainColorsMix[0]
            case colorModel.rainColors[2]:
                mixColorView.backgroundColor = colorModel.rainColorsMix[2]
            default:
                mixColorView.backgroundColor = peerUIColor
            }
        }
        
        if peerUIColor == colorModel.rainColors[2] {
            switch colorToday {
            case colorModel.rainColors[0]:
                mixColorView.backgroundColor = colorModel.rainColorsMix[1]
            case colorModel.rainColors[1]:
                mixColorView.backgroundColor = colorModel.rainColorsMix[2]
            default:
                mixColorView.backgroundColor = peerUIColor
            }
        }
    }
    
    lazy var saveMixColorButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = ThemeColorProperty.darkColor.getColor()
        button.addTarget(self, action: #selector(saveMixColorButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: FontProperty.GenSenRoundedTW_B.rawValue, size: 20)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = RadiusProperty.radiusTwenty.rawValue
        button.alpha = 0
        return button
    }()
    
    @objc private func saveMixColorButtonTapped() {
        if let hexColor = mixColor?.toHexString() {
            userManager.selectedUIColor = mixColor
            userManager.selectedHexColor = mixColor?.toHexString()
            userManager.colorToday = hexColor
            userManager.mixColorToday = hexColor
            
            viewModel.updateColorToday(colorHex: hexColor)
            viewModel.updateMixColor(colorHex: hexColor)
        }
        
//        UIView.animate(withDuration: 0.4) {
//            self.tabBarController?.selectedIndex = 0
//        }
    }
    
    private func setUpUI() {
        view.backgroundColor = UIColor(hex: "#3c3c3c")
        
        // view.addSubview(distanceLabel)
        view.addSubview(bigColorContainerView)
        view.addSubview(midColorContainerView)
        view.addSubview(myColorView)
        view.addSubview(nearbyColorView)
        //        view.addSubview(nearbyDeviceNameLabel)
        //        view.addSubview(passDataButton)
        view.addSubview(mixColorButton)
        view.addSubview(mixColorView)
        view.addSubview(findColorLabel)
        view.addSubview(saveMixColorButton)
        
        myColorViewXCons = myColorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        myColorViewYCons = myColorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        myColorViewWidthCons = myColorView.widthAnchor.constraint(equalToConstant: 60)
        myColorViewHeightCons = myColorView.heightAnchor.constraint(equalToConstant: 60)
        
        myColorViewXCons?.isActive = true
        myColorViewYCons?.isActive = true
        myColorViewWidthCons?.isActive = true
        myColorViewHeightCons?.isActive = true
        
        nearbyColorViewWidthCons = nearbyColorView.widthAnchor.constraint(equalToConstant: 0)
        nearbyColorViewHeightCons = nearbyColorView.heightAnchor.constraint(equalToConstant: 0)
        
        nearbyColorViewWidthCons?.isActive = true
        nearbyColorViewHeightCons?.isActive = true
        
        mixColorViewHeightCons = mixColorView.widthAnchor.constraint(equalToConstant: 0)
        mixColorViewWidthCons = mixColorView.heightAnchor.constraint(equalToConstant: 0)
        
        mixColorViewHeightCons?.isActive = true
        mixColorViewWidthCons?.isActive = true
        
        NSLayoutConstraint.activate([
            findColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
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
            
            nearbyColorView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 70),
            nearbyColorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            //
            //            nearbyDeviceNameLabel.topAnchor.constraint(equalTo: myColorView.bottomAnchor, constant: 20),
            //            nearbyDeviceNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mixColorButton.heightAnchor.constraint(equalToConstant: 50),
            mixColorButton.widthAnchor.constraint(equalToConstant: 100),
            mixColorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160),
            mixColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //
            mixColorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mixColorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //            mixColorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            //            mixColorView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            //
            saveMixColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveMixColorButton.heightAnchor.constraint(equalToConstant: 50),
            saveMixColorButton.widthAnchor.constraint(equalToConstant: 100),
            saveMixColorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        if userManager.mixColorToday == "" {
            userDataReadyToSend.color = userManager.colorToday
            
            mpc = MPCSession(service: "colemi", identity: "")
            
            mpc?.peerConnectedHandler = connectedToPeer
            mpc?.peerDataHandler = dataReceivedHandler
            mpc?.peerDisconnectedHandler = disconnectedFromPeer
        } else {
            findColorLabel.text = "已經混色過囉，明天再來吧"
            findColorLabel.font = UIFont(name: FontProperty.GenSenRoundedTW_B.rawValue, size: 20)
        }
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
        if userManager.mixColorToday == "" {
            animationShouldStop = false
            containerViewAppearAnimate()
            mpc?.invalidate()
            mpc?.start()
        } else {
            findColorLabel.text = "已經混色過囉，明天再來吧"
            findColorLabel.font = UIFont(name: FontProperty.GenSenRoundedTW_B.rawValue, size: 20)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopLoopAnimation()
        mpc?.invalidate()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        NotificationCenter.default.post(name: NSNotification.Name("ToMixPostColorView"), object: nil)
//    }
    
    func connectedToPeer(peer: MCPeerID) {
        self.peer = peer
        // nearbyDeviceNameLabel.text = peer.displayName
        findColorLabel.text = "找到顏色了！"
        mpc?.sendData(colorToSend: userDataReadyToSend, peers: [peer], mode: .reliable)
        
        meetColorAnimation()
    }
    
    private func meetColorAnimation() {
        
        myColorViewXCons?.constant = -70
        myColorViewYCons?.constant = 70
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
            self.stopLoopAnimation()
            self.nearbyColorView.layer.cornerRadius = self.nearbyColorView.frame.width / 2
            
        } completion: { _ in
            self.nearbyColorViewWidthCons?.constant = 60
            self.nearbyColorViewHeightCons?.constant = 60
            
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8) {
                self.view.layoutIfNeeded()
                
            } completion: { _ in
                UIView.animate(withDuration: 0.4) {
                    self.mixColorButton.alpha = 1
                }
            }
        }
    }
    
    private func mixColorAnimation() {
        UIView.animate(withDuration: 0.4) {
            self.saveMixColorButton.alpha = 0
            self.mixColorButton.alpha = 0
            self.findColorLabel.alpha = 0
            
        } completion: { _ in
            self.myColorViewWidthCons?.constant = 100
            self.myColorViewHeightCons?.constant = 100
            
            UIView.animate(withDuration: 0.4, delay: 0.6, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                self.view.layoutIfNeeded()
                
            } completion: { _ in
                self.nearbyColorViewWidthCons?.constant = 100
                self.nearbyColorViewHeightCons?.constant = 100
                
                UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                    self.view.layoutIfNeeded()
                    
                } completion: { _ in
                    self.myColorViewWidthCons?.constant = 140
                    self.myColorViewHeightCons?.constant = 140
                    
                    UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                        self.view.layoutIfNeeded()
                        
                    } completion: { _ in
                        self.nearbyColorViewWidthCons?.constant = 140
                        self.nearbyColorViewHeightCons?.constant = 140
                        
                        UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                            self.view.layoutIfNeeded()
                            
                        } completion: { _ in
                            self.nearbyColorViewWidthCons?.constant = 0
                            self.nearbyColorViewHeightCons?.constant = 0
                            self.myColorViewWidthCons?.constant = 0
                            self.myColorViewHeightCons?.constant = 0
                            
                            UIView.animate(withDuration: 0.4, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                                self.view.layoutIfNeeded()
                                
                            } completion: { _ in
                                self.mixColorViewWidthCons?.constant = 1000
                                self.mixColorViewHeightCons?.constant = 1000
                                
                                UIView.animate(withDuration: 0.4, delay: 0.5) {
                                    self.view.layoutIfNeeded()
                                    self.mixColorView.layer.cornerRadius = self.mixColorView.frame.width / 2
                                    
                                } completion: { _ in
                                    self.findColorLabel.textColor = ThemeColorProperty.darkColor.getColor()
                                    self.findColorLabel.text = "完成混色！"
                                    
                                    UIView.animate(withDuration: 0.4, delay: 0.5) {
                                        self.findColorLabel.alpha = 1
                                        self.saveMixColorButton.alpha = 1
                                        self.tabBarController?.tabBar.alpha = 1
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        
    }
    
    private func stopLoopAnimation() {
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
        // showGetDataAlert(color: peerUIColor)
        nearbyColorView.backgroundColor = UIColor(hex: peerUIColor)
        self.peerUIColor = UIColor(hex: peerUIColor)
    }
    
    func disconnectedFromPeer(peer: MCPeerID) {
        // mpc?.invalidate()
    }
}
