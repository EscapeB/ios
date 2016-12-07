//
//  City.swift
//  WeatherDemo
//
//  Created by TYP on 16/11/29.
//  Copyright © 2016年 ChenZhelong. All rights reserved.
//

import UIKit

class City: NSObject {
    var cityName:String
    var cityTem:Double
    var cityWeather:String
    init(name:String) {
        self.cityName=name
        self.cityTem=1.2
        self.cityWeather="Sunny"
        
    }

}
