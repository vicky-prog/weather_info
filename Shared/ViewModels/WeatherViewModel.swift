//
//  WeatherViewModel.swift
//  weather_info (iOS)
//
//  Created by vignesh on 22/02/25.
//

import Foundation

@MainActor
final class WeatherViewModel:ObservableObject{
    
    @Published var weather: Weather?
    @Published var errorMessage: String?
    
    private let weatherService = WeatherAPIService()
    
    func loadWeather(for city:String)async{
        do{
            weather = try await weatherService.fetchCurrentWeather(for:city)
        }catch{
            errorMessage = error.localizedDescription
        }
      
    }
    
}
