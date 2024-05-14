//
//  ChooseColorViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/12/24.
//

import UIKit
import WeatherKit
import CoreLocation

class ChooseColorViewController: UIViewController {
    
    let viewModel = ChooseColorViewModel()
    let colorModel = ColorModel()
    let userData = UserManager.shared
    let locationManager = CLLocationManager()
    var colorViews: [UIView] = []
    var colorContainerViews: [UIView] = []
    var goodWeather = true
    var selectedUIColor: UIColor?
    
    var tapGesture = UITapGestureRecognizer()
    
    var colorView1XCons: NSLayoutConstraint?
    var colorView1YCons: NSLayoutConstraint?
    var colorView1WidthCons: NSLayoutConstraint?
    var colorView1HeightCons: NSLayoutConstraint?
    var colorView2XCons: NSLayoutConstraint?
    var colorView2YCons: NSLayoutConstraint?
    var colorView2WidthCons: NSLayoutConstraint?
    var colorView2HeightCons: NSLayoutConstraint?
    var colorView3XCons: NSLayoutConstraint?
    var colorView3YCons: NSLayoutConstraint?
    var colorView3WidthCons: NSLayoutConstraint?
    var colorView3HeightCons: NSLayoutConstraint?
    
    var raindropView1TopCons: NSLayoutConstraint?
    var raindropView2TopCons: NSLayoutConstraint?
    var raindropView3TopCons: NSLayoutConstraint?
    
