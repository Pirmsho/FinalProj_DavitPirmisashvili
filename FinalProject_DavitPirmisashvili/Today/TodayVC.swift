//
//  ViewController.swift
//  FinalProject_DavitPirmisashvili
//
//  Created by Davit Pirmisashvili on 25.03.23.
//

import UIKit

class TodayVC: UIViewController {
    
    private let viewModel = TodayVM()
    
    // MARK: top section vars
    @IBOutlet weak var cityPlusCountryLbl: UILabel!
    @IBOutlet weak var tempPlusWeatherLbl: UILabel!
    
    
    @IBOutlet weak var dashedLine: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // TODO: fetch and setup lbls
    }
    
    
    func setupUI() {
        drawDottedLine(start: CGPoint(x: dashedLine.bounds.minX, y: dashedLine.bounds.minY), end: CGPoint(x: dashedLine.bounds.maxX, y: dashedLine.bounds.maxY), view: dashedLine)
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



