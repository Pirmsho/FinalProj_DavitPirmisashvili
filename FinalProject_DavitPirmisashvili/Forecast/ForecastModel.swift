//
//  ForecastModel.swift
//  FinalProject_DavitPirmisashvili
//
//  Created by Davit Pirmisashvili on 29.03.23.
//

import Foundation


struct Forecast: Codable {
    var cnt: Int
    var city: City
    var list: [WeatherItem]
    
    struct City: Codable {
        var name: String
        var country: String
    }

    struct WeatherItem: Codable {
        var dt: Int
        var dt_txt: String
        var main: Main
        var weather: [Weather]
        
        
        struct Main: Codable {
            var temp: Double
        }
        
        struct Weather: Codable {
            var description: String
        }
    }
}


// Format vars to access them easier
extension Forecast {
    
    var cityName: String {
        return city.name
    }
    
    var country: String {
        return city.country
    }
    
    
}
