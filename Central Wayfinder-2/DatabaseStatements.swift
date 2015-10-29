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
    
    let CREATE_TABLE_CAMPUS: String = "CREATE TABLE campus(id TEXT NOT NULL PRIMARY KEY, name TEXT NOT NULL, lat REAL NOT NULL, long REAL NOT NULL, zoom REAL NOT NULL);"
    
    let CREATE_TABLE_BUILDINGS: String = "CREATE TABLE building(id INTEGER NOT NULL PRIMARY KEY,  name TEXT NOT NULL, lat REAL NOT NULL, long REAL NOT NULL, campus_id TEXT NOT NULL);"
    
    let CREATE_TABLE_ROOMS: String = "CREATE TABLE room(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL, image TEXT, building_id INTEGER NOT NULL, campus_id TEXT NOT NULL);"
    
    
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
    
    // Drop all tables if required.
    let DROP_ALL_TABLES: String = "DROP TABLE room; DROP TABLE building; DROP TABLE campus;"
    
    
    // Insert Test Data.
    func getTestCampus() -> [Campus] {
        var campuses: [Campus] = [Campus]()
        
        campuses.append(Campus)
    }
}