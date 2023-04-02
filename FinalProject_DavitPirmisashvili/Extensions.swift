//
//  Extensions.swift
//  FinalProject_DavitPirmisashvili
//
//  Created by Davit Pirmisashvili on 02.04.23.
//

import Foundation
import UIKit

var vSpinner : UIView?

extension UIViewController {
    
    // helper for showing spinner
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
    
    // helper to remove spinner
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    

}

extension String {
    // helper function to get next X days/date, could be improved.
    func convertToNextDate(howManyDaysValue: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let myDate = dateFormatter.date(from: self)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: howManyDaysValue, to: myDate)
        return dateFormatter.string(from: tomorrow!)
    }
}


extension Data {
    // helper function to share text.
    func dataToFile(fileName: String) -> NSURL? {
        let data = self
        let filePath = getDocumentDirectory().appendingPathComponent(fileName)
        
        do {
            try data.write(to: URL(fileURLWithPath: filePath))
            
            return NSURL(fileURLWithPath: filePath)
        }
        catch {
            print("Error: \(error)")
        }
        return NSURL(fileURLWithPath: filePath)
    }
    
    func getDocumentDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
}
