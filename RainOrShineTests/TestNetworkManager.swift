//
//  TestNetworkManager.swift
//  RainOrShineTests
//
//  Created by Yessenia Valencia-Juarez on 10/10/23.
//

import Foundation
@testable import RainOrShine

class TestNetworkManager: NetworkManaging {
    func getWeatherData(url: URL) async throws -> Data {
        let bundle = Bundle(for: TestNetworkManager.self)
        guard let path = bundle.url(forResource: url.absoluteString, withExtension: "json") else {
            throw APIError.badRequestError
        }
        do{
            let data = try Data(contentsOf: path)
            return data
        } catch {
            throw APIError.dataNotFoundError
        }
    }
    
    
}

