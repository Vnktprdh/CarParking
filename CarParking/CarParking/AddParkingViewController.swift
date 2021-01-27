//
//  AddParkingViewController.swift
//  CarParking
//
//  Created by Venkat 101287100 on 2021-01-24.
//

import UIKit
import MapKit
import Firebase

class AddParkingViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate{

    @IBOutlet weak var BuildingCode: UITextField!
    @IBOutlet weak var HoursOfParking: UISegmentedControl!
    @IBOutlet weak var CarPlateNumber: UITextField!
    @IBOutlet weak var SuitNumber: UITextField!
    @IBOutlet weak var ParkingLocation: UITextField!
    @IBOutlet weak var DateOfParking: UIDatePicker!
    
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var buildingCodeData:String!
    var hoursOfParkingData:String!
    var carPlateNumberData:String!
    var suitNumberData:String!
    var parkingLocationLat:String!
    var parkingLocationLon:String!
    var dateOfParkingData:Date!
    var locationAddress:String!
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func UseCurrentLocation(_ sender: Any) {
        
        let location = locationManager.location!
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { [self](placemark, error) in
                    
                    if error != nil
                    {
                        self.alert(Title: "Location Error", Message: nil)
                    }
                    else{
                        
                        if let _ = placemark, let placemark = placemark?.first{
                            
                            self.locationAddress = "\(placemark.name!), \(placemark.locality!), \(placemark.postalCode!)"
                            
                            self.ParkingLocation.text = self.locationAddress
                        }
                        
                        
                        
                    }
                    
                    
                })
                
        
        
    }
    
    
    @IBAction func AddParking(_ sender: Any) {
        
        if(BuildingCode.text! == "" || CarPlateNumber.text! == "" || SuitNumber.text! == "" || ParkingLocation.text == "" ){
            
            self.alert(Title: "Invalid Credentials", Message: "Please fill all the required field and try again!")
            return
        }
        else{
            
            if(BuildingCode.text!.count != 5)
            {
                self.alert(Title: "Wrong Building Code", Message: "Please enter a correct building code and try again!")
                return
            }
            else if(CarPlateNumber.text!.count < 2 || CarPlateNumber.text!.count > 8)
            {
                self.alert(Title: "Wrong Car Plate Number", Message: "Please enter a correct Car Plate Number and try again!")
                return
            }
            else if(SuitNumber.text!.count < 2 || SuitNumber.text!.count > 5 )
            {
                self.alert(Title: "Wrong Suit Number", Message: "Please enter a correct Suit Number and try again!")
                return
            }
            
            
            if(Date() > DateOfParking.date)
            {
                alert(Title: "Invalid Date", Message: "Your Date must not be lesser than todays date!")
                return
            }
            else{
                
                switch HoursOfParking.selectedSegmentIndex {
                case 0:
                    hoursOfParkingData = "1 Hour or Less"
                case 1:
                    hoursOfParkingData = "4 Hours"
                case 2:
                    hoursOfParkingData = "12 Hours"
                case 3:
                    hoursOfParkingData = "24 Hours"
                    
                default:
                    hoursOfParkingData = "1 Hour or Less"
                }
                
                dateOfParkingData = DateOfParking.date
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
        
        geocoder.geocodeAddressString(location) { (placementmark, error) in
            self.processGeoResponse(withPlacemarks: placementmark, error: error)
        }
        
    }
    
    func processGeoResponse(withPlacemarks placemarks : [CLPlacemark]?, error : Error?){
        if error != nil{
            self.alert(Title: "Location Error", Message: nil)
            print(error!)
        }else{
            
            if let placemarks = placemarks, let placemark = placemarks.first{
                
                
                locationAddress = "\(placemark.name!), \(placemark.locality!), \(placemark.postalCode!)"
                
                self.parkingLocationLat = "\(placemark.location!.coordinate.latitude)"
                self.parkingLocationLon = "\(placemark.location!.coordinate.longitude)"
                let db = Firestore.firestore()

                db.collection("Parking").addDocument(data: [
                    "BCode" : buildingCodeData!,
                    "Hours" : hoursOfParkingData!,
                    "SuitNo" : suitNumberData!,
                    "CNumber" : carPlateNumberData!,
                    "Date" : dateOfParkingData!,
                    "Lat" : parkingLocationLat!,
                    "Lon" : parkingLocationLon!,
                    "Location" : locationAddress!,
                    "E-mail" : Auth.auth().currentUser?.email
                ]){ err in

                    if(err != nil)
                    {
                        print(err!)
                        self.alert(Title: "Saving Document Unsucessful ", Message: nil)

                    }
                    else
                    {
                        self.BuildingCode.text = ""
                        self.HoursOfParking.selectedSegmentIndex = 0
                        self.CarPlateNumber.text = ""
                        self.SuitNumber.text = ""
                        self.ParkingLocation.text = ""
                        self.DateOfParking.date = Date()
                        self.alert(Title: "Parking added sucessfully", Message: nil)
                    }

                }
                
            }else{
                self.alert(Title: "Address Not Found", Message: "Please check the address and try again!")
            }
        }
    }
}
