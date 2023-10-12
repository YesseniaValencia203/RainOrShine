//
//  NetworkManager.swift
//  RainOrShine
//
//  Created by Yessenia Valencia-Juarez on 10/10/23.
//

import Foundation
import UIKit

protocol NetworkManaging {
    func getWeatherData(url: URL) async throws -> Data
}
class NetworkManager: NetworkManaging {
    func getWeatherData(url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
