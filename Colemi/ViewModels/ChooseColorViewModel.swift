//
//  ChooseColorViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/12/24.
//

import Foundation
import CoreLocation
import WeatherKit

class ChooseColorViewModel {
    weak var delegate: ChooseColorViewModelDelegate?
    
    func currentWeather(for location: CLLocation) async {
        
        if let forecast = try? await WeatherService().weather(for: location).dailyForecast.forecast {
             // print("//////forecast////////")
             // print(forecast[0])
            
            if let today = forecast.first {
                 // print("//////today////////")
                 print(today)
                 // print("//////condition////////")
                 // print(today.condition)
                delegate?.passWeatherCondition(today.condition)
                // print(WeatherCondition.allCases)
                // print(today.symbolName)
            }
        }
    }
}

protocol ChooseColorViewModelDelegate: AnyObject {
    func passWeatherCondition(_ condition: WeatherCondition)
}
