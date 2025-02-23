//
//  APIConstants.swift .swift
//  weather_info (iOS)
//
//  Created by vignesh on 22/02/25.
//

import Foundation

struct APIConstants {
    static let baseURL = "https://api.weatherapi.com/v1"
    static let apiKey = "28b9bb265a6d4cd4a9055150252202"
    
    struct Endpoints{
      static   func currentWeather(for city:String)->String{
            return "\(baseURL)/current.json?key=\(apiKey)&q=\(city)"
        }
        
        static func forecastWeather(for location: String, days: Int) -> String {
            return "\(baseURL)/forecast.json?key=\(apiKey)&q=\(location)&days=\(days)"
        }

    }
}
