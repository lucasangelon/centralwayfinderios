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

typealias ThreadCompletion = () -> Void

class WebServicesHelper: NSObject, NSURLConnectionDelegate, NSXMLParserDelegate {
    
    // Constants (URL and Actions).
    final private let webServiceUrl = "http://student.mydesign.central.wa.edu.au/cf_Wayfinding_WebService/WF_Service.svc?"
    final private let checkServiceConnectionAction = "checkServiceConn"
    final private let checkDatabaseConnectionAction = "checkDBConn"
    final private let getCampusesAction = "SearchCampus"
    final private let getRoomsByCampusAction = "SearchRooms"
    final private let getBuildingAction = "ResolvePath"
    final private let deleteImagesAction = "deleteImagesIOS"
    final private let checkCampusVersionAction = "CampusVersion"
    
    // Base and End sections of the SOAP Message to be used.
    final private let baseStartSoapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wf=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body>"
    final private let baseEndSoapMessage = "</soapenv:Body></soapenv:Envelope>"
    
    private var xmlActionResult = [String]()
    var serviceConnection = String()
    var databaseConnection = String()
    var campuses: [Campus] = [Campus]()
    var rooms: [Room] = [Room]()
    var building: Building = Building()
    var postMapsInformation = [String]()
    var indoorMapsUrls = [String]()
    var sameVersion = Bool()
    
