//
//  RequestDBModel.swift
//  WeatherApp
//
//  Created by Андрей Олесов on 10/13/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation

struct RequestDBModel{
    var city: String?
    var address: String?
    var date: Date?
    var temperature: Int?
    
    init(city:String? = nil, address:String? = nil, date:Date? = nil, temperature:Int? = nil){
        self.city = city
        self.address = address
        self.date = date
        self.temperature = temperature
    }
}
