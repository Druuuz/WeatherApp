//
//  HistoryTableViewController.swift
//  WeatherApp
//
//  Created by Андрей Олесов on 10/13/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    private var requests = [RequestDBModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 102
        requests = DBUtil.getRequests().sorted(by: { (request1, request2) -> Bool in
            return request1.date! > request2.date!
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell
        if let cell = cell{
            cell.cityLabel.text = requests[indexPath.row].city
            cell.dateLabel.text = requests[indexPath.row].date?.toString()
            cell.addressLabel.text = requests[indexPath.row].address
            if let degree = requests[indexPath.row].temperature{
                cell.degreeLabel.text = "\(degree)°"
            }
            return cell
        }
        return UITableViewCell()
    }

}
