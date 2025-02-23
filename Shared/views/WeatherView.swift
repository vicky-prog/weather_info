//
//  WeatherView.swift
//  weather_info (iOS)
//
//  Created by vignesh on 22/02/25.
//



import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var isRefreshing = false

    var body: some View {
        ZStack {
            Image("background1")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 2) {
                if let weather = viewModel.weather {
                    HStack {
                        Text("🌍 \(weather.location.name), \(weather.location.country)")
                            .foregroundColor(.white)
                            .padding(.top, 20)

                        Spacer()

                        Button(action: {
                            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                                isRefreshing = true
                            }
                            Task {
                                await viewModel.loadWeather(for: "Bangalore")
                                await viewModel.loadForecastWeather(for: "Bangalore", days: 14)
                                isRefreshing = false
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                                .padding(.top, 20)
                                .rotationEffect(.degrees(isRefreshing ? 360 : 0)) // Only the icon rotates
                                .animation(
                                    isRefreshing ?
                                        .linear(duration: 1).repeatForever(autoreverses: false) : .default,
                                    value: isRefreshing
                                )
                        }              }

                    Text("Today, \(formattedDate())")
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                        .padding(.top, 15)

                    HStack(alignment: .top, spacing: 2) {
                        Text("\(weather.current.temp_c, specifier: "%.1f")")
                            .font(.system(size: 64, weight: .bold))
                            .foregroundStyle(LinearGradient(colors: [.white, .orange], startPoint: .top, endPoint: .bottom))

                        Text("°C")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .foregroundStyle(LinearGradient(colors: [.white, .orange], startPoint: .top, endPoint: .bottom))
                            .padding(.top, 6)
                    }
                    .padding(.top, 20)

                    HStack {
                        Text(weather.current.condition.text)
                            .foregroundColor(.white)
                            .font(.headline)
                    }

                    Spacer()

                    ForecastWeatherView(forecastDays: viewModel.forecastWeather?.forecast.forecastday ?? [])
                        .padding(.trailing, -16)
                } else if let errorMessage = viewModel.errorMessage {
                    Text("⚠️ \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    ProgressView("Fetching Weather...")
                        .task {
                            await viewModel.loadWeather(for: "Bangalore")
                            await viewModel.loadForecastWeather(for: "Bangalore", days: 14)
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
    formatter.dateFormat = "MMM dd h:mm a"
    return formatter.string(from: Date())
}
