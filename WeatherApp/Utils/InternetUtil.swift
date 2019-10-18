//
//  InternetUtil.swift
//  WeatherApp
//
//  Created by Андрей Олесов on 10/16/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation
import CommonCrypto

class WeatherAPIUtil{
    
    private var appId = "aN38Oo4q"
    private var consumerKey = "dj0yJmk9MXFBOGo2RURIa0gyJmQ9WVdrOVlVNHpPRTl2TkhFbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmc3Y9MCZ4PTlm"
    private var consumerSecret = "00e2c8d7b548670899f4e36066fe78fe822fa5b3"
    
    private let defaultUrl = "https://weather-ydn-yql.media.yahoo.com/forecastrss"
    private let timeStamp = String(Int64(Date().timeIntervalSince1970))
    private let signatureMethod = "HMAC-SHA1"
    private let method = "GET"
    private var headers:[String:String] = [
            "Authorization": "",
            "X-Yahoo-App-Id": ""
    ]
    
    private func createNonce() -> String{
        let uuidString: String = UUID().uuidString
        let index = uuidString.index(uuidString.startIndex, offsetBy: 8)
        return String(uuidString[uuidString.startIndex..<index])
    }
      
    private func getAuthorizationHeader(withCity city:String, withResponseDataFormat format:String)->String{
        let nonce = createNonce()
        var parameters = [String]([
            "oauth_consumer_key=" + consumerKey,
            "oauth_nonce=" + nonce,
            "oauth_signature_method=" + signatureMethod,
            "oauth_timestamp=" + timeStamp,
            "oauth_version=" + "1.0",
            "location=" + city,
            "format=" + format,
            "u=c"
        ])
        parameters.sort()
        
        let listOfParameters = parameters.joined(separator: "&")
        let customAllowedSet = CharacterSet(charactersIn:"=\":#&%/<>?@\\^`{|}").inverted
        let signatureString = "\(method)&" + defaultUrl.addingPercentEncoding(withAllowedCharacters: customAllowedSet)! +
            "&" + listOfParameters.addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
        guard let signature = signatureString.digest(algorithm: .SHA1, key: consumerSecret + "&") else {return ""}
        
        let authLine = "OAuth " + "oauth_consumer_key=\"" + consumerKey + "\", " +
                                  "oauth_nonce=" + "\"" + nonce + "\", " +
                                  "oauth_timestamp=\"" + timeStamp + "\", " +
                                  "oauth_signature_method=\"" + signatureMethod + "\", " +
                                  "oauth_signature=\"" + signature + "\", " +
                                  "oauth_version=\"1.0\""
        return authLine
    }

    func getRequest(withCity city:String, withResponseDataFormat format:String) -> URLRequest?{
        guard let url = URL(string: defaultUrl + "?location=\(city)&format=\(format)&u=c") else {return nil}
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        headers["Authorization"] = getAuthorizationHeader(withCity: city, withResponseDataFormat: format)
        headers["X-Yahoo-App-Id"] = appId
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func getWeather(inCity city:String, withFormat format:String = "json", completion: @escaping (SwiftModel?)->()){
        guard let request = getRequest(withCity: String(city.filter { !" ".contains($0) }), withResponseDataFormat: format) else {return}
        URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            guard let data = data, let _ = response, error == nil else {
                print("LOG: Incorrect response from endpoint, error = \(String(describing: error))")
                return
            }
            print("LOG: Downloded...")
            let jsonDecoder = JSONDecoder()
            let dataInModel = try? jsonDecoder.decode(SwiftModel.self, from: data)
            completion(dataInModel)
        }).resume()
    }
}