    lazy var tapScreenLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontProperty.GenSenRoundedTW_B.rawValue, size: 24)
        label.textColor = .white
        label.text = "請點選螢幕"
        
        return label
    }()
    
    lazy var chooseColorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "選擇代表今日的顏色"
        label.textColor = .white
        label.font = UIFont(name: FontProperty.GenSenRoundedTW_B.rawValue, size: 24)
        label.alpha = 0
        
        return label
    }()
    
    lazy var weatherInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "info.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(infoBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.imageView?.tintColor = .white
        return button
    }()
    
    @objc private func infoBtnTapped() {
        let weatherInfoPopUp = WeatherInfoPopUp()
        weatherInfoPopUp.modalPresentationStyle = .overCurrentContext
        weatherInfoPopUp.appear(sender: self)
    }
    
    private func createColorView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorTapped))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = false
        view.tag = colorViews.count
        colorViews.append(view)
        view.alpha = 0
        
        return view
    }
    
    lazy var auraImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.auraIcon.withRenderingMode(.alwaysTemplate)
        imageView.alpha = 0
        imageView.tintColor = colorModel.sunnyColors[1]
        
        return imageView
    }()
    
    func createRaindropImageView() -> UIView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = .rainDropIcon.withRenderingMode(.alwaysTemplate)
        imageView.alpha = 0
        
        return imageView
    }
    
    func createColorContainerViews() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        colorContainerViews.append(view)
        view.alpha = 0
        
        return view
    }
    
    @objc private func colorTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        
        UIView.animate(withDuration: 0.4) {
            for colorView in self.colorViews {
                colorView.transform = .init(scaleX: 1.0, y: 1.0)
            }
            
            sender.view?.transform = .init(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            
        }
        
        if goodWeather {
            selectedUIColor = colorModel.sunnyColors[index]
        } else {
            selectedUIColor = colorModel.rainColors[index]
        }
    }
    
    lazy var checkIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.checkIcon
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.alpha = 0
        return imageView
    }()
    
    @objc private func checkTapped(_ sender: UITapGestureRecognizer) {
        if let selectedColorHex = selectedUIColor?.toHexString() {
            // userData.selectedColor = selectedColor.rgba
            userData.colorToday = selectedColorHex
            // userData.selectedUIColor = selectedColor
            // userData.selectedHexColor = selectedColor.toHexString()
            Task {
                await viewModel.updateUserData(colorToday: selectedColorHex, colorSetToday: userData.colorSetToday, docID: userData.id)
            }
            
            // navigationController?.popViewController(animated: true)
            let signInViewModel = SignInViewModel()
            signInViewModel.updateLoginTime()
            signInViewModel.setRootVCToTabBarController()
        }
    }
    
    private func addShowAnimationGes() {
        if goodWeather {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(setSunnyAnimation))
        } else {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(setRainyAnimation))
        }
        
            view.addGestureRecognizer(tapGesture)
        
        // setUpHiddenViews()
    }
    
    @objc private func setSunnyAnimation() {
        for gesture in view.gestureRecognizers! {
            view.removeGestureRecognizer(gesture)
        }
        UIView.animate(withDuration: 0.4) {
            self.tapScreenLabel.alpha = 0
        }
        setUpSunnyInitPosition()
        sunnyAnimation()
        userData.colorSetToday = colorModel.sunnyColorsHex
    }
    
    @objc private func setRainyAnimation() {
        for gesture in view.gestureRecognizers! {
            view.removeGestureRecognizer(gesture)
        }
        UIView.animate(withDuration: 0.4) {
            self.tapScreenLabel.alpha = 0
        }
        setUpRainInitPosition()
        rainAnimation()
        userData.colorSetToday = colorModel.rainColorsHex
    }
    
    
    private func commonInitPostion() {
        colorView1XCons = colorView1.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        colorView1YCons = colorView1.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -650)
        colorView1WidthCons = colorView1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3)
        colorView1HeightCons = colorView1.heightAnchor.constraint(equalTo: colorView1.widthAnchor)
        
        colorView1XCons?.isActive = true
        colorView1YCons?.isActive = true
        colorView1WidthCons?.isActive = true
        colorView1HeightCons?.isActive = true
        
        colorView2XCons = colorView2.centerXAnchor.constraint(equalTo: colorView1.centerXAnchor)
        colorView2YCons = colorView2.centerYAnchor.constraint(equalTo: colorView1.centerYAnchor)
        colorView2WidthCons = colorView2.widthAnchor.constraint(equalTo: colorView1.widthAnchor)
        colorView2HeightCons = colorView2.heightAnchor.constraint(equalTo: colorView2.widthAnchor)
        
        colorView2XCons?.isActive = true
        colorView2YCons?.isActive = true
        colorView2WidthCons?.isActive = true
        colorView2HeightCons?.isActive = true
        
        colorView3XCons = colorView3.centerXAnchor.constraint(equalTo: colorView1.centerXAnchor)
        colorView3YCons = colorView3.centerYAnchor.constraint(equalTo: colorView1.centerYAnchor)
        colorView3WidthCons = colorView3.widthAnchor.constraint(equalTo: colorView1.widthAnchor)
        colorView3HeightCons = colorView3.heightAnchor.constraint(equalTo: colorView3.widthAnchor)
        
        colorView3XCons?.isActive = true
        colorView3YCons?.isActive = true
        colorView3WidthCons?.isActive = true
        colorView3HeightCons?.isActive = true
    }
    
    lazy var colorView1 = createColorView()
    lazy var colorView2 = createColorView()
    lazy var colorView3 = createColorView()
    lazy var colorContainerView1 = createColorContainerViews()
    lazy var colorContainerView2 = createColorContainerViews()
    lazy var colorContainerView3 = createColorContainerViews()
    lazy var raindropImageView1 = createRaindropImageView()
    lazy var raindropImageView2 = createRaindropImageView()
    lazy var raindropImageView3 = createRaindropImageView()
    
    private func setUpUI() {
        
        view.backgroundColor = UIColor(hex: "#333333")
        
        view.addSubview(chooseColorLabel)
        view.addSubview(weatherInfoButton)
        view.addSubview(colorContainerView1)
        view.addSubview(colorContainerView2)
        view.addSubview(colorContainerView3)
        
        view.addSubview(colorView2)
        view.addSubview(raindropImageView2)
        view.addSubview(colorView3)
        view.addSubview(colorView1)
        view.addSubview(raindropImageView1)
        view.addSubview(raindropImageView3)
        
        view.addSubview(tapScreenLabel)
        view.addSubview(checkIconImageView)
        
        commonInitPostion()
        
        NSLayoutConstraint.activate([
            chooseColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chooseColorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            
            weatherInfoButton.leadingAnchor.constraint(equalTo: chooseColorLabel.trailingAnchor, constant: 10),
            weatherInfoButton.widthAnchor.constraint(equalToConstant: 15),
            weatherInfoButton.heightAnchor.constraint(equalTo: weatherInfoButton.widthAnchor),
            weatherInfoButton.centerYAnchor.constraint(equalTo: chooseColorLabel.centerYAnchor),
            
            colorContainerView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            colorContainerView1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorContainerView1.widthAnchor.constraint(equalTo: colorView1.widthAnchor, multiplier: 1.2),
            colorContainerView1.heightAnchor.constraint(equalTo: colorView1.widthAnchor, multiplier: 1.2),
            
            colorContainerView2.topAnchor.constraint(equalTo: colorContainerView1.bottomAnchor, constant: 30),
            colorContainerView2.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80),
            colorContainerView2.widthAnchor.constraint(equalTo: colorView2.widthAnchor, multiplier: 1.2),
            colorContainerView2.heightAnchor.constraint(equalTo: colorView2.widthAnchor, multiplier: 1.2),
            
            colorContainerView3.topAnchor.constraint(equalTo: colorContainerView2.bottomAnchor, constant: 25),
            colorContainerView3.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60),
            colorContainerView3.widthAnchor.constraint(equalTo: colorView3.widthAnchor, multiplier: 1.2),
            colorContainerView3.heightAnchor.constraint(equalTo: colorView3.widthAnchor, multiplier: 1.2),
            
            raindropImageView1.heightAnchor.constraint(equalToConstant: 40),
            raindropImageView1.widthAnchor.constraint(equalToConstant: 40),
            raindropImageView1.centerXAnchor.constraint(equalTo: colorView1.centerXAnchor, constant: 20),
            
            raindropImageView2.heightAnchor.constraint(equalToConstant: 40),
            raindropImageView2.widthAnchor.constraint(equalToConstant: 40),
            raindropImageView2.centerXAnchor.constraint(equalTo: colorView2.centerXAnchor, constant: -20),
            
            raindropImageView3.heightAnchor.constraint(equalToConstant: 40),
            raindropImageView3.widthAnchor.constraint(equalToConstant: 40),
            raindropImageView3.centerXAnchor.constraint(equalTo: colorView3.centerXAnchor, constant: 20),
            
            checkIconImageView.heightAnchor.constraint(equalToConstant: 50),
            checkIconImageView.widthAnchor.constraint(equalToConstant: 50),
            checkIconImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            checkIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tapScreenLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tapScreenLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // 因為 cross 交換 VC 時，這些 view 會莫名跑出來，所以等到點擊螢幕時再加上去
    
//    private func setUpHiddenViews() {
//        view.addSubview(chooseColorLabel)
//        view.addSubview(colorContainerView1)
//        view.addSubview(colorContainerView2)
//        view.addSubview(colorContainerView3)
//        view.addSubview(colorView2)
//        view.addSubview(raindropImageView2)
//        view.addSubview(colorView3)
//        view.addSubview(colorView1)
//        view.addSubview(raindropImageView1)
//        view.addSubview(raindropImageView3)
//        view.addSubview(checkIconImageView)
//        
//        NSLayoutConstraint.activate([
//            chooseColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            chooseColorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
//            
//            colorContainerView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
//            colorContainerView1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            colorContainerView1.widthAnchor.constraint(equalTo: colorView1.widthAnchor, multiplier: 1.2),
//            colorContainerView1.heightAnchor.constraint(equalTo: colorView1.widthAnchor, multiplier: 1.2),
//            
//            colorContainerView2.topAnchor.constraint(equalTo: colorContainerView1.bottomAnchor, constant: 30),
//            colorContainerView2.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80),
//            colorContainerView2.widthAnchor.constraint(equalTo: colorView2.widthAnchor, multiplier: 1.2),
//            colorContainerView2.heightAnchor.constraint(equalTo: colorView2.widthAnchor, multiplier: 1.2),
//            
//            colorContainerView3.topAnchor.constraint(equalTo: colorContainerView2.bottomAnchor, constant: 25),
//            colorContainerView3.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60),
//            colorContainerView3.widthAnchor.constraint(equalTo: colorView3.widthAnchor, multiplier: 1.2),
//            colorContainerView3.heightAnchor.constraint(equalTo: colorView3.widthAnchor, multiplier: 1.2),
//            
//            checkIconImageView.heightAnchor.constraint(equalToConstant: 50),
//            checkIconImageView.widthAnchor.constraint(equalToConstant: 50),
//            checkIconImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
//            checkIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        locationManager.delegate = self
        
        // setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // tabBarController?.tabBar.isHidden = true
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for index in 0..<colorViews.count {
            colorViews[index].layer.cornerRadius = colorViews[index].frame.width / 2
            colorContainerViews[index].layer.cornerRadius = colorContainerViews[index].frame.width / 2
        }
    }
}

