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
    
    let chooseColorViewModel = ChooseColorViewModel()
    let colorModel = ColorModel()
    let userManager = UserManager.shared
    let locationManager = CLLocationManager()
    var colorViews: [UIView] = []
    var colorContainerViews: [UIView] = []
    var goodWeather = true
    var selectedUIColor: UIColor?
    
    var colorView1XCons: NSLayoutConstraint?
    var colorView1YCons: NSLayoutConstraint?
    var colorView2XCons: NSLayoutConstraint?
    var colorView2YCons: NSLayoutConstraint?
    var colorView3XCons: NSLayoutConstraint?
    var colorView3YCons: NSLayoutConstraint?
    var colorView2WidthCons: NSLayoutConstraint?
    var colorView2HeightCons: NSLayoutConstraint?
    var raindropView1TopCons: NSLayoutConstraint?
    var raindropView2TopCons: NSLayoutConstraint?
    var raindropView3TopCons: NSLayoutConstraint?
    
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
    
    func createColorView() -> UIView {
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
    
    func createRaindropImageView() -> UIView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.raindropIcon.withRenderingMode(.alwaysTemplate)
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
        if let selectedColor = selectedUIColor {
            // userManager.selectedColor = selectedColor.rgba
            userManager.selectedUIColor = selectedColor
            userManager.selectedHexColor = selectedColor.toHexString()
            navigationController?.popViewController(animated: true)
        }
    }
    
    // 下雨天最初的位置
    private func setUpRainInitPosition() {
        
        colorView1XCons = colorView1.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -10)
        colorView1YCons = colorView1.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -650)
        
        colorView1XCons?.isActive = true
        colorView1YCons?.isActive = true
        
        colorView2XCons = colorView2.centerXAnchor.constraint(equalTo: colorView1.centerXAnchor, constant: -30)
        colorView2YCons = colorView2.centerYAnchor.constraint(equalTo: colorView1.centerYAnchor, constant: 60)
        colorView2WidthCons = colorView2.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35)
        colorView2HeightCons = colorView2.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35)
        
        colorView2XCons?.isActive = true
        colorView2YCons?.isActive = true
        colorView2WidthCons?.isActive = true
        colorView2HeightCons?.isActive = true
        
        colorView3XCons = colorView3.centerXAnchor.constraint(equalTo: colorView1.centerXAnchor, constant: 60)
        colorView3YCons = colorView3.centerYAnchor.constraint(equalTo: colorView1.centerYAnchor, constant: 50)
        
        colorView3XCons?.isActive = true
        colorView3YCons?.isActive = true
        
        raindropView1TopCons = raindropImageView1.topAnchor.constraint(equalTo: colorView1.bottomAnchor, constant: -100)
        raindropView2TopCons = raindropImageView2.topAnchor.constraint(equalTo: colorView2.bottomAnchor, constant: -90)
        raindropView3TopCons = raindropImageView3.topAnchor.constraint(equalTo: colorView3.bottomAnchor, constant: -100)
        
        raindropView1TopCons?.isActive = true
        raindropView2TopCons?.isActive = true
        raindropView3TopCons?.isActive = true
    }
    
    private func rainAnimation() {
                    for colorView in self.colorViews {
                        colorView.alpha = 1
                    }
        
        self.colorView1YCons?.constant = -250
        
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
        view.addSubview(colorContainerView1)
        view.addSubview(colorContainerView2)
        view.addSubview(colorContainerView3)
        view.addSubview(colorView2)
        view.addSubview(raindropImageView2)
        view.addSubview(colorView3)
        view.addSubview(colorView1)
        view.addSubview(raindropImageView1)
        view.addSubview(raindropImageView3)
        view.addSubview(checkIconImageView)
        
        setUpRainInitPosition()
        
        NSLayoutConstraint.activate([
            chooseColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chooseColorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            
            colorContainerView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            colorContainerView1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorContainerView1.widthAnchor.constraint(equalTo: colorView1.widthAnchor, multiplier: 1.2),
            colorContainerView1.heightAnchor.constraint(equalTo: colorView1.widthAnchor, multiplier: 1.2),
            
            colorView1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            colorView1.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            colorContainerView2.topAnchor.constraint(equalTo: colorContainerView1.bottomAnchor, constant: 30),
            colorContainerView2.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80),
            colorContainerView2.widthAnchor.constraint(equalTo: colorView2.widthAnchor, multiplier: 1.2),
            colorContainerView2.heightAnchor.constraint(equalTo: colorView2.widthAnchor, multiplier: 1.2),
            
            colorContainerView3.topAnchor.constraint(equalTo: colorContainerView2.bottomAnchor, constant: 25),
            colorContainerView3.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60),
            colorContainerView3.widthAnchor.constraint(equalTo: colorView3.widthAnchor, multiplier: 1.2),
            colorContainerView3.heightAnchor.constraint(equalTo: colorView3.widthAnchor, multiplier: 1.2),
            
            colorView3.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            colorView3.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
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
            checkIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseColorViewModel.delegate = self
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
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
        if let location = locations.last {
            Task.init {
                await chooseColorViewModel.currentWeather(for: location)
            }
        }
    }
}

extension ChooseColorViewController: ChooseColorViewModelDelegate {
    func passWeatherCondition(_ condition: WeatherCondition) {
        DispatchQueue.main.async {
            switch condition {
            case .partlyCloudy, .cloudy, .clear, .hot, .mostlyCloudy, .mostlyClear, .sunFlurries :
                self.colorView1.backgroundColor = self.colorModel.sunnyColors[0]
                self.colorView2.backgroundColor = self.colorModel.sunnyColors[1]
                self.colorView3.backgroundColor = self.colorModel.sunnyColors[2]
                self.colorContainerView1.backgroundColor = self.colorModel.sunnyColors[0]
                self.colorContainerView2.backgroundColor = self.colorModel.sunnyColors[1]
                self.colorContainerView3.backgroundColor = self.colorModel.sunnyColors[2]
                self.goodWeather = true
                // self.weatherDescriptionLabel.text = "今天的天氣是 \(condition.description)"
                // self.weatherDescriptionLabel.text = "天氣晴，適合什麼樣的顏色呢？"
                
                // 暫時測試
                self.raindropImageView1.tintColor = self.colorModel.sunnyColors[0]
                self.raindropImageView2.tintColor = self.colorModel.sunnyColors[1]
                self.raindropImageView3.tintColor = self.colorModel.sunnyColors[2]
                
                self.rainAnimation()
                
            default:
                self.colorView1.backgroundColor = self.colorModel.rainColors[0]
                self.colorView2.backgroundColor = self.colorModel.rainColors[1]
                self.colorView3.backgroundColor = self.colorModel.rainColors[2]
                self.colorContainerView1.backgroundColor = self.colorModel.rainColors[0]
                self.colorContainerView2.backgroundColor = self.colorModel.rainColors[1]
                self.colorContainerView3.backgroundColor = self.colorModel.rainColors[2]
                self.goodWeather = false
                // self.weatherDescriptionLabel.text = "今天的天氣是 \(condition.description)"
                self.raindropImageView1.tintColor = self.colorModel.rainColors[0]
                self.raindropImageView2.tintColor = self.colorModel.rainColors[1]
                self.raindropImageView3.tintColor = self.colorModel.rainColors[2]
                
                self.rainAnimation()
            }
        }
    }
}
