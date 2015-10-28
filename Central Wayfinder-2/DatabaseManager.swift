//
//  DatabaseManager.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 23/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

let sharedInstance = DatabaseManager()

//@available(iOS 8.0, *)
class DatabaseManager: NSObject {
    
    var database: FMDatabase? = nil
    
    func getInstance() -> DatabaseManager {
        if (sharedInstance.database == nil) {
            sharedInstance.database = FMDatabase(path: UtilsHelper.getPath("centralWayfinderDB.sqlite"))
            print("Loaded!")
        }
        
        return sharedInstance
    }
    
    func getCampus(id: String) -> Campus {
        sharedInstance.database!.open()
        
        let result: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM 'buildings' WHERE Campus_ID = (?)", withArgumentsInArray: [id])
        var campus: Campus = Campus()
        
        if (result != nil) {
            campus.id = result.stringForColumn("Campus_ID")
            campus.name = result.stringForColumn("Campus_Name")
            campus.lat = result.doubleForColumn("Campus_Lat")
            campus.long = result.doubleForColumn("Campus_Long")
            campus.zoom = result.doubleForColumn("Campus_Zoom")
        }
        
        sharedInstance.database!.close()
        
        return campus
    }
    
    /*var databasePath = NSString()
    let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    var centralWayfinderDB : FMDatabase? = nil
    
    // Creates / Opens the database.
    func setupDatabase() {
        
        dispatch_async(backgroundQueue, {
            // Finding the location of the database file.
            let fileManager = NSFileManager.defaultManager()
            let directoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
            
            self.databasePath = directoryPath.stringByAppendingString("centralWayfinderDB.sql")

            self.centralWayfinderDB = FMDatabase(path: self.databasePath as String)
            
            // If the file exists:
            if !fileManager.fileExistsAtPath(self.databasePath as String) {
                
                // Find the file.
                self.centralWayfinderDB = FMDatabase(path: self.databasePath as String)
                
                print("great")
                // If it is null, print the last error.
                if self.centralWayfinderDB == nil {
                    print("Error: \(self.centralWayfinderDB!.lastErrorMessage())")
                }
                
                // If the database opens, create the campuses table.
                if self.centralWayfinderDB!.open() {
                    let sqlStatement = "CREATE TABLE IF NOT EXISTS campuses (Campus_ID PRIMARY KEY VARCHAR NOT NULL, Campus_Name VARCHAR NOT NULL, Campus_Lat DOUBLE NOT NULL, Campus_Long DOUBLE NOT NULL, Campus_Zoom DOUBLE NOT NULL)"
                    
                    // If it fails, print the error.
                    if !self.centralWayfinderDB!.executeStatements(sqlStatement) {
                        print("Error: \(self.centralWayfinderDB!.lastErrorMessage())")
                    }
                }
                    
                    // If it does not open, print the error.
                else {
                    print("Error \(self.centralWayfinderDB!.lastErrorMessage())")
                }
                
                self.closeDB()
            }
        })
    }
    
    // Inserts a campus into the database.
    func saveCampus(id: String, name: String, lat: Double, long: Double, zoom: Double) {
        
        dispatch_async(backgroundQueue, {
            if self.centralWayfinderDB!.open() {
                let insertSql = "INSERT INTO campuses(Campus_Id, Campus_Name, Campus_Lat, Campus_Long, Campus_Zoom) VALUES (?, ?, ?, ?, ?)"
                
                let result = self.centralWayfinderDB!.executeUpdate(insertSql, withArgumentsInArray: [id, name, lat, long, zoom])
                
                if !result {
                    print("Error \(self.centralWayfinderDB!.lastErrorMessage())")
                } else {
                    print("Campus Added")
                }
            } else {
                print("Error \(self.centralWayfinderDB!.lastErrorMessage())")
            }
            
            self.closeDB()
        })
    }
    
    func findCampus(campus: String) {
        
        dispatch_async(backgroundQueue, {
            if self.centralWayfinderDB!.open() {
                let querySql = "SELECT * FROM campuses WHERE Campus_Name = (?)"
                
                let result:FMResultSet? = self.centralWayfinderDB!.executeQuery(querySql, withArgumentsInArray: [campus])
                
                if result?.next() == true {
                    print(result?.stringForColumn("Campus_Name"))
                    print(result?.stringForColumn("Campus_Lat"))
                    print(result?.stringForColumn("Campus_Long"))
                } else {
                    print("Campus not founsd")
                }
                
                self.centralWayfinderDB!.close()
            } else {
                print("Error \(self.centralWayfinderDB!.lastErrorMessage())")
            }
            
            self.closeDB()
        })
    }
    
    func closeDB() {
        dispatch_async(backgroundQueue, {
            self.centralWayfinderDB!.close()
        })
    }*/
}