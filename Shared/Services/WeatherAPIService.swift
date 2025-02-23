//
//  WeatherAPIService.swift
//  weather_info (iOS)
//
//  Created by vignesh on 22/02/25.
//

import Foundation

struct WeatherAPIService {
    func fetchCurrentWeather(for city: String) async throws -> Weather {
        let urlString = APIConstants.Endpoints.currentWeather(for: city)
        return try await NetworkManager.shared.fetchData(from: urlString, responseType: Weather.self)
    }
    
    func fetchForecastWeather(for location:String, days:Int) async throws -> ForecastWeather{
        let urlString = APIConstants.Endpoints.forecastWeather(for: location, days: days)


        return try await NetworkManager.shared.fetchData(from: urlString, responseType: ForecastWeather.self)
    }

}
