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
    var goodWeather = true
    var selectedUIColor: UIColor?
    
    lazy var chooseColorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "請選擇顏色"
        
        return label
    }()
    
    lazy var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "今天是"
        
        return label
    }()
    
    func createColorView() -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorTapped))
        view.addGestureRecognizer(tapGesture)
        view.tag = colorViews.count
        view.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        colorViews.append(view)
        
        return view
    }
    
    @objc private func colorTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        
        if goodWeather {
            selectedUIColor = colorModel.sunnyColors[index]
        } else {
            selectedUIColor = colorModel.rainColors[index]
        }
    }
    
    lazy var selectColorButton: UIButton = {
        let button = UIButton()
        button.setTitle("選擇", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(selectColorBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        button.backgroundColor = ThemeColorProperty.darkColor.getColor()
        return button
    }()
    
    @objc private func selectColorBtnTapped() {
        if let selectedColor = selectedUIColor {
            // userManager.selectedColor = selectedColor.rgba
            userManager.selectedUIColor = selectedColor
            userManager.selectedHexColor = selectedColor.toHexString()
            navigationController?.popViewController(animated: true)
        }
    }
                                                
    lazy var colorView1 = createColorView()
    lazy var colorView2 = createColorView()
    lazy var colorView3 = createColorView()
    
    private func setUpUI() {
        
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        
        view.addSubview(chooseColorLabel)
        view.addSubview(weatherDescriptionLabel)
        view.addSubview(colorView1)
        view.addSubview(colorView2)
        view.addSubview(colorView3)
        view.addSubview(selectColorButton)
        
        NSLayoutConstraint.activate([
            chooseColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chooseColorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            weatherDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherDescriptionLabel.topAnchor.constraint(equalTo: chooseColorLabel.bottomAnchor, constant: 50),
            
            colorView1.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 30),
            colorView1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorView1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            colorView1.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            colorView2.topAnchor.constraint(equalTo: colorView1.bottomAnchor, constant: 30),
            colorView2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorView2.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            colorView2.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            colorView3.topAnchor.constraint(equalTo: colorView2.bottomAnchor, constant: 30),
            colorView3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorView3.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            colorView3.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            selectColorButton.heightAnchor.constraint(equalToConstant: 50),
            selectColorButton.widthAnchor.constraint(equalToConstant: 100),
            selectColorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130),
            selectColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
                self.goodWeather = true
                self.weatherDescriptionLabel.text = "今天的天氣是 \(condition.description)"
                // self.weatherDescriptionLabel.text = "天氣晴，適合什麼樣的顏色呢？"
            default:
                self.colorView1.backgroundColor = self.colorModel.rainColors[0]
                self.colorView2.backgroundColor = self.colorModel.rainColors[1]
                self.colorView3.backgroundColor = self.colorModel.rainColors[2]
                self.goodWeather = false
                self.weatherDescriptionLabel.text = "今天的天氣是 \(condition.description)"
            }
        }
    }
}
