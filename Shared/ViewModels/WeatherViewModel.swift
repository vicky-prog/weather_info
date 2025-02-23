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
    @Published var forecastWeather: ForecastWeather?
    
    private let weatherService = WeatherAPIService()
    
    func loadWeather(for city:String)async{
        do{
            weather = try await weatherService.fetchCurrentWeather(for:city)
        }catch{
            errorMessage = error.localizedDescription
        }
      
    }
    
    @MainActor
    func loadForecastWeather(for location:String, days:Int)async{
      
        do {
            forecastWeather = try await weatherService.fetchForecastWeather(for: location, days: days)
            print("✅ Forecast fetched for \(location) with \(forecastWeather?.forecast.forecastday.count ?? 0) days.")
        } catch let error as NetworkError {
            switch error {
            case .invalidURL:
                print("🚫 Invalid URL.")
            case .noData:
                print("🚫 No data received.")
            case .decodingError:
                print("🚫 Decoding failed. Check your model structure.")
            case .serverError(let message):
                print("🚫 Server error: \(message)")
            }
        } catch {
            print("⚠️ Unexpected error: \(error.localizedDescription)")
        }

    }
    
}
