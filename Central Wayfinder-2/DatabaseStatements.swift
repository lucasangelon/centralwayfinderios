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
    
    let CREATE_TABLE_CAMPUS: String = "CREATE TABLE IF NOT EXISTS campus(id TEXT NOT NULL PRIMARY KEY, name TEXT NOT NULL, version INTEGER NOT NULL, lat REAL NOT NULL, long REAL NOT NULL, zoom REAL NOT NULL);"
    
    let CREATE_TABLE_BUILDINGS: String = "CREATE TABLE IF NOT EXISTS building(id INTEGER NOT NULL PRIMARY KEY,  name TEXT NOT NULL, lat REAL NOT NULL, long REAL NOT NULL, image TEXT NOT NULL, campus_id TEXT NOT NULL);"
    
    let CREATE_TABLE_ROOMS: String = "CREATE TABLE IF NOT EXISTS room(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL, image TEXT, building_id INTEGER NOT NULL, campus_id TEXT NOT NULL);"
    
    
    /* Data Insertion Statements */
    
    let INSERT_CAMPUS: String = "INSERT INTO campus (id, name, version, lat, long, zoom) VALUES (?, ?, ?, ?, ?, ?);"
    
    let INSERT_BUILDING: String = "INSERT INTO building (id, name, lat, long, image, campus_id) VALUES (?, ?, ?, ?, ?, ?);"
    
    // Inserting a normal room in the table.
    let INSERT_ROOM: String = "INSERT INTO room (id, name, image, building_id, campus_id) VALUES (?, ?, ?, ?, ?);"
    
    // Inserting a service location in the table.
    let INSERT_SERVICE: String = "INSERT INTO room (id, name, image, building_id, campus_id) VALUES (?, ?, ?, ?, ?);"
    
    
    /* Data Retrieval Statements */
    
    let GET_ALL_CAMPUSES: String = "SELECT * FROM campus;"
    
    let SELECT_CAMPUS: String = "SELECT * FROM campus WHERE id = (?);"
    
    let SELECT_CAMPUS_VERSION: String = "SELECT version FROM campus WHERE id = (?)"
    
    let SELECT_ROOMS: String = "SELECT * FROM room WHERE campus_id = (?);"
    
    let SELECT_SERVICES: String = "SELECT * FROM room WHERE campus_id = (?) AND image != 'NoImage';"
    
    let SELECT_SPECIFIC_ROOM: String = "SELECT * FROM room WHERE name = (?);"
    
    let SELECT_BUILDING_BASED_ON_ROOM: String = "SELECT * FROM building WHERE id = (?);"
    
    
    /* Data Removal Statements */
    
    // Removal upon Campus update.
    let DELETE_SELECTED_CAMPUS_ROOMS: String = "DELETE FROM room WHERE campus_id = (?);"
    
    let DELETE_SELECTED_CAMPUS_BUILDINGS: String = "DELETE FROM building WHERE campus_id = (?);"
    
    // Deletes the data within all tables if required.
    private let DELETE_DATA_FROM_ALL_TABLES: String = "DELETE FROM campus; DELETE FROM building; DELETE FROM room;"
    
    // Drop all tables if required.
    let DROP_ALL_TABLES: String = "DROP TABLE room; DROP TABLE building; DROP TABLE campus;"
    
    
    /* Test Data Methods */
    
    // Campuses
    func getTestCampuses() -> [Campus] {
        var campuses: [Campus] = [Campus]()
        
        campuses.append(Campus(id: "EP", name: "East Perth", version: 0, lat: -31.9512138366699, long: 115.872375488281, zoom: 19))
        campuses.append(Campus(id: "LE", name: "Leederville", version: 0, lat: -31.9339389801025, long: 115.842643737793, zoom: 19.5))
        campuses.append(Campus(id: "ML", name: "Mount Lawley", version: 0, lat: -31.939432144165, long: 115.875679016113, zoom: 19.5))
        campuses.append(Campus(id: "OHCWA", name: "Nedlands", version: 0, lat: -31.9700088500977, long: 115.81575012207, zoom: 19.5))
        campuses.append(Campus(id: "PE", name: "Perth", version: 0, lat: -31.9476680755615, long: 115.862129211426, zoom: 18.75))
        campuses.append(Campus(id: "TE", name: "Test", version: 0,lat: 2.2, long: 99.99999999, zoom: 1.5))
        
        return campuses
    }
    
    // Buildings
    func getTestBuildings() -> [Building] {
        var buildings: [Building] = [Building]()
        
        buildings.append(Building(id: 1, name: "Building 1", lat: 22.2, long: 22.30003, image: "NoImage", campusId: "PE"))
        buildings.append(Building(id: 2, name: "Building 2", lat: -31.947358, long: 115.861375, image: "NoImage", campusId: "PE"))
        buildings.append(Building(id: 3, name: "Building 3", lat: -31.948004, long: 115.860957, image: "NoImage", campusId: "PE"))
        buildings.append(Building(id: 4, name: "Building 1", lat: 11.1, long: 12.1, image: "NoImage", campusId: "LE"))
        buildings.append(Building(id: 5, name: "Building 4", lat: -31.9474773406982, long: 115.863143920898, image: "NoImage", campusId: "PE"))
        
        return buildings
    }
    
    // Rooms
    func getTestRooms() -> [Room] {
        var rooms: [Room] = [Room]()
        
        rooms.append(Room(id: 1, name: "B223", image: "NoImage", buildingId: 1, campusId: "PE"))
        rooms.append(Room(id: 2, name: "C132", image: "NoImage", buildingId: 1, campusId: "PE"))
        rooms.append(Room(id: 3, name: "Student Services", image: "ss.jpg", buildingId: 2, campusId: "PE"))
        rooms.append(Room(id: 4, name: "International Center", image: "ic.jpg", buildingId: 3, campusId: "PE"))
        rooms.append(Room(id: 5, name: "D444", image: "NoImage", buildingId: 3, campusId: "PE"))
        rooms.append(Room(id: 6, name: "Koolark Center", image: "kc.jpg", buildingId: 4, campusId: "LE"))
        rooms.append(Room(id: 7, name: "D212", image: "NoImage", buildingId: 5, campusId: "PE"))
        
            return rooms
    }
    
    func clearTest() -> String {
        return self.DELETE_DATA_FROM_ALL_TABLES
    }
}