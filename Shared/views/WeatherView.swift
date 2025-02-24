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
    private let timer = Timer.publish(every: 300, on: .main, in: .common).autoconnect() // Auto-refresh every 5 mins

    var body: some View {
        ZStack {

            Image("background1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)


            VStack(alignment: .leading, spacing: 2) {
                if let weather = viewModel.weather {
                    headerView(weather: weather)
                    weatherDetails(weather: weather)
                    Spacer()
                    if isRefreshing {
                        // Shimmer placeholder during refresh (horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(0..<3, id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 100, height: 100) // Adjusted for card-like appearance
                                        .shimmering() // ✨ Shimmer effect
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 20)
                    } else {
                        // Actual Forecast View
                        ForecastWeatherView(forecastDays: viewModel.forecastWeather?.forecast.forecastday ?? [])
                            .padding(.trailing, -16)
                    }



                } else if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
                } else {
                    ProgressView("Fetching Weather...")
                        .task {
                            
                            triggerBackgroundRefresh()
                        }
                }
            }
            .padding(.horizontal)
            .onReceive(timer) { _ in
               
                Task {
                  
                    triggerBackgroundRefresh()
                   
                }
            }
        }
    }

    // MARK: - Header View
    private func headerView(weather: Weather) -> some View {
        HStack {
            Text("🌍 \(weather.location.name), \(weather.location.country)")
                .foregroundColor(.white)
                .padding(.top, UIScreen.main.bounds.height * 0.04)

            Spacer()

//            Button(action: {
//
//                Task {
//                    await refreshWeather()
//
//                }
//            }) {
//                Image(systemName: "arrow.clockwise")
//                    .foregroundColor(.white)
//                    .font(.system(size: 24))
//                    .padding(.top, UIScreen.main.bounds.height * 0.02)
//            }
        }
    }

    // MARK: - Weather Details View
    private func weatherDetails(weather: Weather) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Today, \(formattedDate())")
                .font(.system(size: 13))
                .foregroundColor(.white)
                .padding(.top, 15)

            HStack(alignment: .top, spacing: 2) {
                Text("\(weather.current.temp_c, specifier: "%.1f")")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundStyle(LinearGradient(colors: [.white, .orange], startPoint: .top, endPoint: .bottom))
                    .minimumScaleFactor(0.5) // Ensures text shrinks if needed

                Text("°C")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                    .padding(.top, 6)
            }
            .padding(.top, UIScreen.main.bounds.height * 0.02)

            Text(weather.current.condition.text)
                .foregroundColor(.white)
                .font(.headline)
        }
    }

    // MARK: - Error View
    private func errorView(message: String) -> some View {
        VStack {
            Text("⚠️ \(message)")
                .foregroundColor(.red)
                .padding()

            Button("Retry") {
                Task { triggerBackgroundRefresh() }
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(10)
        }
    }
    
    // MARK: - Refresh Weather (Background)
    func triggerBackgroundRefresh() {
        isRefreshing = true
        Task(priority: .background) {
            await refreshWeather()
            isRefreshing = false
        }
    }


    // MARK: - Refresh Weather (Concurrent)
    @MainActor
    func refreshWeather() async {
        do {
            try await withThrowingTaskGroup(of: Void.self) { group in
                group.addTask {
                    try await viewModel.loadWeather(for: "Bangalore")
                }
                group.addTask {
                    try await viewModel.loadForecastWeather(for: "Bangalore", days: 14)
                }
                try await group.waitForAll() // Wait for all tasks concurrently
            }
        } catch is CancellationError {
            print("⚠️ Task was cancelled.")
        } catch {
            print("⚠️ First-launch error: \(error.localizedDescription)")
            viewModel.errorMessage = "Something went wrong: \(error.localizedDescription)"
        }
    }
}

// MARK: - Preview
struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}

// MARK: - Date Formatter
private func formattedDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM dd h:mm a"
    return formatter.string(from: Date())
}

