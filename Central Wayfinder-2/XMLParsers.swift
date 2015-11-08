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
                currentCampus?.lat = Double(string)!
                theIndex++
            case 3:
                currentCampus?.long = Double(string)!
                theIndex++
            case 4:
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