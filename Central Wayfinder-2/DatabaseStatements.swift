//
//  DatabaseStatements.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 29/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

class DatabaseStatements {
    
    /* Table Creation Statements */
    
    let CREATE_TABLE_CAMPUS: String = "CREATE TABLE IF NOT EXISTS campus(id TEXT NOT NULL PRIMARY KEY, name TEXT NOT NULL, lat REAL NOT NULL, long REAL NOT NULL, zoom REAL NOT NULL);"
    
    let CREATE_TABLE_BUILDINGS: String = "CREATE TABLE IF NOT EXISTS building(id INTEGER NOT NULL PRIMARY KEY,  name TEXT NOT NULL, lat REAL NOT NULL, long REAL NOT NULL, campus_id TEXT NOT NULL);"
    
    let CREATE_TABLE_ROOMS: String = "CREATE TABLE IF NOT EXISTS room(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL, image TEXT, building_id INTEGER NOT NULL, campus_id TEXT NOT NULL);"
    
    
    /* Data Insertion Statements */
    
    let INSERT_CAMPUS: String = "INSERT INTO campus (id, name, lat, long, zoom) VALUES (?, ?, ?, ?, ?);"
    
    let INSERT_BUILDING: String = "INSERT INTO building (id, name, lat, long, campus_id) VALUES (?, ?, ?, ?, ?);"
    
    // Inserting a normal room in the table.
    let INSERT_ROOM: String = "INSERT INTO room (id, name, image, building_id, campus_id) VALUES (?, ?, NULL, ?, ?);"
    
    // Inserting a service location in the table.
    let INSERT_SERVICE: String = "INSERT INTO room (id, name, image, building_id, campus_id) VALUES (?, ?, ?, ?, ?);"
    
    
    /* Data Retrieval Statements */
    
    let SELECT_CAMPUS: String = "SELECT FROM campus WHERE id = (?);"
    
    let SELECT_ROOMS: String = "SELECT FROM room WHERE campus_id = (?);"
    
    let SELECT_SERVICES: String = "SELECT FROM room WHERE campus_id = (?) AND image IS NOT NULL;"
    
    let SELECT_SPECIFIC_ROOM: String = "SELECT FROM room WHERE name = (?);"
    
    let SELECT_BUILDING_BASED_ON_ROOM: String = "SELECT FROM building WHERE id = (?);"
    
    
    /* Data Removal Statements */
    
    // Removal upon Campus update.
    let DELETE_SELECTED_CAMPUS_ROOMS: String = "DELETE FROM room WHERE campus_id = (?) AND image != NULL;"
    
    let DELETE_SELECTED_CAMPUS_BUILDINGS: String = "DELETE FROM building WHERE campus_id = (?);"
    
    // Deletes the data within all tables if required.
    private let DELETE_DATA_FROM_ALL_TABLES: String = "DELETE FROM campus; DELETE FROM building; DELETE FROM room;"
    
    // Drop all tables if required.
    let DROP_ALL_TABLES: String = "DROP TABLE room; DROP TABLE building; DROP TABLE campus;"
    
    
    /* Test Data Methods */
    
    // Campuses
    func getTestCampuses() -> [Campus] {
        var campuses: [Campus] = [Campus]()
        
        campuses.append(Campus(id: "NC", name: "New Campus", lat: 22.2, long: 22.3, zoom: 10.0))
        campuses.append(Campus(id: "SC", name: "Second Campus", lat: 33.4, long: 32.476, zoom: 7.5))
        
        return campuses
    }
    
    // Buildings
    func getTestBuildings() -> [Building] {
        var buildings: [Building] = [Building]()
        
        buildings.append(Building(id: 1, name: "New Campus Building 1", lat: 22.2, long: 22.30003, campusId: "NC"))
        buildings.append(Building(id: 2, name: "New Campus Building 2", lat: 22.2, long: 22.4, campusId: "NC"))
        buildings.append(Building(id: 3, name: "Second Campus Building 1", lat: 33.4, long: 32.476555, campusId: "SC"))
        
        return buildings
    }
    
    // Rooms
    func getTestRooms() -> [Room] {
        var rooms: [Room] = [Room]()
        
        rooms.append(Room(id: 1, name: "B223", image: "NoImage", buildingId: 1, campusId: "NC"))
        rooms.append(Room(id: 2, name: "C132", image: "NoImage", buildingId: 1, campusId: "NC"))
        rooms.append(Room(id: 3, name: "Student Services", image: "ss.jpg", buildingId: 2, campusId: "NC"))
        rooms.append(Room(id: 4, name: "International Center", image: "ic.jpg", buildingId: 3, campusId: "SC"))
        rooms.append(Room(id: 5, name: "D444", image: "NoImage", buildingId: 3, campusId: "SC"))
        rooms.append(Room(id: 6, name: "Koolark Center", image: "kc.jpg", buildingId: 3, campusId: "SC"))
        
            return rooms
    }
    
    func clearTest() -> String {
        return self.DELETE_DATA_FROM_ALL_TABLES
    }
}