extension ChooseColorViewController: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        locationManager.stopUpdatingLocation()
        if let location = locations.last {
            Task.init {
                await viewModel.currentWeather(for: location)
            }
        } else {
            self.colorView1.backgroundColor = self.colorModel.sunnyColors[2]
            self.colorView2.backgroundColor = self.colorModel.sunnyColors[0]
            self.colorView3.backgroundColor = self.colorModel.sunnyColors[1]
            self.colorContainerView1.backgroundColor = self.colorModel.sunnyColors[2]
            self.colorContainerView2.backgroundColor = self.colorModel.sunnyColors[0]
            self.colorContainerView3.backgroundColor = self.colorModel.sunnyColors[1]
            self.goodWeather = true
            self.addShowAnimationGes()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.colorView1.backgroundColor = self.colorModel.sunnyColors[2]
        self.colorView2.backgroundColor = self.colorModel.sunnyColors[0]
        self.colorView3.backgroundColor = self.colorModel.sunnyColors[1]
        self.colorContainerView1.backgroundColor = self.colorModel.sunnyColors[2]
        self.colorContainerView2.backgroundColor = self.colorModel.sunnyColors[0]
        self.colorContainerView3.backgroundColor = self.colorModel.sunnyColors[1]
        self.goodWeather = true
        self.addShowAnimationGes()
    }
}

