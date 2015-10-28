//
//  DatabaseManager.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 23/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

// Based on: http://www.techotopia.com/index.php/An_Example_SQLite_based_iOS_8_Application_using_Swift_and_FMDB
let sharedInstance = DatabaseManager()

class DatabaseManager : NSObject {
    
    var databasePath = NSString()
    
    func setup() {
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0]
        
        databasePath = docsDir.stringByAppendingString(
            "contacts.db")
        
        if !filemgr.fileExistsAtPath(databasePath as String) {
            
            let contactDB = FMDatabase(path: databasePath as String)
            
            if contactDB == nil {
                print("Error: \(contactDB.lastErrorMessage())")
            }
            
            if contactDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                if !contactDB.executeStatements(sql_stmt) {
                    print("Error: \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
            } else {
                print("Error: \(contactDB.lastErrorMessage())")
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