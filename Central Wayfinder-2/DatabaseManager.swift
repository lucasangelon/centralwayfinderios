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
    
    var databasePath = NSString()
    var queue: FMDatabaseQueue?
    
    func setupQueue() {
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
            }
            
            // If it opened, generate the tables required for the Central Wayfinder application.
            if centralWayfinderDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                if !centralWayfinderDB.executeStatements(sql_stmt) {
                    print("Error: \(centralWayfinderDB.lastErrorMessage())")
                }
                centralWayfinderDB.close()
            } else {
                print("Error: \(centralWayfinderDB.lastErrorMessage())")
            }
        }
    }
    
    func checkTable() -> Bool {
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open() {
            contactDB.tableExists("contacts")
            contactDB.close()
            return true
        }
        contactDB.close()
        return false
    }
    
    func createCampus() {
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open() {
            let sql_stmt = "CREATE TABLE IF NOT EXISTS [campuses] ('Campus_ID' TEXT NOT NULL PRIMARY KEY, 'Campus_Name' TEXT NOT NULL, 'Campus_Lat' REAL NOT NULL, 'Campus_Long' REAL NOT NULL, 'Campus_Zoom' REAL NOT NULL);"
            if !contactDB.executeStatements(sql_stmt) {
                print("Error: \(contactDB.lastErrorMessage())")
            }
            
            if !contactDB.executeUpdate("INSERT INTO campuses (Campus_ID, Campus_Name, Campus_Lat, Campus_Long, Campus_Zoom) VALUES (?, ?, ?, ?, ?)", withArgumentsInArray: ["PE", "Non-Existant", 21, 22, 10]) {
                print("Works")
            } else {
                print("Error: \(contactDB.lastErrorMessage())")
            }
            
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }
    
    func insertData() {
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open() {
            if !contactDB.executeUpdate("INSERT INTO contacts (name, address, phone) VALUES (?, ?, ?)", withArgumentsInArray: [("Lucas"), ("19 Aberdeen Street"), ("04133483")]) {
                print("ERROR")
            } else {
                let student: FMResultSet = contactDB.executeQuery("SELECT * FROM contacts WHERE name = 'Lucas'", withArgumentsInArray: nil)
                
                if student.next() == true {
                    print(student.stringForColumn("name"))
                    print(student.stringForColumn("address"))
                    print(student.stringForColumn("phone"))
                }
            }
        }
        
        contactDB.close()
    }
    
    func findStudent(name: String) {
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open() {
            let student: FMResultSet = contactDB.executeQuery("SELECT * FROM contacts WHERE name = 'Lucas'", withArgumentsInArray: nil)
        
            if student.next() == true {
                print(student.stringForColumn("name"))
                print(student.stringForColumn("address"))
                print(student.stringForColumn("phone"))
            }
        }

    }
    
    func findCampus(id: String) {
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open() {
            let student: FMResultSet = contactDB.executeQuery("SELECT * FROM campuses WHERE Campus_ID = (?)", withArgumentsInArray: [id])
            
            if student.next() == true {
                print(student.stringForColumn("Campus_ID"))
                print(student.stringForColumn("Campus_Name"))
                print(student.stringForColumn("Campus_Zoom"))
            }
        }
        
    }
}