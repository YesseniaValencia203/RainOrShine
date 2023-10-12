//
//  WeatherDescriptionView.swift
//  RainOrShine
//
//  Created by Yessenia Valencia-Juarez on 10/11/23.
//

import SwiftUI

struct WeatherDescriptionView: View {
    @StateObject var weatherViewModel: WeatherViewModel
    
    @State var rotationAmount = 0.0

    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        let image = weatherViewModel.currentWeatherIcon ?? UIImage(systemName: "cloud")!
        ScrollView {
            VStack {
                Text(weatherViewModel.currentWeatherInformation?.cityName ?? "London")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("\(weatherViewModel.currentWeatherInformation?.temp ?? 43)\u{00B0}F")
                    .font(.title)
                    .rotation3DEffect(
                        .zero,
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                    .onAppear{
                        withAnimation(.interpolatingSpring(stiffness: 2, damping: 1)
                            .delay(0.1)
                            .speed(1.50)) {
                            rotationAmount += 360
                        }
                    }
                
                Image(uiImage: image)
                Text(weatherViewModel.currentWeatherInformation?.description.localizedCapitalized ?? "Mostly Clear")
                    .font(.headline)
                    .fontWeight(.light)
                HStack {
                    Text("High: \(weatherViewModel.currentWeatherInformation?.tempMax ?? 43)\u{00B0}F")
                        
                    Text("Low: \(weatherViewModel.currentWeatherInformation?.tempMin ?? 22)\u{00B0}F")
                }
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(weatherViewModel.currentWeatherForecast ?? [], id: \.self) { item in
                        ForecastWeatherCellView(weatherCellData: item)
                    }
                }
                
                
            }
        }
        .background(.mint)
        
    }
    
}

struct WeatherDescriptionView_Preview: PreviewProvider {
    static var previews: some View {
        WeatherDescriptionView(weatherViewModel: WeatherViewModel(networkManager: NetworkManager()))
    }
}
