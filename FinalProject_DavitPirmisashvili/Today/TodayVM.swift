//
//  TodayVM.swift
//  FinalProject_DavitPirmisashvili
//
//  Created by Davit Pirmisashvili on 26.03.23.
//

import Foundation

class TodayVM {
    var weather: TodayWeather?
    
    
    
    // MARK: top section vars
    var nameString: String {
        return String(weather?.name ?? "")
    }
    
    var temperatureString: String {
        return String(format: "%.0f", weather?.temp ?? 0) + "°C"
    }
    
    var countryString: String {
        return String(weather?.sys.country ?? "")
    }
    
    var weatherTypeString: String {
        return String(weather?.weather[0].main ?? "")
    }
    
    var weatherDesc: String {
        return String(weather?.weather[0].description ?? "")
    }
    
    var imageString: String {
        if weatherDesc == "clear sky" {
            return "clearSky"
        } else if weatherDesc == "few clouds" {
            return "fewClouds"
        } else if weatherDesc == "scattered clouds" {
            return "scatteredClouds"
        } else if weatherDesc == "broken clouds" {
            return "brokenClouds"
        } else if weatherDesc == "shower rain" {
            return "showerRain"
        } else {
            return weatherTypeString
        }
        
    }
 
    
    // Formatted top section vars
    var countryPlusCity: String {
        return nameString + ", " + countryString
    }
    
    var temperaturePlusWeatherType: String {
        return temperatureString + " | " + weatherTypeString
    }
    
    
    // MARK: bottom section vars
    var humidityString: String {
        return String(format: "%.0f", weather?.humidity ?? 0) + "%"
    }
    
    var pressureString: String {
        return String(format: "%.0f", weather?.pressure ?? 0) + " hPa"
    }
    
    var windSpeedString: String {
        return String(format: "%.1f", weather?.wind.speed ?? 0) + " km/h"
    }
    
    var compassDirectionString: String {
        let compassDirection: String = convertToCompassDirection(weather?.wind.deg ?? 0)
        return compassDirection
    }
    
    
    
    // weather fetcher by lat/lon
    func fetchWeather(lat: String, lon: String, _ completion: @escaping (() -> Void)) {
        NetworkService.shared.getData(urlString: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=d80e3e862354b82992a186d45b2f991f&units=metric") { (data: TodayWeather) in
            self.weather = data
            completion()
        }
    }
    
    
}
    
    
    
    // MARK: Helper funcs
    private func convertToCompassDirection(_ degree: Double) -> String {
        switch degree {
        case 11.25...33.75:
            return "NNE"
        case 33.75...56.25:
            return "NE"
        case 56.25...78.75:
            return "ENE"
        case 78.75...101.25:
            return "E"
        case 101.25...123.75:
            return "ESE"
        case 123.75...146.25:
            return "SE"
        case 146.25...168.75:
            return "SSE"
        case 168.75...191.25:
            return "S"
        case 191.25...213.75:
            return "SSW"
        case 213.75...236.25:
            return "SW"
        case 236.25...258.75:
            return "WSW"
        case 258.75...281.25:
            return "W"
        case 281.25...303.75:
            return "WNW"
        case 303.75...326.25:
            return "NW"
        case 326.25...348.75:
            return "NNW"
        default:
            return "N"
        }
    }
    

    

