//
//  ContentView.swift
//  RainOrShine
//
//  Created by Yessenia Valencia-Juarez on 10/10/23.
//

import SwiftUI
import CoreLocation
struct ContentView: View {
    @State private var searchText = ""
    @StateObject var weatherViewModel = WeatherViewModel(networkManager: NetworkManager())
    @StateObject private var locationManger = LocationManager()
    var body: some View {
        NavigationView {
            VStack {
                WeatherDescriptionView(weatherViewModel: weatherViewModel)
                    .toolbar {
                        ToolbarItem {
                            Button(action: refreshScreen) {
                                Label("Refresh Weather", systemImage: "arrow.clockwise.circle")
                            }
                            
                        }
                    }
                
                
            }
            .searchable(text: $searchText) {
                Text(searchText)
                Button {
                    refreshScreenWithCity(cityString: searchText)
                } label: {
                    Label("Search City", systemImage: "check")
                }

            }
            .navigationTitle("Rain or Shine Weather App")
            .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
            .font(.headline)
            .navigationBarHidden(false)
            .refreshable {
                refreshScreen()
            }
            .onChange(of: locationManger.currentLocation) { newValue in
                refreshScreen()
            }
            .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.automatic)
        }
        
        
    }
    private func refreshScreenWithCity(cityString: String) {
        Task {
            guard let (lat, lon) = await weatherViewModel.getWeatherForCity(cityName: APIEndpoints.getCurrentWeatherForecast(cityName: cityString))
            else { return }
            locationManger.currentLocation = CLLocation(latitude: lat, longitude: lon)
        }
    }
    private func refreshScreen() {
        Task {
            if locationManger.currentLocation != nil{
                if let currentLocationCordinate = locationManger.currentLocation?.coordinate{
                    await weatherViewModel.getCurrentWeather(weatherString: APIEndpoints.getCurrentWeatherInformation(latitude: "\(currentLocationCordinate.latitude)", longitude: "\(currentLocationCordinate.longitude)"))
                    await weatherViewModel.getWeatherForecast(weatherString: APIEndpoints.getCurrentWeatherForecastInformation(latitude: "\(currentLocationCordinate.latitude)", longitude: "\(currentLocationCordinate.longitude)"))
                }
            }
            
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
        
        
    }
}