extension ChooseColorViewController: ChooseColorViewModelDelegate {
    func passWeatherCondition(_ condition: WeatherCondition) {
        DispatchQueue.main.async {
            switch condition {
            case .partlyCloudy, .cloudy, .clear, .hot, .mostlyCloudy, .mostlyClear, .sunFlurries :
                self.colorView1.backgroundColor = self.colorModel.sunnyColors[2]
                self.colorView2.backgroundColor = self.colorModel.sunnyColors[0]
                self.colorView3.backgroundColor = self.colorModel.sunnyColors[1]
                self.colorContainerView1.backgroundColor = self.colorModel.sunnyColors[2]
                self.colorContainerView2.backgroundColor = self.colorModel.sunnyColors[0]
                self.colorContainerView3.backgroundColor = self.colorModel.sunnyColors[1]
                self.goodWeather = true
                // self.weatherDescriptionLabel.text = "今天的天氣是 \(condition.description)"
                
//                self.setUpSunnyInitPosition()
//                self.sunnyAnimation()
//                self.userData.colorSetToday = self.colorModel.sunnyColorsHex
                self.addShowAnimationGes()
                
            default:
                // 暫時改成全部都是陽光
//                self.colorView1.backgroundColor = self.colorModel.rainColors[2]
//                self.colorView2.backgroundColor = self.colorModel.rainColors[0]
//                self.colorView3.backgroundColor = self.colorModel.rainColors[1]
//                self.colorContainerView1.backgroundColor = self.colorModel.rainColors[2]
//                self.colorContainerView2.backgroundColor = self.colorModel.rainColors[0]
//                self.colorContainerView3.backgroundColor = self.colorModel.rainColors[1]
//                self.raindropImageView1.tintColor = self.colorModel.rainColors[2]
//                self.raindropImageView2.tintColor = self.colorModel.rainColors[0]
//                self.raindropImageView3.tintColor = self.colorModel.rainColors[1]
//                self.goodWeather = false
//                self.addShowAnimationGes()
                // 以上 Demo 完要改回來
                
                // 以下 Demo 完要刪掉
                self.colorView1.backgroundColor = self.colorModel.sunnyColors[2]
                self.colorView2.backgroundColor = self.colorModel.sunnyColors[0]
                self.colorView3.backgroundColor = self.colorModel.sunnyColors[1]
                self.colorContainerView1.backgroundColor = self.colorModel.sunnyColors[2]
                self.colorContainerView2.backgroundColor = self.colorModel.sunnyColors[0]
                self.colorContainerView3.backgroundColor = self.colorModel.sunnyColors[1]
                self.goodWeather = true
                self.addShowAnimationGes()
                // 以上 Demo 完要刪掉
                
//                self.setUpRainInitPosition()
//                self.rainAnimation()
//                self.userData.colorSetToday = self.colorModel.rainColorsHex
                
            }
        }
    }
}

// MARK: - Animation

extension ChooseColorViewController {
    // 晴天最初的位置
    private func setUpSunnyInitPosition() {
        view.addSubview(auraImageView)
        
        NSLayoutConstraint.activate([
            auraImageView.widthAnchor.constraint(equalTo: colorView3.widthAnchor, constant: 145),
            auraImageView.heightAnchor.constraint(equalTo: colorView3.heightAnchor, constant: 145),
            auraImageView.centerXAnchor.constraint(equalTo: colorView1.centerXAnchor),
            auraImageView.centerYAnchor.constraint(equalTo: colorView1.centerYAnchor)
        ])
    }
    
