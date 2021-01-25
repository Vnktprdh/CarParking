//
//  ParkingViewController.swift
//  CarParking
//
//  Created by Gokul Murugan on 2021-01-24.
//

import UIKit

class ParkingViewController: UIViewController {
    
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var ParkingHours: UILabel!
    @IBOutlet weak var SuitNumber: UILabel!
    @IBOutlet weak var BuildingNumber: UILabel!
    @IBOutlet weak var LicenseNumber: UILabel!
    
    var lat:String!
    var lon:String!
    var Plocation:String!
    var Pdate:Date!
    var Phours:String!
    var Psno:String!
    var Pbno:String!
    var Plno:String!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        Location.text = Plocation
        Date.text = "Date: \(Calendar.current.component(.day, from: Pdate))-\(Calendar.current.component(.month, from: Pdate))-\(Calendar.current.component(.year, from: Pdate)) \nTime: \(Calendar.current.component(.hour, from: Pdate)):\(Calendar.current.component(.minute, from: Pdate))"
        ParkingHours.text = "Parking type: \(Phours!)"
        SuitNumber.text = "Suit Number: \(Psno!)"
        BuildingNumber.text = "Building Number: \(Pbno!)"
        LicenseNumber.text = "License Number: \(Plno!)"
        
    }
    

    @IBAction func getLocation(_ sender: Any) {
        
        
        
        
    }

}
