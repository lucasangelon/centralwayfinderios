//
//  DatabaseManager.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 23/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

// Based on: http://www.techotopia.com/index.php/An_Example_SQLite_based_iOS_8_Application_using_Swift_and_FMDB

// Check this for Queue FMDB: http://metrozines.com/
let sharedInstance = DatabaseManager()

// Handles the database interaction.
class DatabaseManager : NSObject {
    
    let dbStatements: DatabaseStatements = DatabaseStatements()
    
    var databasePath = NSString()
    var queue: FMDatabaseQueue?
    
    // Finds the file and sets it up.
    func setupDatabase() {
        
        let filemgr = NSFileManager.defaultManager()
        
        // Gets the database from the folder.
        let documentFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        databasePath = documentFolder.stringByAppendingString("centralWayfinder.db")
        
        // If the file does not exist, generate a new one.
        if !filemgr.fileExistsAtPath(databasePath as String) {
            
            // Create the database using the generated path.
            let centralWayfinderDB = FMDatabase(path: databasePath as String)
            
            // If it is nil, print the last error message.
            if centralWayfinderDB == nil {
                print("Error: \(centralWayfinderDB.lastErrorMessage())")
            } else {
                print("Database loaded successfully.")
            }
        }
    }
    
    // Sets up the queue and creates / checks tables in the database.
    func setupQueue() {
        
        // Defines the queue.
        queue = FMDatabaseQueue(path: databasePath as String)
        
        // Use the queue.
        queue?.inDatabase() {
            db in
            
            // Create the tables in the database if they do not already exist.
            let success = db.executeStatements(self.dbStatements.CREATE_TABLE_CAMPUS + self.dbStatements.CREATE_TABLE_BUILDINGS + self.dbStatements.CREATE_TABLE_ROOMS)
            
            // If unsuccessful, print the error.
            if !success {
                print("Table Creation Failure: \(db.lastErrorMessage())")
            }
            
            // Otherwise check the tables to see if they are there.
            else {
                print("Table Creation Statements were successful.")
                print(db.tableExists("campus"))
                print(db.tableExists("building"))
                print(db.tableExists("room"))
            }
        }
    }
    
    
    /* Database Interaction */
    
    // Returns all available campuses.
    func getCampuses(var campuses: [Campus]) -> [Campus]{
        queue?.inDatabase() {
            db in
            
            let resultSet: FMResultSet = db.executeQuery(self.dbStatements.GET_ALL_CAMPUSES, withArgumentsInArray: nil)
            
            while resultSet.next() {
                campuses.append(Campus(id: resultSet.stringForColumn("id"), name: resultSet.stringForColumn("name"), lat: resultSet.doubleForColumn("lat"), long: resultSet.doubleForColumn("long"), zoom: resultSet.doubleForColumn("zoom")))
            }
            
            // Ensures the resultSet is closed in order to avoid leaks.
            resultSet.close()
        }
        
        return campuses
    }
    
    // Returns a single Campus.
    func getCampus(id: String, var campus: Campus) -> Campus {
        queue?.inDatabase() {
            db in
            
            let result: FMResultSet = db.executeQuery(self.dbStatements.SELECT_CAMPUS, withArgumentsInArray: [id])
            
            if result.next() {
                campus = Campus(id: result.stringForColumn("id"), name: result.stringForColumn("name"), lat: result.doubleForColumn("lat"), long: result.doubleForColumn("long"), zoom: result.doubleForColumn("zoom"))
                
                // Ensures result is closed.
                result.close()
            }
        }
        return campus
    }
    
    /* Test Functions */
    
    // Inserts test data.
    func prepareTestData() {
        queue?.inDatabase() {
            db in
            
            var success: Bool = Bool()
            
            // Define a temporary Campus object and retrieve the test data.
            var tempCampus: Campus!
            let campuses = self.dbStatements.getTestCampuses()
            
            // Add the test campuses to the table.
            for index in 0...(campuses.count - 1) {
                tempCampus = campuses[index]
                
                success = db.executeUpdate(self.dbStatements.INSERT_CAMPUS, withArgumentsInArray: [(tempCampus.id), (tempCampus.name), (tempCampus.lat), (tempCampus.long), (tempCampus.zoom)])
                
                if success {
                    print(tempCampus.name + " added to the database.")
                } else {
                    print("An error has occured: \(db.lastErrorMessage())")
                }
            }
            
            var tempBuilding: Building!
            let buildings = self.dbStatements.getTestBuildings()
            
            // Add the test buildings to the table.
            for index in 0...(buildings.count - 1) {
                tempBuilding = buildings[index]
                
                success = db.executeUpdate(self.dbStatements.INSERT_BUILDING, withArgumentsInArray: [(tempBuilding.id), (tempBuilding.name), (tempBuilding.lat), (tempBuilding.long), (tempBuilding.campusId)])
                
                if success {
                    print(tempBuilding.name + " added to the database.")
                } else {
                    print("An error has occurred: \(db.lastErrorMessage())")
                }
            }
            
            var tempRoom: Room!
            let rooms = self.dbStatements.getTestRooms()
            
            // Add the rooms to the table.
            for index in 0...(rooms.count - 1) {
                tempRoom = rooms[index]
                
                if tempRoom.image != "NoImage" {
                    success = db.executeUpdate(self.dbStatements.INSERT_ROOM, withArgumentsInArray: [(tempRoom.id), (tempRoom.name), (tempRoom.image), (tempRoom.buildingId), (tempRoom.campusId)])
                } else {
                    success = db.executeUpdate(self.dbStatements.INSERT_ROOM, withArgumentsInArray: [(tempRoom.id), (tempRoom.name), ("NoImage"), (tempRoom.buildingId), (tempRoom.campusId)])
                }
                
                if success {
                    print(tempRoom.name + " added to the database.")
                } else {
                    print("An error has occurred: \(db.lastErrorMessage())")
                }
            }
        }
    }
    
    func clearTest() {
        queue?.inDatabase() {
            db in
            
            let success = db.executeStatements(self.dbStatements.clearTest())
            
            if success {
                print("Test Data Cleared.")
            } else {
                print("An error has occured: \(db.lastErrorMessage())")
            }
        }
    }
}