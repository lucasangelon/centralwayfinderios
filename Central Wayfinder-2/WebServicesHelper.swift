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
    final private let getBuildingAction = "ResolvePath"
    final private let getImageAction = "getImage"
    
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
    
    // Checks if the Service and Server are online.
    func checkServiceConnection() {
        
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
        })
        
        // Resumes the task.
        task.resume()
    }
    
    // Checks if the Service Database is online.
    func checkDatabaseConnection() {
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
        })
        
        task.resume()
    }
    
    // Retrieves the campuses from the Service Database.
    func downloadCampuses() {
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
            
            
            // Prints the response in order to test the service.
            print("Response: \(response)")
            
            // Prints the actual data for testing purposes as well.
            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Body: \(strData)")
            }
            
            // If an error occurred, print the description for it.
            if error != nil
            {
                print("Error: " + error!.description)
            }
        })
        
        task.resume()
    }
    
    // Retrieves the rooms from a given campus from the service database.
    func downloadRooms(campusId: String) {
        let request = NSMutableURLRequest(URL: NSURL(string: webServiceUrl)!)
        let session = NSURLSession.sharedSession()
        let _: NSError?
        
        // Sends a parameter for the method.
        let middleSoapMessage = "<wf:" + getRoomsByCampusAction + "><wf:CampusID>\(campusId)</wf:CampusID></wf:" + getRoomsByCampusAction + ">"
        let getRoomsMessage = baseStartSoapMessage + middleSoapMessage + baseEndSoapMessage
        print(getRoomsMessage)
        
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
        })
        
        task.resume()
    }
    
    // Retrieves a given building based on a room id from the service database.
    func downloadBuilding(roomId: Int, buildingId: Int) {
        let request = NSMutableURLRequest(URL: NSURL(string: webServiceUrl)!)
        let session = NSURLSession.sharedSession()
        let _: NSError?
        let disability = sharedDefaults.accessibility
        var objectsArray = [NSObject]()
        
        // Sends a parameter for the method.
        let middleSoapMessage = "<wf:" + getBuildingAction + "><wf:WaypointID>\(roomId)</wf:WaypointID><wf:Disability>\(disability)</wf:Disability></wf:" + getBuildingAction + ">"
        let getBuildingMessage = baseStartSoapMessage + middleSoapMessage + baseEndSoapMessage
        print(getBuildingMessage)
        request.HTTPMethod = "POST"
        request.HTTPBody = getBuildingMessage.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("student.mydesign.central.wa.edu.au", forHTTPHeaderField: "Host")
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String((getBuildingMessage).characters.count), forHTTPHeaderField: "Content-Length")
        request.addValue("http://tempuri.org/WF_Service_Interface/" + getBuildingAction, forHTTPHeaderField: "SOAPAction")
        print(request.HTTPBody)
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let buildingParser = BuildingParser()
            buildingParser.requestedBuildingId = buildingId
            
            if data != nil {
                objectsArray = buildingParser.parseXML(data!)
            
                self.building = objectsArray[0] as! Building
                
                // Downloads the building image.
                sharedIndoorMaps.downloadBuildingImage(self.building.image)
                
                sharedInstance.insertBuilding(self.building)
                self.postMapsInformation.append(objectsArray[1] as! String)
                self.postMapsInformation.append(objectsArray[2] as! String)
                self.indoorMapsUrls.append(self.postMapsInformation[1])
                
                // Downloads the indoor map, transform this into a loop if multiple indoor maps required.
                sharedIndoorMaps.downloadIndoorMap(self.postMapsInformation[1], title: self.postMapsInformation[0])
            }
            
            // If an error occurred, print the description for it.
            if error != nil
            {
                print("Error: " + error!.description)
            }
        })
        
        task.resume()
    }
    
    // Deletes the indoor image from the web service after use.
    func purgeIndoorMap(var indoorPaths: [String]) {
        let request = NSMutableURLRequest(URL: NSURL(string: webServiceUrl)!)
        let session = NSURLSession.sharedSession()
        let _: NSError?
        
        for index in 0..<indoorPaths.count {
        
            // Sends a parameter for the method.
            let middleSoapMessage = "<wf:" + getImageAction + "><wf:path>\(indoorPaths[index])</wf:path></wf:" + getImageAction + ">"
            let getBuildingMessage = baseStartSoapMessage + middleSoapMessage + baseEndSoapMessage
            print(getBuildingMessage)
            request.HTTPMethod = "POST"
            request.HTTPBody = getBuildingMessage.dataUsingEncoding(NSUTF8StringEncoding)
            request.addValue("student.mydesign.central.wa.edu.au", forHTTPHeaderField: "Host")
            request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue(String((getBuildingMessage).characters.count), forHTTPHeaderField: "Content-Length")
            request.addValue("http://tempuri.org/WF_Service_Interface/" + getImageAction, forHTTPHeaderField: "SOAPAction")
            print(request.HTTPBody)
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                // If an error occurred, print the description for it.
                if error != nil
                {
                    print("Error: " + error!.description)
                }
            })
            
            task.resume()
        }
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
