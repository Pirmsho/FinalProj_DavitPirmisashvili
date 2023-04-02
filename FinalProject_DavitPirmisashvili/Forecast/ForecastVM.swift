//
//  ForecastVM.swift
//  FinalProject_DavitPirmisashvili
//
//  Created by Davit Pirmisashvili on 29.03.23.
//

import Foundation

class ForecastVM {
    var forecast: Forecast?
    
    
    // sorted arrays for sections. could have made it a one liner, but this is clearer. also could be a bit shorter
    var dataForToday: [Forecast.WeatherItem] {
         forecast?.list.filter({ weather in
            convertDate(weather.dt_txt, dateFormat: "yyyy-MM-dd") == formatTodaysDate()
        }) ?? []
        
    }
    
    var dataForTomorrow: [Forecast.WeatherItem] {
         forecast?.list.filter({ weather in
            convertDate(weather.dt_txt, dateFormat: "yyyy-MM-dd") == formatTodaysDate().convertToNextDate(howManyDaysValue: 1)
        }) ?? []
    }
    
    var dataForDayAfterTomorrow: [Forecast.WeatherItem] {
         forecast?.list.filter({ weather in
            convertDate(weather.dt_txt, dateFormat: "yyyy-MM-dd") == formatTodaysDate().convertToNextDate(howManyDaysValue: 2)
        }) ?? []
    }
    
    var dataForDayAfterTomorrow1: [Forecast.WeatherItem] {
         forecast?.list.filter({ weather in
            convertDate(weather.dt_txt, dateFormat: "yyyy-MM-dd") == formatTodaysDate().convertToNextDate(howManyDaysValue: 3)
        }) ?? []
    }
    
    var dataForDayAfterTomorrow2: [Forecast.WeatherItem] {
         forecast?.list.filter({ weather in
            convertDate(weather.dt_txt, dateFormat: "yyyy-MM-dd") == formatTodaysDate().convertToNextDate(howManyDaysValue: 4)
        }) ?? []
    }
    
    
    var countryPlusCityString: String {
        return "\(forecast?.cityName ?? ""), \(forecast?.country ?? "")"
    }
    
    
    // actual fetching function.
    func fetchForecast(lat: String, lon: String, _ completion: @escaping (() -> Void)) {
        NetworkService.shared.getData(urlString: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=d80e3e862354b82992a186d45b2f991f&units=metric") { (data: Forecast) in
            self.forecast = data
            completion()
        }
    }
    
    
    // data conversion functions.
    func convertDate(_ dateString: String, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else { return "" }
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    func formatTodaysDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"

        let result = dateFormatter.string(from: date)
        
        return result
    }
}


