//
//  WebServicesHelper.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 4/11/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

let webServiceURL = "http://student.mydesign.central.wa.edu.au/cf_Wayfinding_WebService/WF_Service.svc?"

// Based on: http://stackoverflow.com/questions/30606146/ios-swift-call-web-service-using-soap
// Mostly based on: http://stackoverflow.com/questions/30652822/ios-swift-soap-message-with-ampersand-in-value

class WebServicesHelper: NSObject, NSURLConnectionDelegate, NSXMLParserDelegate {
    
    final private let METHOD_CHECK_SERVICE_CONNECTION = "checkServiceConn"
    final private let METHOD_CHECK_DATABASE_CONNECTION = "checkDBConn"
    final private let METHOD_GET_CAMPUSES = "SearchCampus"
    final private let METHOD_GET_ROOMS_BY_CAMPUS = "SearchRooms"

    // CheckServiceConn Body Example for Web Service:
    var is_SoapMessage: String = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cgs=\"http://tempuri.org/WF_Service_Interface/\"><soapenv:Header/><soapenv:Body><checkServiceConn xmlns='http://tempuri.org/'/></soapenv:Body></soapenv:Envelope>"
    
    func checkServiceConnection() {
        var is_URL: String = "http://student.mydesign.central.wa.edu.au/cf_Wayfinding_WebService/WF_Service.svc?"
        
        var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
        var session = NSURLSession.sharedSession()
        var err: NSError?
        
        lobj_Request.HTTPMethod = "POST"
        lobj_Request.HTTPBody = is_SoapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        lobj_Request.addValue("student.mydesign.central.wa.edu.au", forHTTPHeaderField: "Host") //CORRECT
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue(String((is_SoapMessage).characters.count), forHTTPHeaderField: "Content-Length")
        //lobj_Request.addValue("223", forHTTPHeaderField: "Content-Length")
        lobj_Request.addValue("http://tempuri.org/WF_Service_Interface/checkServiceConn", forHTTPHeaderField: "SOAPAction")
        
        var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Body: \(strData)")
            
            if error != nil
            {
                print("Error: " + error!.description)
            }
        })
        task.resume()
    }
}
