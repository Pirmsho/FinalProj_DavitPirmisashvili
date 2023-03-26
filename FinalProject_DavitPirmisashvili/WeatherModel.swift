//
//  WeatherModel.swift
//  FinalProject_DavitPirmisashvili
//
//  Created by Davit Pirmisashvili on 26.03.23.
//

import Foundation


struct Weather: Codable {
    
    var name: String
    var main: Main
    var weatherType: WeatherType
    var sys: Sys
    var wind: Wind
    
    struct Main: Codable {
        var temp: Double
        var feelsLike: Double
        var tempMin: Double
        var tempMax: Double
        var pressure: Double
        var humidity: Double
        
        enum CodingKeys: String, CodingKey {
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case temp
            case pressure
            case humidity
        }
    }
    
    struct WeatherType: Codable {
        var main: String
    }
    
    struct Sys: Codable {
        var country: String
    }
    
    struct Wind: Codable {
        var speed: Double
        var deg: Double
    }
}


extension Weather {
    var temp: Double {
        return main.temp
    }
    
    var feelsLike: Double {
        return main.feelsLike
    }
    
    var minTemp: Double {
        return main.tempMin
    }
    
    var maxTemp: Double {
        return main.tempMax
    }
    
    var pressure: Double {
        return main.pressure
    }
    
    var humidity: Double {
        return main.humidity
    }
    
    var actualWeatherType: String {
        return weatherType.main
    }
    
    var country: String {
        return sys.country
    }
}
