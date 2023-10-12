//
//  Constants.swift
//  RainOrShine
//
//  Created by Yessenia Valencia-Juarez on 10/11/23.
//

import Foundation

struct APIEndpoints {
    static func getCurrentWeatherInformation(latitude: String, longitude: String) -> String {
        let apiKey = "8027cbf7b09f62163422fcddb35bd538"
        let weatherEndpoint = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial"
        return weatherEndpoint
    }
    static func getCurrentWeatherForecast(cityName: String) -> String {
        let apiKey = "8027cbf7b09f62163422fcddb35bd538"
        let weatherEndpoint = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(apiKey)&units=imperial"
        return weatherEndpoint
    }
    static func getCurrentWeatherForecastInformation(latitude: String, longitude: String) -> String {
        let apiKey = "8027cbf7b09f62163422fcddb35bd538"
        let weatherEndpoint = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial"
        return weatherEndpoint
    }
    static func getWeatherIconImage(icon: String) -> String {
        let imageEndpoint = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        return imageEndpoint
    }
}
struct WeatherDate {
    let date: Date
    let dateString: String
    let timeString: String
    let dayOfWeek: String
    init(dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.date = dateFormatter.date(from:dateString)!
        self.timeString = date.formatted(date: Date.FormatStyle.DateStyle.omitted, time: Date.FormatStyle.TimeStyle.shortened)
        self.dateString = date.formatted(date: Date.FormatStyle.DateStyle.numeric, time: Date.FormatStyle.TimeStyle.omitted)
        self.dayOfWeek = date.formatted(date: Date.FormatStyle.DateStyle.complete, time: Date.FormatStyle.TimeStyle.omitted)
    }
    static func getCellDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let fullDate = dateFormatter.date(from: date) else { return "" }
        let dateString = fullDate.formatted(date: Date.FormatStyle.DateStyle.complete, time: Date.FormatStyle.TimeStyle.omitted)
        let dateSplit = dateString.split(separator: ",", maxSplits: 1)
        let betterString = "\(dateSplit[0])"
        return betterString
    }
    static func getCurrentDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let fullDate = dateFormatter.date(from: date) else { return "" }
        let dateString = fullDate.formatted(date: Date.FormatStyle.DateStyle.complete, time: Date.FormatStyle.TimeStyle.omitted)
        return dateString
    }
}
