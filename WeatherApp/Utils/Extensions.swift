//
//  Extensions.swift
//  WeatherApp
//
//  Created by Андрей Олесов on 10/13/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation
import OAuthSwift

enum Format:String{
    case ddMMyyyyHHmmSS = "dd-MM-yyyy hh-mm-ss"
    case ddMMyyyyHHmm = "dd/MM/yyyy hh:mm"
}
extension Date {
    func format(format:Format = .ddMMyyyyHHmmSS) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        let dateString = dateFormatter.string(from: self)
        if let newDate = dateFormatter.date(from: dateString) {
            return newDate
        } else {
            return self
        }
    }
    
    func toString(withFormat format:Format = .ddMMyyyyHHmm)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
}

extension OAuthSwiftResponse {
    func convert() throws ->SwiftModel{
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(SwiftModel.self, from: self.data)
    }
}

