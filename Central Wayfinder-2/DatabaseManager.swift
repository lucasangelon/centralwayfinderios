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
                
                if success {
                    print(tempCampus.name + " added to the database.")
                } else {
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
                
                if success {
                    print(tempRoom.name + " added to the database.")
                } else {
                    print("An error has occurred: \(db.lastErrorMessage())")
                }
            }
        }
    }
    
    // Inserts a building into the Database.
    func insertBuilding(let building: Building) {
        queue?.inDatabase() {
            db in
            
            var success: Bool = Bool()
            
            success = db.executeUpdate(self.dbStatements.INSERT_BUILDING, withArgumentsInArray: [(building.id), (building.name), (building.lat), (building.long), (building.image), (building.campusId)])
            
            if success {
                print(building.name + " added to the database.")
            } else {
                print("An error has occurred: \(db.lastErrorMessage())")
            }
        }
    }
    
    // MARK - Database Interaction
    
    // Returns all available campuses.
    func getCampuses(var campuses: [Campus]) -> [Campus]{
        queue?.inDatabase() {
            db in
            
            let resultSet: FMResultSet! = db.executeQuery(self.dbStatements.GET_ALL_CAMPUSES, withArgumentsInArray: nil)
            
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
    
    // Returns the building a given room is located in through an id.
    func getBuilding(id: Int, var building: Building) -> Building {
        queue?.inDatabase() {
            db in
            
            let result: FMResultSet = db.executeQuery(self.dbStatements.SELECT_BUILDING_BASED_ON_ROOM, withArgumentsInArray: [Int(id)])
            
            if result.next() {
                building = Building(id: Int(result.intForColumn("id")), name: result.stringForColumn("Name"), lat: result.doubleForColumn("lat"), long: result.doubleForColumn("long"), image: result.stringForColumn("image"), campusId: result.stringForColumn("campus_id"))
                
                result.close()
            }
            
            else {
                print("An error has occured: \(db.lastErrorMessage())")
                building = Building(id: 0, name: "Not Found", lat: 0.0, long: 0.0, image: "NoImage", campusId: "Not Found")
            }
        }
        
        return building
    }
    
    /* Test Functions */
    
    /*// Inserts test data.
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
                
                if !success {
                    print("An error has occurred: \(db.lastErrorMessage())")
                }
            }
            
            var tempBuilding: Building!
            let buildings = self.dbStatements.getTestBuildings()
            
            // Add the test buildings to the table.
            for index in 0...(buildings.count - 1) {
                tempBuilding = buildings[index]
                
                success = db.executeUpdate(self.dbStatements.INSERT_BUILDING, withArgumentsInArray: [Int(tempBuilding.id as Int), (tempBuilding.name), (tempBuilding.lat), (tempBuilding.long), (tempBuilding.campusId)])
                
                if !success {
                    //print("An error has occurred: \(db.lastErrorMessage())")
                }
            }
            
            var tempRoom: Room!
            let rooms = self.dbStatements.getTestRooms()
            
            // Add the rooms to the table.
            for index in 0...(rooms.count - 1) {
                tempRoom = rooms[index]
                
                if tempRoom.image != "NoImage" {
                    success = db.executeUpdate(self.dbStatements.INSERT_ROOM, withArgumentsInArray: [Int(tempRoom.id as Int), (tempRoom.name), (tempRoom.image), Int(tempRoom.buildingId as Int), (tempRoom.campusId)])
                } else {
                    success = db.executeUpdate(self.dbStatements.INSERT_ROOM, withArgumentsInArray: [Int(tempRoom.id as Int), (tempRoom.name), ("NoImage"), Int(tempRoom.buildingId as Int), (tempRoom.campusId)])
                }
                
                if !success {
                    //print("An error has occurred: \(db.lastErrorMessage())")
                }
            }
        }
    }*/
    
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