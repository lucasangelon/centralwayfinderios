//
//  DatabaseManager.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 23/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

// Based on: http://www.techotopia.com/index.php/An_Example_SQLite_based_iOS_8_Application_using_Swift_and_FMDB
// Based on: http://metrozines.com/

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
        databasePath = documentFolder.stringByAppendingString("/centralWayfinder.db")
        
        // If the file does not exist, generate a new one.
        if !filemgr.fileExistsAtPath(databasePath as String) {
            
            // Create the database using the generated path.
            let centralWayfinderDB = FMDatabase(path: databasePath as String)
            
            // If it is nil, print the last error message.
            if centralWayfinderDB == nil {
                print("Error: \(centralWayfinderDB.lastErrorMessage())")
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
            let success = db.executeStatements(self.dbStatements.CREATE_TABLE_CAMPUS + self.dbStatements.CREATE_TABLE_ROOMS)
            
            // If unsuccessful, print the error.
            if !success {
                print("Table Creation Failure: \(db.lastErrorMessage())")
            }
        }
    }
    
    // MARK - Database Insertion
    
    // Inserts campuses into the Database.
    func insertCampuses(var campuses: [Campus]) {
        queue?.inDatabase() {
            db in
            
            var success: Bool = Bool()
            
            // Define a temporary Campus object and retrieve the data.
            var tempCampus: Campus!
            
            // Add the campuses to the table.
            for index in 0...(campuses.count - 1) {
                tempCampus = campuses[index]
                
                success = db.executeUpdate(self.dbStatements.INSERT_CAMPUS, withArgumentsInArray: [(tempCampus.id), (tempCampus.name), (tempCampus.version), (tempCampus.lat), (tempCampus.long), (tempCampus.zoom)])
                
                if !success {
                    print("An error has occurred: \(db.lastErrorMessage())")
                }
            }
        }
    }
    
    // Inserts rooms into the Database.
    func insertRooms(var rooms: [Room]) {
        queue?.inDatabase() {
            db in
            
            var success: Bool = Bool()
            
            // Define a temporary Room object and retrieve the data.
            var tempRoom: Room!
            let currentCampusId = sharedDefaults.campusId
            
            for index in 0...(rooms.count - 1) {
                tempRoom = rooms[index]
                
                success = db.executeUpdate(self.dbStatements.INSERT_ROOM, withArgumentsInArray: [(tempRoom.id), (tempRoom.name), (tempRoom.image), (tempRoom.buildingId), (currentCampusId)])
                
                if !success {
                    print("An error has occurred: \(db.lastErrorMessage())")
                }
            }
        }
    }
    
    // MARK - Database Interaction
    
    // Returns all available campuses.
    func getCampuses(var campuses: [Campus]) -> [Campus]{
        queue?.inDatabase() {
            db in
            
            let resultSet: FMResultSet! = db.executeQuery(self.dbStatements.SELECT_ALL_CAMPUSES, withArgumentsInArray: nil)
            
            if (resultSet != nil) {
                while resultSet.next() {
                    campuses.append(Campus(id: resultSet.stringForColumn("id"), name: resultSet.stringForColumn("name"), version: Int(resultSet.intForColumn("version")), lat: resultSet.doubleForColumn("lat"), long: resultSet.doubleForColumn("long"), zoom: resultSet.doubleForColumn("zoom")))
                }
            }
            
            else {
                print("An error has occurred: \(db.lastErrorMessage())")
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
                campus = Campus(id: result.stringForColumn("id"), name: result.stringForColumn("name"), version: Int(result.intForColumn("version")), lat: result.doubleForColumn("lat"), long: result.doubleForColumn("long"), zoom: result.doubleForColumn("zoom"))
                
                // Ensures result is closed.
                result.close()
            }
            
            else {
                print("An error has occurred: \(db.lastErrorMessage())")
            }
        }
        return campus
    }
    
    // Returns all available services in a given campus.
    func getServices(id: String, var rooms: [Room]) -> [Room] {
        queue?.inDatabase() {
            db in
            
            let resultSet: FMResultSet! = db.executeQuery(self.dbStatements.SELECT_SERVICES, withArgumentsInArray: [id])
            
            if (resultSet != nil) {
                while (resultSet.next()) {
                    rooms.append(Room(id: Int(resultSet.intForColumn("id")), name: resultSet.stringForColumn("name"), image: resultSet.stringForColumn("image"), buildingId: Int(resultSet.intForColumn("building_id")), campusId: resultSet.stringForColumn("campus_id")))
                }
            }
            
            else {
                print("An error has occurred: \(db.lastErrorMessage())")
            }
            
            resultSet.close()
        }
        return rooms
    }
    
    // Returns all available rooms (including services) in a given campus.
    func getRooms(campusId: String, var rooms: [Room]) -> [Room] {
        queue?.inDatabase() {
            db in
            
            let  resultSet: FMResultSet! = db.executeQuery((self.dbStatements.SELECT_ROOMS), withArgumentsInArray: [campusId])
            
            if (resultSet != nil) {
                while (resultSet.next()) {
                    rooms.append(Room(id: Int(resultSet.intForColumn("id")), name: resultSet.stringForColumn("name"), image: resultSet.stringForColumn("image"), buildingId: Int(resultSet.intForColumn("building_id")), campusId: resultSet.stringForColumn("campus_id")))
                }
            }
            
            else {
                print("An error has occured: \(db.lastErrorMessage())")
            }
            
            resultSet.close()
        }
        
        return rooms
    }
    
    // Removes all rooms from the database table in order to add new ones.
    func removeRooms() {
        queue?.inDatabase() {
            db in
            
            db.executeStatements(self.dbStatements.DELETE_ALL_ROOMS)
        }
    }
    
    // Checks if there are campuses in the campus table.
    func checkCampuses() -> Bool {
        var found = false
        
        queue?.inDatabase() {
            db in
            
            let result: FMResultSet = db.executeQuery(self.dbStatements.CHECK_CAMPUSES, withArgumentsInArray: nil)
            
            if result.next() {
                if result.intForColumnIndex(0) > 1 {
                    found = true
                }
            } else {
                print("An error has occured: \(db.lastErrorMessage())")
            }
            
            result.close()
        }
        
        return found
    }
}