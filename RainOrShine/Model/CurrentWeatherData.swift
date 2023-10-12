//
//  CurrentWeatherData.swift
//  RainOrShine
//
//  Created by Yessenia Valencia-Juarez on 10/10/23.
//

import Foundation

struct CurrentWeatherData: Decodable {
    let weather: [Weather]
    let main: Main
    let name: String
    let dt: Int
}
struct Main: Decodable {
    let temp, tempMin, tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}
struct Weather: Decodable {
    let id: Int
    let description, icon: String
}

