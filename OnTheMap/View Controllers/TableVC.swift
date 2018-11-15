//
//  TableVC.swift
//  OnTheMap
//
//  Created by Ahmed Osama on 11/11/18.
//  Copyright © 2018 Ahmed Osama. All rights reserved.
//

import UIKit

class TableVC: UIViewController {

    let tableCellID = "FancyCell"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadStudentLocations()
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        loadStudentLocations()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        NetworkingManager.Udacity.logout { (errorMessage) in
            if let error = errorMessage {
                Helpers.showSimpleAlert(viewController: self,
                                        title: "Failed to Logout", message: error)
            }
            else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    func loadStudentLocations() {
        NetworkingManager.Parse.getUniqueStudentLocation(type: .allLocations) { (locations, errorMessage) in
            if let error = errorMessage {
                Helpers.showSimpleAlert(viewController: self,
                                        title: "Failed to Get Locations", message: error)
            }
            else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension TableVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NetworkingManager.Parse.studentLocations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID) as! FancyTableCell
        let student = (NetworkingManager.Parse.studentLocations?[indexPath.row])!
        cell.nameLabel.text = student.mapString
        cell.mediaLabel.text = student.mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        if let link = NetworkingManager.Parse.studentLocations?[index.row].mediaURL {
            let url = URL(string: link)
            if url != nil {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }
    }
    
}
