//
//  WeatherView.swift
//  weather_info (iOS)
//
//  Created by vignesh on 22/02/25.
//

import SwiftUI

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        ZStack{
            
            Image("background1")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        VStack(alignment:.leading,spacing: 2) {
            if let weather = viewModel.weather {
                Text("🌍 \(weather.location.name), \(weather.location.country)")
                    .foregroundColor(.white)
                    //.font(.title)
                    .padding(.top,20)
                Text("Today, \(formattedDate())")
                    .font(.system(size: 13))
                     .foregroundColor(.white)
                     .padding(.top, 15)
                HStack(alignment: .top, spacing: 2) {
                    Text("\(weather.current.temp_c, specifier: "%.1f")")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.white)
                    Text("°C")
                        .foregroundColor(.white)
                        .font(.system(size: 24)) // Smaller °C
                        .padding(.top, 6) // Push °C slightly to the top
                     
                }
                .padding(.top, 20)
                HStack{
//                    AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
//                        image.resizable().frame(width: 100, height: 100)
//                    } placeholder: {
//                        ProgressView()
//                    }
                    Text(weather.current.condition.text)
                        .foregroundColor(.white)
                        .font(.headline)
                        //.padding()
                  
                }
              
                Spacer()
               

               

              
                Button("Upcoming Days") {
                    Task {
                        await viewModel.loadForecastWeather(for: "Bangalore", days:14)
                        print(viewModel.forecastWeather?.forecast.forecastday ?? "empty")
                    }
                }

                ForecastWeatherView(forecastDays: viewModel.forecastWeather?.forecast.forecastday ?? [])



            } else if let errorMessage = viewModel.errorMessage {
                Text("⚠️ \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                ProgressView("Fetching Weather...")
                    .task {
                        await viewModel.loadWeather(for: "Bangalore")
                        await viewModel.loadForecastWeather(for: "Bangalore", days:14)
                    }
            }
        }
        .padding(.horizontal)
        }
        
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}

private func formattedDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM dd h:mm a" // Example: Feb 23, 5:30 PM
    return formatter.string(from: Date())
}
