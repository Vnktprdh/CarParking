//
//  ParkingListViewController.swift
//  CarParking
//
//  Created by Venkat 101287100 on 2021-01-24.
//

import UIKit
import Firebase

class ParkingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        loadFireBase()
    }
    
    
    var initialArray:[arryObject] = []
    var selectedIndes:Int!
    @IBOutlet weak var tableViewList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndes = indexPath.row
        performSegue(withIdentifier: "DetailParking", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? ParkingViewController
        
        vc?.Pbno = initialArray[selectedIndes].BCode
        vc?.Plno = initialArray[selectedIndes].CNumber
        vc?.Pdate = initialArray[selectedIndes].Date
        vc?.lat = initialArray[selectedIndes].Lat
        vc?.lon = initialArray[selectedIndes].Lon
        vc?.Plocation = initialArray[selectedIndes].Location!
        vc?.Psno = initialArray[selectedIndes].SuitNo
        vc?.Phours = initialArray[selectedIndes].Hours
        
        print(initialArray[selectedIndes].Location)
    }
    
    
}

extension ParkingListViewController{
    
    func loadFireBase() {
        initialArray = []
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
                }
                
            }
            
            initialArray.sort(by: {$0.Date < $1.Date})
            self.tableViewList.reloadData()
        }
    
    }
    
}
