//
//  ForecastCell.swift
//  FinalProject_DavitPirmisashvili
//
//  Created by Davit Pirmisashvili on 29.03.23.
//

import UIKit

class ForecastCell: UITableViewCell {

    @IBOutlet weak var hourLbl: UILabel!
    @IBOutlet weak var weatherDescrLbl: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var forecastIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
