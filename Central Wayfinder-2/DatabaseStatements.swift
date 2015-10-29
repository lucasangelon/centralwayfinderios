//
//  DatabaseStatements.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 29/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

class DatabaseStatements {
    
    let CREATE_TABLE_CAMPUS: String = "CREATE TABLE [campuses] ('Campus_ID' TEXT NOT NULL PRIMARY KEY, 'Campus_Name' TEXT NOT NULL, 'Campus_Lat' REAL NOT NULL, 'Campus_Long' REAL NOT NULL, 'Campus_Zoom' REAL NOT NULL);"
    
    let CREATE_TABLE_BUILDINGS: String = "CREATE TABLE [buildings] ('Building_ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 'Campus_ID' TEXT NOT NULL, 'Building_Name' TEXT NOT NULL, 'Building_Path' TEXT NOT NULL, 'Building_Address' TEXT NOT NULL, 'Building_Lat' REAL NOT NULL, 'Building_Long' REAL NOT NULL);"
    
    let CREATE_TABLE_CAMPUS_LOCATIONS: String = "CREATE TABLE [campus_locations] ('Campus_ID' TEXT NOT NULL, 'Waypoint_ID' INTEGER NOT NULL, 'Campus_Location_Category_ID' TEXT, PRIMARY KEY (Campus_ID,Waypoint_ID));"
    
    let CREATE_TABLE_CAMPUS_LOCATION_CATEGORIES: String = "CREATE TABLE [campus_location_categories] ('Campus_Location_Category_ID' TEXT NOT NULL PRIMARY KEY, 'Campus_Location_Category_Name' TEXT NOT NULL);"
    
    let CREATE_TABLE_FLOORS: String = "CREATE TABLE [floors] ('Floor_ID' INTEGER NOT NULL AUTOINCREMENT, 'Building_ID' INTEGER NOT NULL, 'Floor_Map' TEXT NOT NULL, 'Floor_Color_Map' TEXT NOT NULL, PRIMARY KEY (Floor_ID,Building_ID));"
    
    let CREATE_TABLE_WAYPOINTS: String = "CREATE TABLE [waypoints] ('Waypoint_ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 'Building_ID' INTEGER NOT NULL, 'Floor_ID' INTEGER NOT NULL, 'Waypoint_ID_Prev' INTEGER, 'Waypoint_ID_Prev_Dis' INTEGER, 'Coord_X' REAL NOT NULL, 'Coord_Y' REAL NOT NULL, 'Room_Name' TEXT, 'Transition_Mode' TEXT);"
    
    
}