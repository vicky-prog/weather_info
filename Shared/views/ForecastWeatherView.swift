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
        VStack(alignment:.leading, spacing: 10) {
            Text(formattedDate(from: day.date))
                .font(.system(size: 12))
                .foregroundColor(.white)
            HStack{
                AsyncImage(url: URL(string: "https:\(day.day.condition.icon)")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                } placeholder: {
                    ProgressView()
                }
                
                Text(day.day.condition.text)
                    .font(.system(size: 13))
                    .foregroundColor(.white)
            }

          

            HStack(alignment:.top){
                Text("\(day.day.avgtemp_c, specifier: "%.1f")")
                    .font(.system(size: 20,weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 5)
                   
                Text("°C")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .padding(.top,6)
            }
           

//            Text("💨 \(day.day.maxwind_kph, specifier: "%.1f") km/h")
//                .font(.footnote)
//                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(16)
        .shadow(radius: 4)
       // .frame(width: )
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

