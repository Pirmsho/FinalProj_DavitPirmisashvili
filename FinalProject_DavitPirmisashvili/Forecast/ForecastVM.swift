//
//  ForecastVM.swift
//  FinalProject_DavitPirmisashvili
//
//  Created by Davit Pirmisashvili on 29.03.23.
//

import Foundation

class ForecastVM {
    var forecast: Forecast?
    
    var countryPlusCityString: String {
        return "\(forecast?.cityName ?? ""), \(forecast?.country ?? "")" 
    }
    
    
    func fetchForecast(lat: String, lon: String, _ completion: @escaping (() -> Void)) {
        NetworkService.shared.getData(urlString: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=d80e3e862354b82992a186d45b2f991f&units=metric") { (data: Forecast) in
            self.forecast = data
            completion()
        }
    }
    
    func convertDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else { return "" }
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}