    // 下雨天最初的位置
    private func setUpRainInitPosition() {
        raindropView1TopCons = raindropImageView1.topAnchor.constraint(equalTo: colorView1.bottomAnchor, constant: -100)
        raindropView2TopCons = raindropImageView2.topAnchor.constraint(equalTo: colorView2.bottomAnchor, constant: -90)
        raindropView3TopCons = raindropImageView3.topAnchor.constraint(equalTo: colorView3.bottomAnchor, constant: -100)
        
        raindropView1TopCons?.isActive = true
        raindropView2TopCons?.isActive = true
        raindropView3TopCons?.isActive = true
    }
    
    private func sunnyAnimation() {
        
//        for index in 0..<colorViews.count {
//            colorContainerViews[index].layer.cornerRadius = colorContainerViews[index].frame.width / 2
//        }
        
        for colorView in self.colorViews {
            colorView.alpha = 1
        }
        
        self.colorView1WidthCons?.constant = -70
        self.colorView1YCons?.constant = -230
        
        UIView.animate(withDuration: 1.4, delay: 0.8, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseIn) {
            self.view.layoutIfNeeded()
            
        } completion: { _ in
            self.colorView3WidthCons?.constant = 30
            
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
                
            } completion: { _ in
                self.colorView2WidthCons?.constant = 60
                
                UIView.animate(withDuration: 0.4) {
                    self.view.layoutIfNeeded()
                    
                } completion: { _ in
                    UIView.animate(withDuration: 0.4, delay: 0.6) {
                        self.auraImageView.alpha = 1
                        
                    } completion: { _ in
                        UIView.animate(withDuration: 0.6, delay: 0.4) {
                            self.auraImageView.transform = self.auraImageView.transform.rotated(by: .pi * 1.5)
                            
                        } completion: { _ in
                            UIView.animate(withDuration: 0.6) {
                                self.auraImageView.transform = self.auraImageView.transform.rotated(by: .pi * 1.5)
                                
                            } completion: { _ in
                                UIView.animate(withDuration: 0.4, delay: 0.6) {
                                    self.auraImageView.alpha = 0
                                    
                                } completion: { _ in
                                        self.colorView1XCons?.isActive = false
                                        self.colorView1YCons?.isActive = false
                                        self.colorView2XCons?.isActive = false
                                        self.colorView2YCons?.isActive = false
                                        self.colorView3XCons?.isActive = false
                                        self.colorView3YCons?.isActive = false
                                        
                                        self.colorView1XCons = self.colorView1.centerXAnchor.constraint(equalTo: self.colorContainerView1.centerXAnchor)
                                        self.colorView1YCons = self.colorView1.centerYAnchor.constraint(equalTo: self.colorContainerView1.centerYAnchor)
                                        
                                        self.colorView1WidthCons?.constant = 0
                                        
                                        self.colorView2XCons = self.colorView2.centerXAnchor.constraint(equalTo: self.colorContainerView2.centerXAnchor)
                                        self.colorView2YCons = self.colorView2.centerYAnchor.constraint(equalTo: self.colorContainerView2.centerYAnchor)
                                        
                                        self.colorView2WidthCons?.constant = 0
                                        
                                        self.colorView3XCons = self.colorView3.centerXAnchor.constraint(equalTo: self.colorContainerView3.centerXAnchor)
                                        self.colorView3YCons = self.colorView3.centerYAnchor.constraint(equalTo: self.colorContainerView3.centerYAnchor)
                                        
                                        self.colorView3WidthCons?.constant = 0
                                        
                                        self.colorView1XCons?.isActive = true
                                        self.colorView1YCons?.isActive = true
                                        self.colorView2XCons?.isActive = true
                                        self.colorView2YCons?.isActive = true
                                        self.colorView3XCons?.isActive = true
                                        self.colorView3YCons?.isActive = true
                                        
                                        UIView.animate(withDuration: 0.6, delay: 0.45) {
                                            self.view.layoutIfNeeded()
                                            
                                        } completion: { _ in
                                            UIView.animate(withDuration: 0.6) {
                                                for colorContainerView in self.colorContainerViews {
                                                    colorContainerView.alpha = 0.3
                                                }
                                                
                                            } completion: { _ in
                                                UIView.animate(withDuration: 0.6) {
                                                    self.chooseColorLabel.alpha = 1
                                                    self.checkIconImageView.alpha = 1
                                                    self.weatherInfoButton.alpha = 1
                                                }
                                                self.checkIconImageView.isUserInteractionEnabled = true
                                                
                                                for colorView in self.colorViews {
                                                    colorView.isUserInteractionEnabled = true
                                                }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func rainAnimation() {
        
//        for index in 0..<colorViews.count {
//            colorContainerViews[index].layer.cornerRadius = colorContainerViews[index].frame.width / 2
//        }
        
        for colorView in self.colorViews {
            colorView.alpha = 1
        }
        
        self.colorView1XCons?.constant = -10
        self.colorView1YCons?.constant = -250
        self.colorView2XCons?.constant = -30
        self.colorView2YCons?.constant = 60
        self.colorView2WidthCons?.constant = 40
        self.colorView3XCons?.constant = 60
        self.colorView3YCons?.constant = 50
        
        UIView.animate(withDuration: 1.4, delay: 0.8, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseIn) {
            
            self.view.layoutIfNeeded()
        } completion: { _ in
            
            self.raindropImageView1.alpha = 1
            self.raindropImageView2.alpha = 1
            self.raindropImageView3.alpha = 1
            
            self.raindropView1TopCons?.constant = 20
            self.raindropView2TopCons?.constant = 30
            self.raindropView3TopCons?.constant = 20
            
            UIView.animate(withDuration: 0.8, delay: 0.4) {
                
                self.view.layoutIfNeeded()
                
            } completion: { _ in
                
                self.raindropView1TopCons?.constant = -80
                self.raindropView2TopCons?.constant = -80
                self.raindropView3TopCons?.constant = -80
                
                UIView.animate(withDuration: 0.6, delay: 0.6) {
                    
                    self.view.layoutIfNeeded()
                    
                } completion: { _ in
                    
                    self.raindropImageView1.alpha = 0
                    self.raindropImageView2.alpha = 0
                    self.raindropImageView3.alpha = 0
                    
                    self.colorView1XCons?.isActive = false
                    self.colorView1YCons?.isActive = false
                    self.colorView2XCons?.isActive = false
                    self.colorView2YCons?.isActive = false
                    self.colorView3XCons?.isActive = false
                    self.colorView3YCons?.isActive = false
                    self.colorView2WidthCons?.isActive = false
                    self.colorView2HeightCons?.isActive = false
                    
                    self.colorView1XCons = self.colorView1.centerXAnchor.constraint(equalTo: self.colorContainerView1.centerXAnchor)
                    self.colorView1YCons = self.colorView1.centerYAnchor.constraint(equalTo: self.colorContainerView1.centerYAnchor)
                    self.colorView2XCons = self.colorView2.centerXAnchor.constraint(equalTo: self.colorContainerView2.centerXAnchor)
                    self.colorView2YCons = self.colorView2.centerYAnchor.constraint(equalTo: self.colorContainerView2.centerYAnchor)
                    self.colorView3XCons = self.colorView3.centerXAnchor.constraint(equalTo: self.colorContainerView3.centerXAnchor)
                    self.colorView3YCons = self.colorView3.centerYAnchor.constraint(equalTo: self.colorContainerView3.centerYAnchor)
                    self.colorView2WidthCons = self.colorView2.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3)
                    self.colorView2HeightCons =  self.colorView2.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3)
                    
                    self.colorView1XCons?.isActive = true
                    self.colorView1YCons?.isActive = true
                    self.colorView2XCons?.isActive = true
                    self.colorView2YCons?.isActive = true
                    self.colorView3XCons?.isActive = true
                    self.colorView3YCons?.isActive = true
                    self.colorView2WidthCons?.isActive = true
                    self.colorView2HeightCons?.isActive = true
                    
                    UIView.animate(withDuration: 0.6, delay: 0.3) {
                        self.view.layoutIfNeeded()
                    } completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            for colorContainerView in self.colorContainerViews {
                                colorContainerView.alpha = 0.3
                            }
                        } completion: { _ in
                            UIView.animate(withDuration: 0.6) {
                                self.chooseColorLabel.alpha = 1
                                self.checkIconImageView.alpha = 1
                                self.weatherInfoButton.alpha = 1
                            }
                            self.checkIconImageView.isUserInteractionEnabled = true
                            // self.view.isUserInteractionEnabled = true
                            for colorView in self.colorViews {
                                colorView.isUserInteractionEnabled = true
                            }
                        }
                    }
                }
            }
        }
    }
}
