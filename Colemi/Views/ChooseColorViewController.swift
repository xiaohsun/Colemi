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
    
    lazy var chooseColorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "選擇代表今日的顏色"
        label.textColor = .white
        label.font = UIFont(name: FontProperty.GenSenRoundedTW_B.rawValue, size: 24)
        
        return label
    }()
    
    //    lazy var weatherDescriptionLabel: UILabel = {
    //        let label = UILabel()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.numberOfLines = 0
    //        label.text = "今天是"
    //
    //        return label
    //    }()
    
    func createColorView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorTapped))
        view.addGestureRecognizer(tapGesture)
        view.tag = colorViews.count
        colorViews.append(view)
        
        return view
    }
    
    func createColorContainerViews() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        colorContainerViews.append(view)
        
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
    
    //    lazy var selectColorButton: UIButton = {
    //        let button = UIButton()
    //        button.setTitle("選擇", for: .normal)
    //        button.backgroundColor = .black
    //        button.addTarget(self, action: #selector(selectColorBtnTapped), for: .touchUpInside)
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
    //        button.backgroundColor = ThemeColorProperty.darkColor.getColor()
    //        return button
    //    }()
    
    lazy var checkIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.checkIcon
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
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
    // doing
    
    
    //    @objc private func selectColorBtnTapped() {
    //        if let selectedColor = selectedUIColor {
    //            // userManager.selectedColor = selectedColor.rgba
    //            userManager.selectedUIColor = selectedColor
    //            userManager.selectedHexColor = selectedColor.toHexString()
    //            navigationController?.popViewController(animated: true)
    //        }
    //    }
    
    lazy var colorView1 = createColorView()
    lazy var colorView2 = createColorView()
    lazy var colorView3 = createColorView()
    lazy var colorContainerView1 = createColorContainerViews()
    lazy var colorContainerView2 = createColorContainerViews()
    lazy var colorContainerView3 = createColorContainerViews()
    
    private func setUpUI() {
        
        view.backgroundColor = UIColor(hex: "#333333")
        
        view.addSubview(chooseColorLabel)
        // view.addSubview(weatherDescriptionLabel)
        // view.addSubview(selectColorButton)
        view.addSubview(colorContainerView1)
        view.addSubview(colorContainerView2)
        view.addSubview(colorContainerView3)
        view.addSubview(colorView1)
        view.addSubview(colorView2)
        view.addSubview(colorView3)
        view.addSubview(checkIconImageView)
        
        NSLayoutConstraint.activate([
            chooseColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chooseColorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            
            //            weatherDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //            weatherDescriptionLabel.topAnchor.constraint(equalTo: chooseColorLabel.bottomAnchor, constant: 50),
            
            colorContainerView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            colorContainerView1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorContainerView1.widthAnchor.constraint(equalTo: colorView1.widthAnchor, multiplier: 1.2),
            colorContainerView1.heightAnchor.constraint(equalTo: colorView1.widthAnchor, multiplier: 1.2),
            
            colorView1.centerXAnchor.constraint(equalTo: colorContainerView1.centerXAnchor),
            colorView1.centerYAnchor.constraint(equalTo: colorContainerView1.centerYAnchor),
            colorView1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            colorView1.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            colorContainerView2.topAnchor.constraint(equalTo: colorContainerView1.bottomAnchor, constant: 30),
            colorContainerView2.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80),
            colorContainerView2.widthAnchor.constraint(equalTo: colorView2.widthAnchor, multiplier: 1.2),
            colorContainerView2.heightAnchor.constraint(equalTo: colorView2.widthAnchor, multiplier: 1.2),
            
            colorView2.centerXAnchor.constraint(equalTo: colorContainerView2.centerXAnchor),
            colorView2.centerYAnchor.constraint(equalTo: colorContainerView2.centerYAnchor),
            colorView2.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            colorView2.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            colorContainerView3.topAnchor.constraint(equalTo: colorContainerView2.bottomAnchor, constant: 25),
            colorContainerView3.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60),
            colorContainerView3.widthAnchor.constraint(equalTo: colorView3.widthAnchor, multiplier: 1.2),
            colorContainerView3.heightAnchor.constraint(equalTo: colorView3.widthAnchor, multiplier: 1.2),
            
            colorView3.centerXAnchor.constraint(equalTo: colorContainerView3.centerXAnchor),
            colorView3.centerYAnchor.constraint(equalTo: colorContainerView3.centerYAnchor),
            colorView3.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            colorView3.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
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
            colorContainerViews[index].alpha = 0.3
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
            default:
                self.colorView1.backgroundColor = self.colorModel.rainColors[0]
                self.colorView2.backgroundColor = self.colorModel.rainColors[1]
                self.colorView3.backgroundColor = self.colorModel.rainColors[2]
                self.colorContainerView1.backgroundColor = self.colorModel.rainColors[0]
                self.colorContainerView2.backgroundColor = self.colorModel.rainColors[1]
                self.colorContainerView3.backgroundColor = self.colorModel.rainColors[2]
                self.goodWeather = false
                // self.weatherDescriptionLabel.text = "今天的天氣是 \(condition.description)"
            }
        }
    }
}
