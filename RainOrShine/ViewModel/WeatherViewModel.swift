//
//  WeatherViewModel.swift
//  RainOrShine
//
//  Created by Yessenia Valencia-Juarez on 10/10/23.
//

import Foundation
import SwiftUI

protocol WeatherObservable {
    func getCurrentWeather(weatherString: String) async
    func getWeatherForecast(weatherString: String) async
    func getWeatherIconData(iconEndpoint: String) async  -> UIImage
}
@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var currentWeatherInformation: CurrentWeatherInfo?
    @Published var currentWeatherForecastInformation: CurrentWeatherForecastData?
    @Published var currentWeatherForecast: [ForecastInfo]?
    @Published var currentWeatherIcon: UIImage?
    @Published var apiError: APIError?
    
    private let networkManager: NetworkManaging
    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
}
extension WeatherViewModel: WeatherObservable {
    func getCurrentWeather(weatherString: String) async  {
        guard let weatherURL = URL(string: weatherString) else {
            apiError = .badRequestError
            return
        }
        do {
            let data = try await self.networkManager.getWeatherData(url: weatherURL)
            let weather = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
            let iconPng = weather.weather[0].icon
            let iconImage = await getWeatherIconData(iconEndpoint: APIEndpoints.getWeatherIconImage(icon: iconPng))
            self.currentWeatherIcon = iconImage
            let info = CurrentWeatherInfo(cityName: weather.name, temp: Int(weather.main.temp), tempMin: Int(weather.main.tempMin), tempMax: Int(weather.main.tempMax), description: weather.weather[0].description.localizedCapitalized, icon: weather.weather[0].icon, iconImage: iconImage)
            self.currentWeatherInformation = info
        } catch {
            print(error.localizedDescription)
            handleError(error: error)
        }
        
    }
    func getWeatherIconData(iconEndpoint: String) async  -> UIImage {
        var icon = UIImage(systemName: "cloud")!
        guard let imageURL = URL(string: iconEndpoint) else { return icon }
        do {
            let iconData = try await networkManager.getWeatherData(url: imageURL)
            guard let iconImage = UIImage(data: iconData) else { return icon }
            icon = iconImage
        } catch {
            print(error.localizedDescription)
            handleError(error: error)
        }
        return icon
    }
    func getWeatherForecast(weatherString: String) async {
        guard let weatherURL = URL(string: weatherString) else { return }
        do {
            let data = try await self.networkManager.getWeatherData(url: weatherURL)
            let weather = try JSONDecoder().decode(CurrentWeatherForecastData.self, from: data)
            var allWeatherInfo = [ForecastInfo]()
            _ = weather.list.map( { forecastList in
                let dateString = WeatherDate(dateString: forecastList.dtTxt).dateString
                for w in forecastList.weather {
                    allWeatherInfo.append(ForecastInfo(date: dateString, tempMax: Int(forecastList.main.tempMax), tempMin: Int(forecastList.main.tempMin), icon: w.icon))
                }
            })
            let dataGroup = Dictionary(grouping: allWeatherInfo, by: {$0.date})

            var tmpList = [ForecastInfo]()
            for d in dataGroup {
                let date = d.key
                let icon = d.value.randomElement()?.icon ?? d.value[0].icon
                let iconImage = await getWeatherIconData(iconEndpoint: APIEndpoints.getWeatherIconImage(icon: icon))
                let tempMin = d.value.compactMap { $0.tempMin }.min() ?? Int(d.value[0].tempMin)
                let tempMax = d.value.compactMap { $0.tempMax }.max() ?? Int(d.value[0].tempMax)
                tmpList.append(ForecastInfo(date: date, tempMax: tempMax, tempMin: tempMin, icon: icon, iconImage: iconImage))
            }
            self.currentWeatherForecast = tmpList.sorted(by: {$0.date < $1.date})
            self.currentWeatherForecastInformation = weather

        } catch {
            print(error.localizedDescription)
            handleError(error: error)
        }
        
    }
    func getWeatherForCity(cityName: String) async -> (Double, Double)? {
        guard let cityWeatherURL = URL(string: cityName) else { return nil }
        var lat: Double?
        var lon: Double?
        do {
            let data = try await self.networkManager.getWeatherData(url: cityWeatherURL)
            let weather = try JSONDecoder().decode(CurrentWeatherForecastData.self, from: data)
            var allWeatherInfo = [ForecastInfo]()
            lat = weather.city.coord.lat
            lon = weather.city.coord.lon
            _ = weather.list.map( { forecastList in
                let dateString = WeatherDate(dateString: forecastList.dtTxt).dateString
                for w in forecastList.weather {
                    allWeatherInfo.append(ForecastInfo(date: dateString, tempMax: Int(forecastList.main.tempMax), tempMin: Int(forecastList.main.tempMin), icon: w.icon))
                }
            })
            let dataGroup = Dictionary(grouping: allWeatherInfo, by: {$0.date})

            var tmpList = [ForecastInfo]()
            for d in dataGroup {
                let date = d.key
                let icon = d.value.randomElement()?.icon ?? d.value[0].icon
                let iconImage = await getWeatherIconData(iconEndpoint: APIEndpoints.getWeatherIconImage(icon: icon))
                let tempMin = d.value.compactMap { $0.tempMin }.min() ?? Int(d.value[0].tempMin)
                let tempMax = d.value.compactMap { $0.tempMax }.max() ?? Int(d.value[0].tempMax)
                tmpList.append(ForecastInfo(date: date, tempMax: tempMax, tempMin: tempMin, icon: icon, iconImage: iconImage))
            }
            self.currentWeatherForecast = tmpList.sorted(by: {$0.date < $1.date})
            self.currentWeatherForecastInformation = weather

        } catch {
            print(error.localizedDescription)
            handleError(error: error)
        }
        guard let latitude = lat,
              let longitude = lon else { return nil }
        guard let weatherURL = URL(string: APIEndpoints.getCurrentWeatherInformation(latitude: "\(latitude)", longitude: "\(longitude)")) else {
            apiError = .badRequestError
            return nil
        }
        do {
            let data = try await self.networkManager.getWeatherData(url: weatherURL)
            let weather = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
            let iconPng = weather.weather[0].icon
            let iconImage = await getWeatherIconData(iconEndpoint: APIEndpoints.getWeatherIconImage(icon: iconPng))
            self.currentWeatherIcon = iconImage
            let info = CurrentWeatherInfo(cityName: weather.name, temp: Int(weather.main.temp), tempMin: Int(weather.main.tempMin), tempMax: Int(weather.main.tempMax), description: weather.weather[0].description.localizedCapitalized, icon: weather.weather[0].icon, iconImage: iconImage)
            self.currentWeatherInformation = info
        } catch {
            print(error.localizedDescription)
            handleError(error: error)
        }
        return (latitude, longitude)
        
    }
    func handleError(error: Error){
        switch error {
        case is DecodingError:
            apiError = .parsingError
        case is URLError:
            apiError = .badRequestError
        case APIError.dataNotFoundError:
            apiError = .dataNotFoundError
        default:
            apiError = .dataNotFoundError
        }
    }
}
struct CurrentWeatherInfo {
    let tempMax: Int
    let tempMin: Int
    let temp: Int
    let cityName: String
    let description: String
    let icon: String
    let iconImage: UIImage?
    init(cityName: String, temp: Int, tempMin: Int, tempMax: Int, description: String, icon: String, iconImage: UIImage? = nil) {
        self.cityName = cityName
        self.temp = temp
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.description = description
        self.icon = icon
        self.iconImage = iconImage
    }
    init(weatherData: CurrentWeatherData?, iconImage: UIImage? = nil) {
        let weather = weatherData?.weather[0] ?? Weather(id: 03, description: "Mostly Clear", icon: "03n")
        let main = weatherData?.main ?? Main(temp: 24, tempMin: 12, tempMax: 54)
        self.tempMax = Int(main.tempMax)
        self.tempMin = Int(main.tempMin)
        self.temp = Int(main.temp)
        self.cityName = weatherData?.name.capitalized ?? "London"
        self.description = weather.description.localizedCapitalized
        self.icon = weather.icon
        self.iconImage = iconImage
    }
}
struct ForecastInfo: Hashable {
    static func == (lhs: ForecastInfo, rhs: ForecastInfo) -> Bool {
        lhs.id == rhs.id
    }
    let id: String = UUID().uuidString
    let icon: String
    let tempMax: Int
    let tempMin: Int
    let date: String
    let iconImage: UIImage?
    init(date: String, icon: String, tempMax: Int, tempMin: Int, iconImage: UIImage?) {
        self.date = date
        self.icon = icon
        self.tempMax = tempMax
        self.tempMin = tempMin
        self.iconImage = iconImage
    }
    init(date: String, tempMax: Int, tempMin: Int, icon: String, iconImage: UIImage? = nil) {
        self.icon = icon
        self.date = date
        self.tempMax = tempMax
        self.tempMin = tempMin
        self.iconImage = iconImage
    }
    init(date: String, info: ForecastInfo, iconImage: UIImage? = nil) {
        self.icon = info.icon
        self.date = date
        self.tempMax = info.tempMax
        self.tempMin = info.tempMin
        self.iconImage = iconImage
    }
    
}
