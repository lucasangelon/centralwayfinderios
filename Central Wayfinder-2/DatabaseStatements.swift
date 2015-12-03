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
    
    let CREATE_TABLE_CAMPUS = "CREATE TABLE IF NOT EXISTS campus(id TEXT NOT NULL PRIMARY KEY, name TEXT NOT NULL, version INTEGER NOT NULL, lat REAL NOT NULL, long REAL NOT NULL, zoom REAL NOT NULL);"
    
    let CREATE_TABLE_ROOMS = "CREATE TABLE IF NOT EXISTS room(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL, image TEXT, building_id INTEGER NOT NULL, campus_id TEXT NOT NULL);"
    
    /* Data Check Statements */
    
    let CHECK_CAMPUSES = "SELECT COUNT(*) FROM campus"
    
    
    /* Data Insertion Statements */
    
    let INSERT_CAMPUS = "INSERT INTO campus (id, name, version, lat, long, zoom) VALUES (?, ?, ?, ?, ?, ?);"
    
    // Inserting a normal room in the table.
    let INSERT_ROOM = "INSERT INTO room (id, name, image, building_id, campus_id) VALUES (?, ?, ?, ?, ?);"
    
    // Inserting a service location in the table.
    let INSERT_SERVICE = "INSERT INTO room (id, name, image, building_id, campus_id) VALUES (?, ?, ?, ?, ?);"
    
    
    /* Data Retrieval Statements */
    
    let SELECT_ALL_CAMPUSES = "SELECT * FROM campus;"
    
    let SELECT_CAMPUS = "SELECT * FROM campus WHERE id = (?);"
    
    let SELECT_CAMPUS_VERSION = "SELECT version FROM campus WHERE id = (?)"
    
    let SELECT_ROOMS = "SELECT * FROM room WHERE campus_id = (?);"
    
    let SELECT_SERVICES = "SELECT * FROM room WHERE campus_id = (?) AND image != 'NoImage';"
    
    let SELECT_SPECIFIC_ROOM = "SELECT * FROM room WHERE name = (?);"
    
    
    /* Data Removal Statements */
    
    // Removal upon Campus update.
    let DELETE_SELECTED_CAMPUS_ROOMS = "DELETE FROM room WHERE campus_id = (?);"
    
    // Remove all rooms in the table.
    let DELETE_ALL_ROOMS = "DELETE FROM room;"
    
    // Deletes the data within all tables if required.
    private let DELETE_DATA_FROM_ALL_TABLES = "DELETE FROM campus; DELETE FROM room;"
    
    // Drop all tables if required.
    let DROP_ALL_TABLES = "DROP TABLE room; DROP TABLE campus;"
}