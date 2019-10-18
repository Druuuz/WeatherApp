//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Андрей Олесов on 10/12/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import UIKit
import OAuthSwift
import Network

class WeatherViewController: UIViewController {
    
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblDegree: UILabel!
    @IBOutlet var lblWeather: UILabel!
    private var isGettingWeather = false
    private let weatherUtil = WeatherAPIUtil()
    var model: RequestDBModel!
    
    @IBAction func refreshWeather(_ sender: UIButton) {
        self.lblCity.text = "Detect weather"
        self.lblWeather.text = ""
        self.lblDegree.text = ""
        
        getWeather(inCity: model.city)
    }
    
    private func getWeather(inCity city:String?){
        guard let city = city , isGettingWeather == false else {return}
        isGettingWeather = true
        weatherUtil.getWeather(inCity: city) { (model) in
            guard let model = model else {return}
            DispatchQueue.main.async {
                self.model.date = Date().format()
                self.lblCity.text = model.location?.city
                self.lblWeather.text = model.forecasts?.first?.text
                if let degree = model.current_observation?.condition?.temperature{
                    self.lblDegree.text = "\(degree)°"
                    self.model.temperature = degree
                }
                DBUtil.addRequest(requestToSave: self.model)
                self.isGettingWeather = false
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWeather(inCity: model.city)
    }
    
}
