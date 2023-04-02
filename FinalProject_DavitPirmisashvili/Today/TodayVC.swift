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
    
    var locationManager: CLLocationManager!
    
    
    
    
    
    @IBOutlet var mainView: UIView!
    
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
        let notificationCenter = NotificationCenter.default
        
        // tracks internet connectivity
        notificationCenter.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
        
        self.showSpinner(onView: mainView)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // check location services on separate thread
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
        
        // returning from background mode observer
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        self.removeSpinner()
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
    
    
    // Share functionality
    @IBAction func shareButtonFunc(_ sender: Any) {
        let text = tempPlusWeatherLbl.text
        let textData = text?.data(using: .utf8)
        let textURL = textData?.dataToFile(fileName: "data.txt")
        var filesToShare = [Any]()
        filesToShare.append(textURL!)
        
        let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    

    
    // alert for turning internet off. on a main thread
    func showAlertError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "Seems like you don't have an active internet connection. Please turn it on and come back.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    // re-fetches data when internet is back, shows alert when off
    @objc func showOfflineDeviceUI(notification: Notification) {
            if !NetworkMonitor.shared.isConnected {
                DispatchQueue.main.async {
                    self.showSpinner(onView: self.mainView)
                }
                fetchByCoordinates()
            } else {
                showAlertError()
            }
        }
  
    // re-fetches data when app comes back to foreground.
    @objc func appMovedToForeground() {
        fetchByCoordinates()
    }
 
}

extension TodayVC: CLLocationManagerDelegate {
    
    // helper fetch function, gets users coordinates. can test by switching simulator coordinates.
    func fetchByCoordinates() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            guard let currentLocation = locationManager.location else { return }
            
            
            viewModel.fetchWeather(lat: "\(currentLocation.coordinate.latitude)", lon: "\(currentLocation.coordinate.longitude)") { [weak self] in
                DispatchQueue.main.async {
                    self?.removeSpinner()
                    self?.setupUI()
                }
            }
        default:
            return
        }
    }
    
    // runs when users coordinates are resolved.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        fetchByCoordinates()
    }
    

}






