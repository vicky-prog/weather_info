//
//  Forecast.swift
//  weather_info (iOS)
//
//  Created by vignesh on 23/02/25.
//

import Foundation

struct ForecastWeather: Codable {
   // let location: Location
    //let current: Current
    let forecast: Forecast
    //let alerts: Alerts
}




// MARK: - Air Quality
struct AirQuality: Codable {
    let co, no2, o3, so2, pm2_5, pm10: Double
    let us_epa_index, gb_defra_index: Int
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String
    //let date_epoch: Int
    //let day: Day
   // let astro: Astro
   // let hour: [Hour]
}

struct Day: Codable {
    let maxtemp_c, maxtemp_f, mintemp_c, mintemp_f: Double
    let avgtemp_c, avgtemp_f, maxwind_mph, maxwind_kph: Double
    let totalprecip_mm, totalprecip_in, avgvis_km, avgvis_miles: Double
    let avghumidity: Int
    let daily_will_it_rain, daily_chance_of_rain, daily_will_it_snow, daily_chance_of_snow: Int
    let condition: Condition
    let uv: Double
}

struct Astro: Codable {
    let sunrise, sunset, moonrise, moonset, moon_phase, moon_illumination: String
}

struct Hour: Codable {
    let time: String
    let time_epoch: Int
    let temp_c, temp_f: Double
    let is_day: Int
    let condition: Condition
    let wind_mph, wind_kph: Double
    let wind_degree: Int
    let wind_dir: String
    let pressure_mb, pressure_in: Double
    let precip_mm, precip_in: Double
    let humidity, cloud: Int
    let feelslike_c, feelslike_f, windchill_c, windchill_f: Double
    let heatindex_c, heatindex_f, dewpoint_c, dewpoint_f: Double
    let will_it_rain, chance_of_rain, will_it_snow, chance_of_snow: Int
    let vis_km, vis_miles, gust_mph, gust_kph, uv: Double
}

// MARK: - Alerts
struct Alerts: Codable {
    let alert: [Alert]
}

struct Alert: Codable {
    let headline, category, event, desc, effective, expires: String
}
