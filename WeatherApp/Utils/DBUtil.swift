//
//  DBUtil.swift
//  WeatherApp
//
//  Created by Андрей Олесов on 10/13/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DBUtil{
    
    static func addRequest(requestToSave: RequestDBModel){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let requestEntity = NSEntityDescription.entity(forEntityName: "Request", in: managedContext)!
        
        let request = NSManagedObject(entity: requestEntity, insertInto: managedContext)
        request.setValue(requestToSave.city, forKey: "city")
        request.setValue(requestToSave.address, forKey: "address")
        request.setValue(requestToSave.date?.format(), forKey: "date")
        request.setValue(requestToSave.temperature, forKey: "temperature")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func getRequests() -> [RequestDBModel]{
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [RequestDBModel]()}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        var requests = [RequestDBModel]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Request")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let city = data.value(forKey: "city") as? String
                let address = data.value(forKey: "address") as? String
                let temperature = data.value(forKey: "temperature") as? Int
                let date = (data.value(forKey: "date") as? Date)
                
                requests.append(RequestDBModel(city: city, address: address, date: date, temperature: temperature))
            }
            return requests
        } catch {
            print("Failed")
        }
        return [RequestDBModel]()
    }
   
}
