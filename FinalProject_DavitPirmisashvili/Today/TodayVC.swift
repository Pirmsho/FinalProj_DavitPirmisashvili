//
//  ViewController.swift
//  FinalProject_DavitPirmisashvili
//
//  Created by Davit Pirmisashvili on 25.03.23.
//

import UIKit
import CoreLocation

class TodayVC: UIViewController {

    
    private let viewModel = TodayVM()
    var lat: Double?
    var lon: Double?
    
    // MARK: top section vars
    @IBOutlet weak var cityPlusCountryLbl: UILabel!
    @IBOutlet weak var tempPlusWeatherLbl: UILabel!
    
    // MARK: bottom section vars
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var compassDirectionLbl: UILabel!
    
    // Dashed line below "Today"
    @IBOutlet weak var dashedLine: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.getUserLocation { [weak self]  location in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                self?.lat = location.coordinate.latitude
                self?.lon = location.coordinate.longitude
            }
        }
        
        
        viewModel.fetchWeather(lat: "", lon: "") { [weak self] in
            DispatchQueue.main.async {
                self?.setupUI()
            }
        }
    }
    

    
    
    private func setupUI() {
        drawDottedLine(start: CGPoint(x: dashedLine.bounds.minX, y: dashedLine.bounds.minY), end: CGPoint(x: dashedLine.bounds.maxX, y: dashedLine.bounds.maxY), view: dashedLine)
        
        cityPlusCountryLbl.text = viewModel.countryPlusCity
        tempPlusWeatherLbl.text = viewModel.temperaturePlusWeatherType
        humidityLbl.text = viewModel.humidityString
        pressureLbl.text = viewModel.pressureString
        windSpeedLbl.text = viewModel.windSpeedString
        compassDirectionLbl.text = viewModel.compassDirectionString
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


var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    

}
