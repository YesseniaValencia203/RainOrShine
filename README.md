# RainOrShine
    This is an iOS app that displays a weather forecast app using SwiftUI and Swift. The app will fetch weather data from a REST API and display it in an interactive and visually appealing user interface. There is a button provided to refresh the conditions shown to updated values based on location provided by user. 
    The app is written in Swift and uses MVVM architecture.

## Project Description 

This shows a current weather conditions and 5-Day forecast for a given location. It will be using CoreLocation to determine the value of the location weather being displayed, with default instances during initialization. The data is refreshable and that aspect is triggered through the refresh icon in the right-hand corner. 

## Table of Contents
In the structure files contains: Model, View, ViewModel, Networking, LocationManager. Within the folders containing each of the different tests used, there is also any necessary JSON files used to mock the responses from the api. 

# Installation
Can be used with Xcode 14 and above and above. Compatible with iPhone and iPad with minimum iOS version 15.0.

# Framework
SwiftUI for user-interdace
CoreLocation for location functionality

# Architecture
This application uses MVVM for the views and clean architecture for the URL calls.
WeatherViewModel is the ViewModel responsible for the URL calls.

# Challenges Encountered
## Five Day Forecast
In the exisiting code, the forecast data is received via a call that reponds with 40 instances of weather data for the next five days, each for a different time of day. This is where I hesistated in passing on simply the first value for every date given, simply because who would want to see a forecast showing the conditions at midnight for a given day. For this, I created a dictionary that would hold an array of forecast information for each given date. I then iterated through every instance of the dictionary (one for each day), took the maximum value of each of the data's tempMax, the minimnum for data's tempMin, and randomly selected an icon provided by the date. I created an array to hold all the instance returned by my iteration, sorted them by date, and used it to represent the information necessary for each Forecast Cell.
## Searchability using given API
This was the last feature added to this app, and it was tedius to find an efficient solution that wouldn't result in unnecessary API calls. Because the OpenWeather API could return a forecast for a given city, but not the current forecast, I wouldn't be able to get the current weather information without the coordinates to the city. By receiving the forecast using the city name, I took the city's corresponding coordinates to call for the current weather information. My approach was not as efficient as it could have been, since the function responsible for async getting the data is simply the two pre-existing functions, but with the coordinates returned by one call being used to make the second call. My original designed forewent what I considered unnecessary data, but this was a case in which I regretted it. 


# Testing
Units tests for successful and unsuccessful API calls.Mocked responses using json file using TestNetworkManager.

# Screenshots
![simulator_screenshot_1FD102B8-3EBD-4802-9C5E-EC011E3FA79C](https://github.com/YesseniaValencia203/RainOrShine/assets/45724970/cc36c11e-664c-42f9-ae0f-dd7ee6d755b8)

![simulator_screenshot_B9BD6206-3927-47D2-A6EB-AEC2001AB9F0](https://github.com/YesseniaValencia203/RainOrShine/assets/45724970/e46861ff-2667-4966-99e6-33b0e21e71fa)

![simulator_screenshot_EC4AEA10-60A7-4E75-BC4F-E5E08CC8C3E4](https://github.com/YesseniaValencia203/RainOrShine/assets/45724970/4a009c9a-eca8-45c1-8946-c34862c87356)

