//
//  ForecastWeatherCellView.swift
//  RainOrShine
//
//  Created by Yessenia Valencia-Juarez on 10/11/23.
//

import SwiftUI

struct ForecastWeatherCellView: View {
    var weatherCellData: ForecastInfo
    @State private var rightToLeftAnimation = Animation.linear(duration: 0.1)
    @State private var alpha = 0.9
   @State private var offset = UIScreen.main.bounds.width
    
    var body: some View {
        let dateString = getFullDate(weatherDate: weatherCellData.date)
        VStack {
            Text(dateString)
            Text(weatherCellData.date)
                .font(.caption)
            Image(uiImage: weatherCellData.iconImage!)
                .font(.largeTitle)


            Text("High: \(weatherCellData.tempMax)\u{00B0}F")
            Text("Low: \(weatherCellData.tempMin)\u{00B0}F")
        }
        .offset(x: offset)
        .animation(rightToLeftAnimation, value: 0.0)
        .onAppear{
            alpha = 0.1
            offset = 0
        }
        .padding()
        .clipped()
        .background(.teal)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 4)
        )

    }
    private func getFullDate(weatherDate: String) -> String {
        WeatherDate.getCellDate(date: weatherDate)
    }
}

struct ForecastWeatherCellView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastWeatherCellView(weatherCellData: ForecastInfo(date: "10/12/2024", tempMax: 43, tempMin: 23, icon: "03n", iconImage: UIImage(systemName: "cloud")))
    }
}
