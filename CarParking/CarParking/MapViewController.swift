//
//  MapViewController.swift
//  CarParking
//
//  Created by Venkat 101287100 on 2021-01-24.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var lat:String!
    var lon:String!
    var name:String!
    
    var SourceAnnotation = MKPointAnnotation()
    var DestinationAnnotation = MKPointAnnotation()

    @IBOutlet weak var MapViewLoc: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.MapViewLoc?.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        
        createPath(Lat: locationManager.location!.coordinate.latitude, lon: locationManager.location!.coordinate.longitude)
    }
    

    func displayMarkers(Lat:Double, Lon:Double, name:String){
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: Lat, longitude: Lon)
            annotation.title = name
            self.MapViewLoc.addAnnotation(annotation)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        MapViewLoc.removeAnnotation(SourceAnnotation)
    
        if let loc = locations.last{
    
            createPath(Lat: loc.coordinate.latitude, lon: loc.coordinate.longitude)
        }
        
        
    }
    
    
    func createPath(Lat : Double, lon : Double) {
        
        let destinationPlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(self.lat)!, longitude: Double(self.lon)!), addressDictionary: nil)
        let sourcePlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Lat, longitude: lon), addressDictionary: nil)
        
        
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        
        SourceAnnotation = MKPointAnnotation()
        SourceAnnotation.title = "Your Location"
        if let location = sourcePlaceMark.location {
            SourceAnnotation.coordinate = location.coordinate
        }
        
        DestinationAnnotation = MKPointAnnotation()
        DestinationAnnotation.title = self.name
        if let location = destinationPlaceMark.location {
            DestinationAnnotation.coordinate = location.coordinate
        }
        
        self.MapViewLoc.showAnnotations([SourceAnnotation, DestinationAnnotation], animated: true)
        
        
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .automobile
        
        let direction = MKDirections(request: directionRequest)
        
        direction.calculate { [self] (response, error) in
            guard let response = response else {
                if let error = error {
                    print("ERROR FOUND : \(error.localizedDescription)")
                    self.alert(Title: error.localizedDescription, Message: nil)
                }
                return
            }
            for o in MapViewLoc.overlays{
                MapViewLoc.removeOverlay(o)
            }
            let route = response.routes[0]
            self.MapViewLoc.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.MapViewLoc.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 3
            return renderer
    }

}

struct Locations {
    var name : String
    var coordinates : CLLocationCoordinate2D
}

extension MapViewController{
    func alert(Title:String, Message:String?) {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