    // Checks if the Service and Server are online.
    func checkServiceConnection(completion: ThreadCompletion?) {
        
        // Defines the request.
        let request = NSMutableURLRequest(URL: NSURL(string: webServiceUrl)!)
        let session = NSURLSession.sharedSession()
        let _: NSError?
        let checkServiceConnectionMessage = baseStartSoapMessage + "<wf:" + checkServiceConnectionAction + "/>" + baseEndSoapMessage
        
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
            
            // Parses the XML retrieved through the request.
            if data != nil {
                self.parseXML(data!)
            }
            
            // If an error occurred, print the description for it.
            if error != nil
            {
                print("Error: " + error!.description)
            }
            
            // Runs the block of code sent by the view controller in order to
            // confirm the service call has finished.
            if let completion = completion {
                completion()
            }
        })
        
        // Resumes the task.
        task.resume()
    }
    
    // Checks if the Service Database is online.
    func checkDatabaseConnection(completion: ThreadCompletion?) {
        let request = NSMutableURLRequest(URL: NSURL(string: webServiceUrl)!)
        let session = NSURLSession.sharedSession()
        let _: NSError?
        let checkDatabaseConnectionMessage = baseStartSoapMessage + "<wf:" + checkDatabaseConnectionAction + "/>" + baseEndSoapMessage
        
        request.HTTPMethod = "POST"
        request.HTTPBody = checkDatabaseConnectionMessage.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("student.mydesign.central.wa.edu.au", forHTTPHeaderField: "Host")
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String((checkDatabaseConnectionMessage).characters.count), forHTTPHeaderField: "Content-Length")
        request.addValue("http://tempuri.org/WF_Service_Interface/" + checkDatabaseConnectionAction, forHTTPHeaderField: "SOAPAction")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if data != nil {
                self.parseXML(data!)
            }
            
            // If an error occurred, print the description for it.
            if error != nil
            {
                print("Error: " + error!.description)
            }
            
            // Runs the block of code sent by the view controller in order to
            // confirm the service call has finished.
            if let completion = completion {
                completion()
            }
        })
        
        task.resume()
    }
    
    // Retrieves the campuses from the Service Database.
    func downloadCampuses(completion: ThreadCompletion?) {
        let request = NSMutableURLRequest(URL: NSURL(string: webServiceUrl)!)
        let session = NSURLSession.sharedSession()
        let _: NSError?
        let getCampusesMessage = baseStartSoapMessage + "<wf:" + getCampusesAction + "/>" + baseEndSoapMessage
        
        request.HTTPMethod = "POST"
        request.HTTPBody = getCampusesMessage.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("student.mydesign.central.wa.edu.au", forHTTPHeaderField: "Host")
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String((getCampusesMessage).characters.count), forHTTPHeaderField: "Content-Length")
        request.addValue("http://tempuri.org/WF_Service_Interface/" + getCampusesAction, forHTTPHeaderField: "SOAPAction")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            // Uses a specific parser in order to properly retrieve the data from the XML file.
            let campusParser = CampusParser()
            
            if data != nil {
                self.campuses = campusParser.parseXML(data!)
            }
            
            // If an error occurred, print the description for it.
            if error != nil
            {
                print("Error: " + error!.description)
            }
            
            // Runs the block of code sent by the view controller in order to
            // confirm the service call has finished.
            if let completion = completion {
                completion()
            }
        })
        
        task.resume()
    }
    
    // Retrieves the rooms from a given campus from the service database.
    func downloadRooms(campusId: String, completion: ThreadCompletion?) {
        let request = NSMutableURLRequest(URL: NSURL(string: webServiceUrl)!)
        let session = NSURLSession.sharedSession()
        let _: NSError?
        
        // Sends a parameter for the method.
        let middleSoapMessage = "<wf:" + getRoomsByCampusAction + "><wf:CampusID>\(campusId)</wf:CampusID></wf:" + getRoomsByCampusAction + ">"
        let getRoomsMessage = baseStartSoapMessage + middleSoapMessage + baseEndSoapMessage

        request.HTTPMethod = "POST"
        request.HTTPBody = getRoomsMessage.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("student.mydesign.central.wa.edu.au", forHTTPHeaderField: "Host")
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String((getRoomsMessage).characters.count), forHTTPHeaderField: "Content-Length")
        request.addValue("http://tempuri.org/WF_Service_Interface/" + getRoomsByCampusAction, forHTTPHeaderField: "SOAPAction")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            // Uses a specific parser in order to properly retrieve the data from the XML file.
            let roomParser = RoomParser()
            
            if data != nil {
                self.rooms = roomParser.parseXML(data!)
            }
            
            // If an error occurred, print the description for it.
            if error != nil
            {
                print("Error: " + error!.description)
            }
            
            // Runs the block of code sent by the view controller in order to
            // confirm the service call has finished.
            if let completion = completion {
                completion()
            }
        })
        
        task.resume()
    }
    
    // Retrieves a given building based on a room id from the service database.
    func downloadBuilding(roomId: Int, buildingId: Int, completion: ThreadCompletion?) {
        let request = NSMutableURLRequest(URL: NSURL(string: webServiceUrl)!)
        let session = NSURLSession.sharedSession()
        let _: NSError?
        let accessibility = sharedDefaults.accessibility
        
        // Sends a parameter for the method.
        let middleSoapMessage = "<wf:" + getBuildingAction + "><wf:WaypointID>\(roomId)</wf:WaypointID><wf:Disability>\(accessibility)</wf:Disability></wf:" + getBuildingAction + ">"
        let getBuildingMessage = baseStartSoapMessage + middleSoapMessage + baseEndSoapMessage

        request.HTTPMethod = "POST"
        request.HTTPBody = getBuildingMessage.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("student.mydesign.central.wa.edu.au", forHTTPHeaderField: "Host")
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String((getBuildingMessage).characters.count), forHTTPHeaderField: "Content-Length")
        request.addValue("http://tempuri.org/WF_Service_Interface/" + getBuildingAction, forHTTPHeaderField: "SOAPAction")

        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let buildingParser = BuildingParser()
            buildingParser.requestedBuildingId = buildingId
            
            if data != nil {
                 buildingParser.parseXML(data!)
            }
            
            // If an error occurred, print the description for it.
            if error != nil
            {
                print("Error: " + error!.description)
            }
            
            // Runs the block of code sent from the view controller in order 
            //to wait for the web service to complete before continuing.
            if let completion = completion {
                completion()
            }
        })
        
        task.resume()
    }
    
    // Deletes the indoor image from the web service after use.
    func purgeIndoorMap(indoorPaths: [String]) {
        let request = NSMutableURLRequest(URL: NSURL(string: webServiceUrl)!)
        let session = NSURLSession.sharedSession()
        let _: NSError?
        
        var urls = String()
        
        if indoorPaths.count > 1 {
            for index in 0..<indoorPaths.count {
                if index != indoorPaths.count - 1 {
                    urls += indoorPaths[index] + "#YOLOSWAG"
                } else {
                    urls += indoorPaths[index]
                }
            }
        } else {
            urls += indoorPaths[0]
        }

        // Sends a parameter for the method.
        let middleSoapMessage = "<wf:" + deleteImagesAction + "><wf:urls>\(urls)</wf:urls></wf:" + deleteImagesAction + ">"
        let deleteImagesMessage = baseStartSoapMessage + middleSoapMessage + baseEndSoapMessage
        
        request.HTTPMethod = "POST"
        request.HTTPBody = deleteImagesMessage.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("student.mydesign.central.wa.edu.au", forHTTPHeaderField: "Host")
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String((deleteImagesMessage).characters.count), forHTTPHeaderField: "Content-Length")
        request.addValue("http://tempuri.org/WF_Service_Interface/" + deleteImagesAction, forHTTPHeaderField: "SOAPAction")

        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in

            // If an error occurred, print the description for it.
            if error != nil
            {
                print("Error: " + error!.description)
            }
        })
        
        task.resume()
    }
    
    // Checks a given campus version in the server database.
    func checkCampusVersion(campusVersion: Int, completion: ThreadCompletion?) {
        let request = NSMutableURLRequest(URL: NSURL(string: webServiceUrl)!)
        let session = NSURLSession.sharedSession()
        let _: NSError?
        
        // Sends a parameter for the method.
        let middleSoapMessage = "<wf:" + checkCampusVersionAction + "><wf:CampusID>\(sharedDefaults.campusId)</wf:CampusID></wf:" + checkCampusVersionAction + ">"
        let checkCampusVersionMessage = baseStartSoapMessage + middleSoapMessage + baseEndSoapMessage
        
        request.HTTPMethod = "POST"
        request.HTTPBody = checkCampusVersionMessage.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("student.mydesign.central.wa.edu.au", forHTTPHeaderField: "Host")
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String((checkCampusVersionMessage).characters.count), forHTTPHeaderField: "Content-Length")
        request.addValue("http://tempuri.org/WF_Service_Interface/" + checkCampusVersionAction, forHTTPHeaderField: "SOAPAction")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            let campusVersionParser = CampusVersionParser()
            campusVersionParser.applicationCampusVersion = campusVersion
            
            if data != nil {
                self.sameVersion = campusVersionParser.parseXML(data!)
            }
            
            // If an error occurred, print the description for it.
            if error != nil
            {
                print("Error: " + error!.description)
            }
            
            if let completion = completion {
                completion()
            }
        })
        
        task.resume()
    }
    
    /*
     * Get web service objects
     */
    
    // Returns the campuses.
    func getCampuses() -> [Campus] {
        return self.campuses
    }
    
    // Returns the rooms.
    func getRooms() -> [Room] {
        return self.rooms
    }
    
    // Returns the building.
    func getBuilding() -> Building {
        return self.building
    }
    
    // Returns the indoor map urls.
    func getIndoorMapsUrls() -> [String] {
        return self.indoorMapsUrls
    }
    
    // Returns information from the indoor maps.
    func getPostMapsInformation() -> [String] {
        return self.postMapsInformation
    }
    
    // Returns the version boolean.
    func getCampusVersionCheck() -> Bool {
        return self.sameVersion
    }
    
    // Checks if the campuses variable is not empty.
    func checkCampuses() -> Bool {
        if self.campuses.count < 1 {
            return false
        } else {
            return true
        }
    }
    
    // Checks if the rooms variable is not empty.
    func checkRooms() -> Bool {
        if self.rooms.count < 1 {
            return false
        } else {
            return true
        }
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
