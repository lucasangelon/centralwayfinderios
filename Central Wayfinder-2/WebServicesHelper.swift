//
//  WebServicesHelper.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 4/11/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

// Based on: http://stackoverflow.com/questions/30606146/ios-swift-call-web-service-using-soap
// Mostly based on: http://stackoverflow.com/questions/30652822/ios-swift-soap-message-with-ampersand-in-value

class WebServicesHelper: NSObject, NSURLConnectionDelegate, NSXMLParserDelegate {
    
    // Constants (URL and Actions).
    final private let webServiceUrl = "http://student.mydesign.central.wa.edu.au/cf_Wayfinding_WebService/WF_Service.svc?"
    final private let checkServiceConnectionAction = "checkServiceConn"
    final private let checkDatabaseConnectionAction = "checkDBConn"
    final private let getCampusesAction = "SearchCampus"
    final private let getRoomsByCampusAction = "SearchRooms"
    
    // Base and End sections of the SOAP Message to be used.
    final private let baseStartSoapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body>"
    final private let baseEndSoapMessage = "</soapenv:Body></soapenv:Envelope>"
    
    private var xmlActionResult = [String]()
    var serviceConnection = String()
    var databaseConnection = String()
    var campuses: [Campus] = [Campus]()
    
    // Checks if the Service and Server are online.
    func checkServiceConnection() {
        
        // Defines the request.
        let request = NSMutableURLRequest(URL: NSURL(string: webServiceUrl)!)
        let session = NSURLSession.sharedSession()
        let _: NSError?
        let checkServiceConnectionMessage = baseStartSoapMessage + "<" + checkServiceConnectionAction + " xmlns='http://tempuri.org/'/>" + baseEndSoapMessage
        
        // Adds information to it.
        request.HTTPMethod = "POST"
        request.HTTPBody = checkServiceConnectionMessage.dataUsingEncoding(NSUTF8StringEncoding)
        
        // The host for the message, unsure about it being "required" as the documentation mentions it should not be changed.
        request.addValue("student.mydesign.central.wa.edu.au", forHTTPHeaderField: "Host")
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String((checkServiceConnectionMessage).characters.count), forHTTPHeaderField: "Content-Length")
        
        // Adds the link to the action, it must use tempuri.org as it is 
        // the way it was defined on the web service.
        request.addValue("http://tempuri.org/WF_Service_Interface/" + checkServiceConnectionAction, forHTTPHeaderField: "SOAPAction")
        
        // Defines the task.
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            // Prints the response in order to test the service.
            //print("Response: \(response)")
            
            // Prints the actual data for testing purposes as well.
            //let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print("Body: \(strData)")
            
            // Parses the XML retrieved through the request.
            self.parseXML(data!)
            
            // If an error occurred, print the description for it.
            if error != nil
            {
                print("Error: " + error!.description)
            }
        })
        
        // Resumes the task.
        task.resume()
    }
    
    // Checks if the Service Database is online.
    func checkDatabaseConnection() {
        let request = NSMutableURLRequest(URL: NSURL(string: webServiceUrl)!)
        let session = NSURLSession.sharedSession()
        let _: NSError?
        let checkServiceConnectionMessage = baseStartSoapMessage + "<" + checkDatabaseConnectionAction + " xmlns='http://tempuri.org/'/>" + baseEndSoapMessage
        
        request.HTTPMethod = "POST"
        request.HTTPBody = checkServiceConnectionMessage.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("student.mydesign.central.wa.edu.au", forHTTPHeaderField: "Host")
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String((checkServiceConnectionMessage).characters.count), forHTTPHeaderField: "Content-Length")
        request.addValue("http://tempuri.org/WF_Service_Interface/" + checkDatabaseConnectionAction, forHTTPHeaderField: "SOAPAction")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            self.parseXML(data!)
            
            // If an error occurred, print the description for it.
            if error != nil
            {
                print("Error: " + error!.description)
            }
        })
        
        task.resume()
    }
    
    // Retrieves the campuses from the Service Database.
    func downloadCampuses() {
        let request = NSMutableURLRequest(URL: NSURL(string: webServiceUrl)!)
        let session = NSURLSession.sharedSession()
        let _: NSError?
        let checkServiceConnectionMessage = baseStartSoapMessage + "<" + getCampusesAction + " xmlns='http://tempuri.org/'/>" + baseEndSoapMessage
        
        request.HTTPMethod = "POST"
        request.HTTPBody = checkServiceConnectionMessage.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("student.mydesign.central.wa.edu.au", forHTTPHeaderField: "Host")
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String((checkServiceConnectionMessage).characters.count), forHTTPHeaderField: "Content-Length")
        request.addValue("http://tempuri.org/WF_Service_Interface/" + getCampusesAction, forHTTPHeaderField: "SOAPAction")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let campusParser = CampusParser()
            self.campuses = campusParser.parseXML(data!)
            
            // If an error occurred, print the description for it.
            if error != nil
            {
                print("Error: " + error!.description)
            }
        })
        
        task.resume()
    }
    
    // Returns the campuses.
    func getCampuses() -> [Campus] {
        return self.campuses
    }
    
    /*
     * XML Parser Methods
     */
    
    var element = NSString()
    
    func parseXML(data: NSData) {
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        // If the element title matches any of the following, assign to the specific
        // variable.
        if element.isEqualToString("checkServiceConnResult") {
            serviceConnection = string
        } else if element.isEqualToString("checkDBConnResult") {
            databaseConnection = string
        }
    }
}
