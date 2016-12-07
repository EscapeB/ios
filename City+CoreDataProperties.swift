//
//  City+CoreDataProperties.swift
//  WeatherDemo
//
//  Created by TYP on 16/11/29.
//  Copyright © 2016年 ChenZhelong. All rights reserved.
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City");
    }

    @NSManaged public var cityName: String?

}
