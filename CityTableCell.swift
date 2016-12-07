//
//  CityTableCell.swift
//  WeatherDemo
//
//  Created by TYP on 16/11/29.
//  Copyright © 2016年 ChenZhelong. All rights reserved.
//

import UIKit

class CityTableCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
