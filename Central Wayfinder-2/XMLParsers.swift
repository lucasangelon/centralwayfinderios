//
//  XMLParsers.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 8/11/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

// Specific Campus Parser.
class CampusParser: NSObject, NSXMLParserDelegate {
    
    private var currentCampus: Campus?
    private var campuses: [Campus] = [Campus]()
    private var element = NSString()
    
    // Counter for the strings inside an array. Due to the fact they all have
    // the same name, the switch iteration handles each campus detail properly.
    var theIndex = 0
    
    // Parses the XML.
    func parseXML(data: NSData) -> [Campus] {
        currentCampus = Campus()
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        parser.parse()
        
        return campuses
    }
    
    // Detects the start of an element and assigns it to the variable.
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
    }
    
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    }
    
    // If anything was found inside a key/value pair, this method is activated.
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString("a:string") {
            switch theIndex {
            case 0:
                currentCampus?.id = string
                theIndex++
            case 1:
                currentCampus?.name = string
                theIndex++
            case 2:
                currentCampus?.version = Int(string)!
                theIndex++
            case 3:
                currentCampus?.lat = Double(string)!
                theIndex++
            case 4:
                currentCampus?.long = Double(string)!
                theIndex++
            case 5:
                currentCampus?.zoom = Double(string)!
                
                // Resets the currentCampus for the next instance and appends
                // the result to the array.
                campuses.append(currentCampus!)
                currentCampus = Campus()
                theIndex = 0
                
            default:
                break
            }
        }
    }
}

class RoomParser: NSObject, NSXMLParserDelegate {
    private var currentRoom: Room?
    private var rooms: [Room] = [Room]()
    private var element = NSString()
    
    // Counter for the strings inside an array. Due to the fact they all have
    // the same name, the switch iteration handles each room detail properly.
    var theIndex = 0
    
    // Parses the XML.
    func parseXML(data: NSData) -> [Room] {
        currentRoom = Room()
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        parser.parse()
        
        return rooms
    }
    
    // Detects the start of an element and assigns it to the variable.
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    }
    
    // If anything was found inside a key/value pair, this method is activated.
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString("a:string") {
            switch theIndex {
            case 0:
                currentRoom?.id = Int(string)!
                theIndex++
            case 1:
                currentRoom?.name = string
                theIndex++
            case 2:
                currentRoom?.buildingId = Int(string)!
                theIndex++
            case 3:
                currentRoom?.image = string
                
                // Resets the currentCampus for the next instance and appends
                // the result to the array.
                rooms.append(currentRoom!)
                currentRoom = Room()
                theIndex = 0
                
            default:
                break
            }
        }
    }
}


// TODO: finish this method once the webservice has been fixed.
class BuildingParser: NSObject, NSXMLParserDelegate {
    
    private var building: Building?
    private var element = NSString()
    var requestedBuildingId = 0
    private var postMapsInformation = ""
    private var postMapsUrl = ""
    
    // Counter for the strings inside an array. Due to the fact they all have
    // the same name, the switch iteration handles each building/indoor map
    // detail properly.
    var theIndex = 0
    
    // Parses the XML.
    func parseXML(data: NSData) -> [NSObject] {
        building = Building()
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        parser.parse()
        
        var objectsArray = [NSObject]()
        objectsArray.append(building!)
        objectsArray.append(postMapsInformation)
        objectsArray.append(postMapsUrl)
        return objectsArray
    }
    
    // Detects the start of an element and assigns it to the variable.
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
        print(elementName + "opening")
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print(elementName + "closing")
        if elementName.containsString("b:string/") {
            building?.image = "http://central.wa.edu.au/Style%20Library/CIT.Internet.Branding/images/Central-Institute-of-Technology-logo.gif"
        }
    }

    // If anything was found inside a key/value pair, this method is activated.
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        print(element)
        print(string)
        print(theIndex)
        if element.isEqualToString("b:string") {
            switch theIndex {
            case 0:
                building?.lat = Double(string)!
                theIndex++
            case 1:
                building?.long = Double(string)!
                theIndex++
            case 2:
                building?.name = string
                theIndex++
            //case 3:
                //if element == "" {
                //    building?.image = "http://central.wa.edu.au/Style%20Library/CIT.Internet.Branding/images/Central-Institute-of-Technology-logo.gif"
                //} else {
                    building?.image = "http://central.wa.edu.au/Style%20Library/CIT.Internet.Branding/images/Central-Institute-of-Technology-logo.gif"
                //}
                
                building?.id = requestedBuildingId
                building?.campusId = sharedDefaults.campusId
                //theIndex++
            case 3:
                postMapsInformation = string
                theIndex++
            case 4:
                postMapsUrl = string
                theIndex++
            default:
                break
            }
        }
    }
}