//
//  ForecastWeatherView.swift
//  weather_info (iOS)
//
//  Created by vignesh on 23/02/25.
//

import SwiftUI

struct ForecastWeatherView: View {
    let forecastDays: [ForecastDay]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(forecastDays, id: \.date) { day in
                    ForecastCardView(day: day)
                }
            }
            .padding()
        }
    }
}

struct ForecastCardView: View {
    let day: ForecastDay

    var body: some View {
        VStack(spacing: 10) {
            Text(formattedDate(from: day.date))
                .font(.headline)
                .foregroundColor(.primary)

            AsyncImage(url: URL(string: "https:\(day.day.condition.icon)")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            } placeholder: {
                ProgressView()
            }

            Text(day.day.condition.text)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("🌡️ \(day.day.avgtemp_c, specifier: "%.1f")°C")
                .font(.title2)
                .bold()

            Text("💨 \(day.day.maxwind_kph, specifier: "%.1f") km/h")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(16)
        .shadow(radius: 4)
        .frame(width: 140)
    }

    private func formattedDate(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "EEE, MMM d"
            return formatter.string(from: date)
        }
        return dateString
    }
}

