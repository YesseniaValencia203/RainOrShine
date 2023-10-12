//
//  CurrentWeatherForecastData.swift
//  RainOrShine
//
//  Created by Yessenia Valencia-Juarez on 10/10/23.
//

import Foundation

struct CurrentWeatherForecastData: Decodable {
    let list: [ForecastList]
    let city: City
}
struct City: Decodable {
    let coord: Coord
}
struct ForecastList: Decodable {
    let main: MainClass
    let weather: [ForecastWeather]
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case main, weather
        case dtTxt = "dt_txt"
    }
}
struct Coord: Decodable {
    let lat, lon: Double
}
struct MainClass: Decodable {
    let tempMin, tempMax: Double
    enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}
struct ForecastWeather: Decodable {
    let id: Int
    let description, icon: String
}
