//
//  ForecastVC.swift
//  FinalProject_DavitPirmisashvili
//
//  Created by Davit Pirmisashvili on 29.03.23.
//

import UIKit

class ForecastVC: UIViewController {
    
    let viewModel = ForecastVM()
    
    // vars outside tableView
    @IBOutlet weak var dashedLine: UIView!
    @IBOutlet weak var countryPlusCityLbl: UILabel!
    
    var dataCount: Int {
        return self.viewModel.forecast?.cnt ?? 0
    }
    
    var dataForTableCells: [Forecast.WeatherItem] {
        return self.viewModel.forecast?.list.sorted(by: { prevWeather, nextWeather in
            prevWeather.dt < nextWeather.dt
        }) ?? []
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.fetchForecast(lat: "42.31", lon: "43.35") { [weak self] in
            DispatchQueue.main.async {
                self?.setupUI()
                self?.tableView.reloadData()
                
            }
        }
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

    
}



extension ForecastVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataToShow = dataForTableCells[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? ForecastCell else { return UITableViewCell() }
        
        cell.temperatureLbl.text = String(format: "%.0f",dataToShow.main.temp) + " °C"
        cell.weatherDescrLbl.text = dataToShow.weather[0].description
        cell.hourLbl.text = viewModel.convertDate(dataToShow.dt_txt)
        cell.forecastIcon.image = .checkmark
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
}
