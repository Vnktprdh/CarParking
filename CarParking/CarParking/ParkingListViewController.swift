//
//  ParkingListViewController.swift
//  CarParking
//
//  Created by Gokul Murugan on 2021-01-24.
//

import UIKit
import Firebase

class ParkingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
   
    override func viewWillAppear(_ animated: Bool) {
        tableViewList.reloadData()
    }
    
    
    var initialArray:[arryObject] = []

    @IBOutlet weak var tableViewList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFireBase()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return initialArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")
        cell?.textLabel?.text = "\(initialArray[indexPath.row].Location!)"
        cell?.detailTextLabel?.text = "\(initialArray[indexPath.row].Date!)"
        
        return cell!
    }

}

extension ParkingListViewController{
    
    func loadFireBase() {
        
        Firestore.firestore().collection("Parking").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    let bno = data["BCode"] as? String
                    let lno = data["CNumber"] as? String
                    let loc = data["Location"] as? String
                    let loclat = data["Lat"] as? String
                    let loclon = data["Lon"] as? String
                    let sun = data["SuitNo"] as? String
                    let hours = data["Hours"] as? String
                    guard let stamp = data["Date"] as? Timestamp else {return}
                    let date = stamp.dateValue()
                    
                    let u:arryObject = arryObject(bcode: bno!, hours: hours!, suitNo: sun!, cNumber: lno!, date: date, lat: loclat!, Lon: loclon!, Location: loc!)
                    self.initialArray.append(u)
                    print("\(document.documentID) => \(document.data())")
                }
                
            }
            
            initialArray.sort(by: {$0.Date < $1.Date})
            self.tableViewList.reloadData()
        }
    
    }
    
}
