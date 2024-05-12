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
        
//        if let forecastTest = try? await WeatherService().weather(for: location, including: .daily, .current, .hourly) {
//            print(forecastTest.0.forecast[0].date)
//            print("daily")
//            print(forecastTest.1)
//            print("current")
//            print(forecastTest.2)
//            print("hourly")
//        }
        
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
            } else {
                delegate?.passWeatherCondition(WeatherCondition.clear)
            }
        } else {
            delegate?.passWeatherCondition(WeatherCondition.clear)
        }
    }
    
    func updateUserData(colorToday: String, colorSetToday: [String], docID: String) async {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.users.ref
        
        firestoreManager.updateDocument(data: [UserProperty.colorToday.rawValue: colorToday], collection: ref, docID: docID)
        
        firestoreManager.updateDocument(data: [UserProperty.colorSetToday.rawValue: colorSetToday], collection: ref, docID: docID)
    }
}

protocol ChooseColorViewModelDelegate: AnyObject {
    func passWeatherCondition(_ condition: WeatherCondition)
}
