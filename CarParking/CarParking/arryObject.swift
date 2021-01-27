//
//  arryObject.swift
//  CarParking
//
//  Created by Venkat 101287100 on 2021-01-24.
//

import Foundation

class arryObject{
    
    var BCode:String!
    var Hours:String!
    var SuitNo:String!
    var CNumber:String!
    var Date:Date!
    var Lat:String!
    var Lon:String!
    var Location:String!
    var Email:String
    
    init(bcode:String, hours:String, suitNo:String, cNumber:String, date:Date, lat:String, Lon:String, Location:String, email:String) {
        
        self.BCode = bcode
        self.Hours = hours
        self.SuitNo = suitNo
        self.CNumber = cNumber
        self.Date = date
        self.Lat = lat
        self.Lon = Lon
        self.Location = Location
        self.Email = email
        
    }
    
    
    
}
