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
    
    let locationManager = CLLocationManager()
    
    lazy var chooseColorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "請選擇顏色"
        
        return label
    }()
    
    private func setUpUI() {
        view.backgroundColor = .white
        
        view.addSubview(chooseColorLabel)
        
        NSLayoutConstraint.activate([
            chooseColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chooseColorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        

        setUpUI()
    }
    
    func currentWeather(for location: CLLocation) async {
        if let forecast = try? await WeatherService().weather(for: location).dailyForecast.forecast {
            print("//////forecast////////")
            print(forecast)
            if let today = forecast.first {
                print("//////today////////")
                print(today)
                print("//////condition////////")
                print(today.condition)
            }
        }
    }
}

extension ChooseColorViewController: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            Task.init {
                await self.currentWeather(for: location)
            }
        }
    }
}
