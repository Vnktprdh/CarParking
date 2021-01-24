//
//  AddParkingViewController.swift
//  CarParking
//
//  Created by Gokul Murugan on 2021-01-24.
//

import UIKit
import MapKit

class AddParkingViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var BuildingCode: UITextField!
    @IBOutlet weak var HoursOfParking: UISegmentedControl!
    @IBOutlet weak var CarPlateNumber: UITextField!
    @IBOutlet weak var SuitNumber: UITextField!
    @IBOutlet weak var ParkingLocation: UITextField!
    @IBOutlet weak var DateOfParking: UIDatePicker!
    
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var buildingCodeData:String!
    var hoursOfParkingData:Int!
    var carPlateNumberData:String!
    var suitNumberData:String!
    var parkingLocationLat:String!
    var parkingLocationLon:String!
    var dateOfParkingData:Date!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        
        
    }
    
    @IBAction func AddParking(_ sender: Any) {
        
        if(BuildingCode.text! == "" || CarPlateNumber.text! == "" || SuitNumber.text! == "" || ParkingLocation.text == "" ){
            
            self.alert(Title: "Invalid Credentials", Message: "Please fill all the required field and try again!")
            return
        }
        else{
            switch HoursOfParking.selectedSegmentIndex {
            case 0:
                hoursOfParkingData = 0
            case 1:
                hoursOfParkingData = 1
            case 2:
                hoursOfParkingData = 2
            case 3:
                hoursOfParkingData = 3
                
            default:
                hoursOfParkingData = 0
            }
            
            dateOfParkingData = DateOfParking.date
            print(Date())
            print(DateOfParking.date)
            
            if(Date() > DateOfParking.date)
            {
                alert(Title: "Invalid Date", Message: "Your Date must not be lesser than todays date!")
                return
            }
            else{
                
                buildingCodeData =  BuildingCode.text!
                carPlateNumberData = CarPlateNumber.text!
                suitNumberData =  SuitNumber.text!
                
                getAddress(location: ParkingLocation.text!)
                
            }
            
        }
        
        
        
    }
    
   
}

extension AddParkingViewController{
    
    
    func alert(Title:String, Message:String?) {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getAddress(location : String){
        
//        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemark, error) in
//            self.processGeoResponse(withPlacemarks: placemark, error: error)
//        })
        
        
        geocoder.geocodeAddressString(location) { (placementmark, error) in
            self.processGeoResponse(withPlacemarks: placementmark, error: error)
        }
        
        
    }
    
    func processGeoResponse(withPlacemarks placemarks : [CLPlacemark]?, error : Error?){
        if error != nil{
            self.alert(Title: "Location Error", Message: nil)
        }else{
            
            if let placemarks = placemarks, let placemark = placemarks.first{
                
                self.parkingLocationLat = "\(placemark.location?.coordinate.latitude)"
                self.parkingLocationLon = "\(placemark.location?.coordinate.longitude)"
                
                print(buildingCodeData)
                print(hoursOfParkingData)
                print(suitNumberData)
                print(carPlateNumberData)
                print(dateOfParkingData)
                print(parkingLocationLat)
                print(parkingLocationLon)
                
                
            
                
                
            }else{
                self.alert(Title: "Address Not Found", Message: "Please check the address and try again!")
            }
        }
    }
}
