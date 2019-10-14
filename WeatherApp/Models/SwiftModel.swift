//
//  SwiftModel.swift
//  WeatherApp
//
//  Created by Андрей Олесов on 10/13/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation

struct SwiftModel: Codable{
    var current_observation: CurrentObservation?
    var location: Location?
    var forecasts: [Forecast]?
}

struct CurrentObservation: Codable{
    var condition:Condition?
    var pubDate:Int?
}

struct Condition: Codable{
    var text:String?
    var code:Int?
    var temperature:Int?
}

struct Location:Codable{
    var city:String?
}

struct Forecast:Codable{
    var code:Int?
    var date:Int?
    var day:String?
    var hight:Int?
    var low:Int?
    var text:String?
}

