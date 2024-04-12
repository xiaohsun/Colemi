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
    let locationManager = CLLocationManager()
    
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
        return view
    }
    
    lazy var color1 = createColorView()
    lazy var color2 = createColorView()
    lazy var color3 = createColorView()
    
    private func setUpUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(chooseColorLabel)
        view.addSubview(weatherDescriptionLabel)
        view.addSubview(color1)
        view.addSubview(color2)
        view.addSubview(color3)
        
        NSLayoutConstraint.activate([
            chooseColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chooseColorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            weatherDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherDescriptionLabel.topAnchor.constraint(equalTo: chooseColorLabel.bottomAnchor, constant: 50),
            
            color1.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 50),
            color1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            color1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            color1.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            color2.topAnchor.constraint(equalTo: color1.bottomAnchor, constant: 50),
            color2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            color2.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            color2.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            color3.topAnchor.constraint(equalTo: color2.bottomAnchor, constant: 50),
            color3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            color3.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            color3.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3)
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
                self.color1.backgroundColor = .red
                self.color2.backgroundColor = .yellow
                self.color3.backgroundColor = .green
                self.weatherDescriptionLabel.text = "今天的天氣是 \(condition.description)"
            default:
                self.color1.backgroundColor = .black
                self.color2.backgroundColor = .lightGray
                self.color3.backgroundColor = .gray
                self.weatherDescriptionLabel.text = "今天的天氣是 \(condition.description)"
            }
        }
    }
}
