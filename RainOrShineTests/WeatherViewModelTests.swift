//
//  WeatherViewModelTests.swift
//  RainOrShineTests
//
//  Created by Yessenia Valencia-Juarez on 10/11/23.
//

import XCTest
@testable import RainOrShine

final class WeatherViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCurrentWeatherInfo_WhenEveryThingGoesCorrect() async throws {
        //Given
        let viewModel = await WeatherViewModel(networkManager: TestNetworkManager())
        
        //when
        await viewModel.getCurrentWeather(weatherString: "CurrentWeatherTest")
        
        //then
        XCTAssertNotNil(viewModel)
        let currentWeatherInformation =  await viewModel.currentWeatherInformation
        
        XCTAssertNotNil(currentWeatherInformation)
        XCTAssertEqual(currentWeatherInformation?.cityName, "Sydney")
        XCTAssertEqual(currentWeatherInformation?.tempMax, 66)
        XCTAssertEqual(currentWeatherInformation?.tempMin, 57)
        XCTAssertEqual(currentWeatherInformation?.description, "Clear Sky")

    }

    func testCurrentWeatherInfo_WhenNotExpectingData() async throws {
        //Given
        let viewModel = await WeatherViewModel(networkManager: TestNetworkManager())
        
        //when
        await viewModel.getCurrentWeather(weatherString: "NoResponse")
        
        //then
        XCTAssertNotNil(viewModel)
        let currentWeatherInformation = await viewModel.currentWeatherInformation
        
        XCTAssertNil(currentWeatherInformation)
        let apiError = await viewModel.apiError
        XCTAssertEqual(apiError, APIError.dataNotFoundError)

    }
    
    func testCurrentWeatherInfo_WhenNotExpectingData_WhenURLISWrong() async throws {
        //Given
        let viewModel = await WeatherViewModel(networkManager: TestNetworkManager())
        
        //when
        await viewModel.getCurrentWeather(weatherString: "")
        
        //then
        XCTAssertNotNil(viewModel)
        let currentWeatherInformation = await viewModel.currentWeatherInformation
        
        XCTAssertNil(currentWeatherInformation)
        let apiError = await viewModel.apiError
        XCTAssertEqual(apiError, APIError.badRequestError)

    }
    
    func testCurrentWeatherInfo_WhenNotExpectingData_ForIncorrectURL() async throws {
        //Given
        let viewModel = await WeatherViewModel(networkManager: TestNetworkManager())
        
        //when
        await viewModel.getCurrentWeather(weatherString: "SomeWringURL")
        
        //then
        XCTAssertNotNil(viewModel)
        let currentWeatherInformation = await viewModel.currentWeatherInformation
        
        XCTAssertNil(currentWeatherInformation)
        let apiError = await viewModel.apiError
        XCTAssertEqual(apiError, APIError.dataNotFoundError)

    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
