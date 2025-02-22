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
        VStack {
            if let weather = viewModel.weather {
                Text("🌍 \(weather.location.name), \(weather.location.country)")
                    .font(.title)
                    .padding()

                Text("🌡 \(weather.current.temp_c, specifier: "%.1f")°C | \(weather.current.temp_f, specifier: "%.1f")°F")
                    .font(.largeTitle)
                    .bold()

                Text(weather.current.condition.text)
                    .font(.headline)
                    .padding()

                AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
                    image.resizable().frame(width: 100, height: 100)
                } placeholder: {
                    ProgressView()
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text("⚠️ \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                ProgressView("Fetching Weather...")
                    .task {
                        await viewModel.loadWeather(for: "Bangalore")
                    }
            }
        }
        .padding()
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
