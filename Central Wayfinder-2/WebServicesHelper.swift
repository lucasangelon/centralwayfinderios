//
//  WebServicesHelper.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 4/11/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

let WebServiceURL = "http://student.mydesign.central.wa.edu.au/cf_Wayfinding_WebService/WF_Service.svc"

class WebServicesHelper {
    //let swiftyJSON: SwiftyJSON!
    
    final private let METHOD_CHECK_SERVICE_CONNECTION = "checkServiceConn"
    final private let METHOD_CHECK_DATABASE_CONNECTION = "checkDBConn"
    final private let METHOD_GET_CAMPUSES = "SearchCampus"
    final private let METHOD_GET_ROOMS_BY_CAMPUS = "SearchRooms"
    
    private var checkServiceResult: Bool?
    
    func getCampusesFromService() {
        
    }

}