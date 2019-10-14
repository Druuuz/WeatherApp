//
//  ViewController.swift
//  WeatherApp
//
//  Created by Андрей Олесов on 10/12/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import UIKit
import CoreLocation
import Network

class LocationViewVontroller: UIViewController {
    
    private var model:RequestDBModel = RequestDBModel()
    private var locationManager =  CLLocationManager()
    private var location: CLLocation?
    private var isUpdatingLocation = false
    private let geocoder = CLGeocoder()
    private var placeMark: CLPlacemark?
    private var currentCity:String?{
        didSet{
            if let _ = currentCity{
                showWeatherButton.isHidden = false
            } else{
                showWeatherButton.isHidden = true
            }
        }
    }
    private var isDecoding = false{
        didSet{
            if isDecoding{
                activityIndicator.isHidden = false
            } else {
                activityIndicator.isHidden = true
            }
        }
    }
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    @IBOutlet var addressLine: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var showWeatherButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startMonitoringInternetConnection()
        showWeatherButton.isHidden = true
        activityIndicator.isHidden = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    @IBAction func detectLocation(_ sender: UIButton) {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
            return
        }
        if authorizationStatus == .denied || authorizationStatus == .restricted{
            showAccessError()
            return
        }
        if isUpdatingLocation{
            stopLocationManager()
        } else{
            location = nil
            placeMark = nil
            startLocationManager()
        }
    }
    
    private func updateUI(){
        if let placeMark = placeMark{
            addressLine.text = getAddress(from: placeMark)
        } else {
            currentCity = nil
        }
    }

    
    private func startLocationManager(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            isUpdatingLocation = true
        }
    }
    
    private func stopLocationManager(){
        if isUpdatingLocation{
            locationManager.stopUpdatingLocation()
            isUpdatingLocation = false
        }
    }
    
    @IBAction func showWeather(_ sender: UIButton) {
        guard let _ = currentCity else {return}
        let weatherVC = storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController
        guard let VC = weatherVC else {return}
        VC.model = self.model
        navigationController?.pushViewController(VC, animated: true)
    }
    
    private func showAccessError(){
        let alert = UIAlertController(title: "Location Services are unvailable", message: "Please, go to Settings and give an access", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func getAddress(from placeMark: CLPlacemark) -> String?{
        currentCity = nil
        var address = ""
        if let street = placeMark.thoroughfare{
            model.address = street
            address += "\(street), "
        }
        if let city = placeMark.locality{
            address += "\(city), "
            currentCity = city
            model.city = city
        }
        if let country = placeMark.country {
            address += "\(country)"
        }
        return address
    }
    
    private func startMonitoringInternetConnection(){
        monitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .unsatisfied {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    let alert = UIAlertController(title: "Internet connection is off", message: "Please, turn on Internet and try again", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    self.showWeatherButton.isHidden = true
                }
            }
        }
        monitor.start(queue: queue)
    }
}

extension LocationViewVontroller: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error")
        stopLocationManager()
        activityIndicator.isHidden = true
        showWeatherButton.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        stopLocationManager()
        
        guard let location = location, !isDecoding else {return}
        isDecoding = true
        geocoder.reverseGeocodeLocation(location) { (placeMarks, error ) in
            if error == nil, let placeMarks = placeMarks, !placeMarks.isEmpty{
                self.placeMark = placeMarks.last!
                self.updateUI()
            } else{
                self.placeMark = nil
            }
            self.isDecoding = false
        }
    }
}

