//
//  WeatherUtil.swift
//  WeatherApp
//
//  Created by Андрей Олесов on 10/12/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation
import OAuthSwift

enum YahooWeatherAPIResponseType:String {
    case json = "json"
    case xml = "xml"
}

enum YahooWeatherAPIUnitType:String {
    case imperial = "f"
    case metric = "c"
}

fileprivate struct YahooWeatherAPIClientCredentials {
    var appId = "aN38Oo4q"
    var clientId = "dj0yJmk9MXFBOGo2RURIa0gyJmQ9WVdrOVlVNHpPRTl2TkhFbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmc3Y9MCZ4PTlm"
    var clientSecret = "00e2c8d7b548670899f4e36066fe78fe822fa5b3"
}

class YahooWeatherAPI {
    private let credentials = YahooWeatherAPIClientCredentials(appId: "aN38Oo4q", clientId:"dj0yJmk9MXFBOGo2RURIa0gyJmQ9WVdrOVlVNHpPRTl2TkhFbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmc3Y9MCZ4PTlm", clientSecret: "00e2c8d7b548670899f4e36066fe78fe822fa5b3")
    
    private let url:String = "https://weather-ydn-yql.media.yahoo.com/forecastrss"
    private let oauth:OAuth1Swift?
    public static let shared = YahooWeatherAPI()
 
    private init() {
        self.oauth = OAuth1Swift(consumerKey: self.credentials.clientId, consumerSecret: self.credentials.clientSecret)
    }

    private var headers:[String:String] {
        return [
            "X-Yahoo-App-Id": self.credentials.appId
        ]
    }
    
    public func weather(location:String, completion: @escaping (_ result: Result<OAuthSwiftResponse, OAuthSwiftError>) -> Void, responseFormat:YahooWeatherAPIResponseType = .json, unit:YahooWeatherAPIUnitType = .metric) {
        self.makeRequest(parameters: ["location":location, "format":responseFormat.rawValue, "u":unit.rawValue], result: completion)
    }

    private func makeRequest(parameters:[String:String], result:OAuthSwiftHTTPRequest.CompletionHandler?) {
        self.oauth?.client.request(self.url, method: .GET, parameters: parameters, headers: self.headers, body: nil, checkTokenExpiration: true, completionHandler: result)
    }
    
}
