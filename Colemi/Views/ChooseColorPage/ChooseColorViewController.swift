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
        label.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 24)
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
        label.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 24)
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
            userData.colorToday = selectedColorHex
            viewModel.updateUserData(colorToday: selectedColorHex, colorSetToday: userData.colorSetToday, docID: userData.id)
            
            let signInViewModel = SignInViewModel()
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
    }
    
    @objc private func setSunnyAnimation() {
        for gesture in view.gestureRecognizers! {
            view.removeGestureRecognizer(gesture)
        }
        UIView.animate(withDuration: 0.4) {
            self.tapScreenLabel.alpha = 0
        }
        setupSunnyInitPosition()
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
        setupRainInitPosition()
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
    
    private func setupUI() {
        
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
        setupUI()
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
                self.addShowAnimationGes()
                
            default:
                self.colorView1.backgroundColor = self.colorModel.rainColors[2]
                self.colorView2.backgroundColor = self.colorModel.rainColors[0]
                self.colorView3.backgroundColor = self.colorModel.rainColors[1]
                self.colorContainerView1.backgroundColor = self.colorModel.rainColors[2]
                self.colorContainerView2.backgroundColor = self.colorModel.rainColors[0]
                self.colorContainerView3.backgroundColor = self.colorModel.rainColors[1]
                self.raindropImageView1.tintColor = self.colorModel.rainColors[2]
                self.raindropImageView2.tintColor = self.colorModel.rainColors[0]
                self.raindropImageView3.tintColor = self.colorModel.rainColors[1]
                self.goodWeather = false
                self.addShowAnimationGes()
            }
        }
    }
}
