//
//  ForecastVC.swift
//  FinalProject_DavitPirmisashvili
//
//  Created by Davit Pirmisashvili on 29.03.23.
//

import UIKit
import CoreLocation

class ForecastVC: UIViewController {
    
    let viewModel = ForecastVM()
    
    var locationManager: CLLocationManager!
    
    // vars outside tableView
    @IBOutlet weak var dashedLine: UIView!
    @IBOutlet weak var countryPlusCityLbl: UILabel!
    
    
    // should be in VM
    var dataForTableCells: [Forecast.WeatherItem] {
        return self.viewModel.forecast?.list ?? []
    }

    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSpinner(onView: tableView)

        // init location services.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // request auth on other thread.
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
        
        // notif center for moving back from background
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }

    func setupUI() {
       drawDottedLine(start: CGPoint(x: dashedLine.bounds.minX, y: dashedLine.bounds.minY), end: CGPoint(x: dashedLine.bounds.maxX, y: dashedLine.bounds.maxY), view: dashedLine)
        
        countryPlusCityLbl.text = viewModel.countryPlusCityString
       }
    
    // Draws dashed line
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.lineDashPattern = [5, 3] // 7 is the length of dash, 3 is length of the gap.

        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
    // re-fetch when app moves to foreground
    @objc func appMovedToForeground() {
        self.showSpinner(onView: tableView)
        fetchByCoordinates()
    }

    
}



extension ForecastVC: UITableViewDelegate, UITableViewDataSource {
    
    // programmatical sections, could be improved to be dynamic
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.dataForToday.count
        } else if section == 1 {
            return viewModel.dataForTomorrow.count
        } else if section == 2 {
            return viewModel.dataForDayAfterTomorrow.count
        } else if section == 3 {
            return viewModel.dataForDayAfterTomorrow1.count
        } else if section == 4 {
            return viewModel.dataForDayAfterTomorrow2.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataToShow = dataForTableCells[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? ForecastCell else { return UITableViewCell() }
        
        cell.temperatureLbl.text = String(format: "%.0f",dataToShow.main.temp) + " °C"
        cell.weatherDescrLbl.text = dataToShow.weather[0].description
        cell.hourLbl.text = viewModel.convertDate(dataToShow.dt_txt, dateFormat: "HH:mm")

        // MARK: image picker for forecastIcon
        if dataToShow.weather[0].description == "clear sky" {
            cell.forecastIcon.image = UIImage(named: "clearSky")
        } else if dataToShow.weather[0].description == "few clouds" {
            cell.forecastIcon.image = UIImage(named: "fewClouds")
        } else if dataToShow.weather[0].description == "scattered clouds" {
            cell.forecastIcon.image = UIImage(named: "scatteredClouds")
        } else if dataToShow.weather[0].description == "broken clouds" {
            cell.forecastIcon.image = UIImage(named: "brokenClouds")
        } else if dataToShow.weather[0].description == "shower rain" {
            cell.forecastIcon.image = UIImage(named: "showerRain")
        } else if dataToShow.weather[0].description == "rain" {
            cell.forecastIcon.image = UIImage(named: "rain")
        } else if dataToShow.weather[0].description == "thunderstorm" {
            cell.forecastIcon.image = UIImage(named: "thunderstorm")
        } else if dataToShow.weather[0].description == "snow" {
            cell.forecastIcon.image = UIImage(named: "snow")
        } else if dataToShow.weather[0].description.contains("clouds") {
            cell.forecastIcon.image = UIImage(named: "fewClouds")
        } else {
            cell.forecastIcon.image = UIImage(named: "mist")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if section == 0 {
            title = "Today"
        } else if section == 1 {
            title = "Tomorrow"
        } else if section == 2 {
            title = "Day After Tomorrow"
        } else if section == 3 {
            title = "Day After After Tomorrow"
        } else if section == 4 {
            title = "Day After After After Tomorrow"
        }
        return title
    }
    

    
    
}


extension ForecastVC: CLLocationManagerDelegate {
    
    // fetch actual coordinates. could be tested by changing simulator coordinates.
    func fetchByCoordinates() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            guard let currentLocation = locationManager.location else { return }
            
            viewModel.fetchForecast(lat: "\(currentLocation.coordinate.latitude)", lon: "\(currentLocation.coordinate.longitude)") { [weak self] in
                DispatchQueue.main.async {
                    self?.removeSpinner()
                    self?.setupUI()
                    self?.tableView.reloadData()
                    
                }
            }
        default:
            return
        }
    }
    
    // func that runs when location auth is confirmed.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        fetchByCoordinates()
    }
    
    func convertDate(_ dateString: String, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else { return "" }
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
}
