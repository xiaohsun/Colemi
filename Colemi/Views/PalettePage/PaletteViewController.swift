//
//  PaletteViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/13/24.
//

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
        label.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 30)
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
        button.titleLabel?.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 30)
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
        button.titleLabel?.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 20)
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
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#3c3c3c")
        
        // view.addSubview(distanceLabel)
        view.addSubview(bigColorContainerView)
        view.addSubview(midColorContainerView)
        view.addSubview(myColorView)
        view.addSubview(nearbyColorView)
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
            
            mixColorButton.heightAnchor.constraint(equalToConstant: 50),
            mixColorButton.widthAnchor.constraint(equalToConstant: 100),
            mixColorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160),
            mixColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mixColorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mixColorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            saveMixColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveMixColorButton.heightAnchor.constraint(equalToConstant: 50),
            saveMixColorButton.widthAnchor.constraint(equalToConstant: 100),
            saveMixColorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if userManager.mixColorToday == "" {
            userDataReadyToSend.color = userManager.colorToday
            
            mpc = MPCSession(service: "colemi", identity: "")
            
            mpc?.peerConnectedHandler = connectedToPeer
            mpc?.peerDataHandler = dataReceivedHandler
            mpc?.peerDisconnectedHandler = disconnectedFromPeer
        } else {
            findColorLabel.text = "已經混色過囉，明天再來吧"
            findColorLabel.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 20)
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
            findColorLabel.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 20)
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
