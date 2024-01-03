//
//  RenderLogos.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/30/23.
//
import Foundation
import SQLite3
import UIKit

struct TeamKey: Hashable {
    let teamID: Int
    let teamName: String
}

class LogoFetcher: ObservableObject {
    @Published var teamLogos: [TeamKey : UIImage] = [:]
    private let databaseManager = DatabaseManager()
    
    init() {
        print("Initializing LogoFetcher and loading logos")
        loadLogosFromDatabase()
    }
    
    func fetchLogo(forTeam teamID: Int, teamName: String) {
        let key = TeamKey(teamID: teamID, teamName: teamName)
        
        if let logoData = databaseManager.getLogo(teamID: teamID, teamName: teamName),
           let image = UIImage(data: logoData) {
            DispatchQueue.main.async {
                self.teamLogos[key] = image
            }
            return
        }
        
        getTeamLogos(forTeam: teamID) { [weak self] fetchedImage in
            DispatchQueue.main.async {
                if let image = fetchedImage {
                    self?.teamLogos[key] = image
                    if let data = image.pngData() {
                        self?.databaseManager.saveLogo(teamID: teamID, teamName: teamName, logoData: data)
                    }
                } else {
                    self?.teamLogos[key] = UIImage(named: "placeholderLogo")
                }
            }
        }
    }
    
    func getLogo(forTeam teamID: Int, teamName: String) -> UIImage? {
        for (key, logo) in teamLogos {
            if key.teamID == teamID || key.teamName == teamName {
                return logo
            }
        }
        return UIImage(named: "placeholderLogo")
    }
    
    func saveData() {
        for (key, logo) in teamLogos {
            if let data = logo.pngData() {
                databaseManager.saveLogo(teamID: key.teamID, teamName: key.teamName, logoData: data)
            }
        }
    }
    
    func loadLogosFromDatabase() {
        let allLogos = databaseManager.getAllLogos()
        for (teamID, teamName, logoData) in allLogos {
            if let image = UIImage(data: logoData) {
                let key = TeamKey(teamID: teamID, teamName: teamName)
                teamLogos[key] = image
            } else {
            }
        }        
    }
}


class DatabaseManager {
    var db: OpaquePointer?
    
    init() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let databasePath = documentsDirectory.appendingPathComponent("TeamLogos.sqlite").path
        print(databasePath)
        if sqlite3_open(databasePath, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        let createTableString = """
        CREATE TABLE IF NOT EXISTS TeamLogos(
        TeamID INTEGER,
        TeamName TEXT,
        LogoData BLOB,
        PRIMARY KEY (TeamID, TeamName) );
        """
        
        if sqlite3_exec(db, createTableString, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)") }
    }
    
    func getLogo(teamID: Int, teamName: String) -> Data? {
        let query = "SELECT LogoData FROM TeamLogos WHERE TeamID = ? OR TeamName = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(teamID))
            sqlite3_bind_text(statement, 2, (teamName as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                if let queryResultCol1 = sqlite3_column_blob(statement, 0) {
                    let queryResultCol1Length = sqlite3_column_bytes(statement, 0)
                    let data = Data(bytes: queryResultCol1, count: Int(queryResultCol1Length))
                    sqlite3_finalize(statement)
                    return data
                }
            } else {
                print("Query returned no results.")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(statement)
        return nil
    }
    
    func saveLogo(teamID: Int, teamName: String, logoData: Data) {
        let query = """
            INSERT INTO TeamLogos(TeamID, TeamName, LogoData) VALUES (?, ?, ?)
            ON CONFLICT(TeamID, TeamName) DO UPDATE SET LogoData=excluded.LogoData;
            """
        
        var statement: OpaquePointer?
        
        sqlite3_bind_int(statement, 1, Int32(teamID))
        sqlite3_bind_text(statement, 2, (teamName as NSString).utf8String, -1, nil)
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(teamID))
            sqlite3_bind_text(statement, 2, (teamName as NSString).utf8String, -1, nil)
            
            logoData.withUnsafeBytes { bytes in
                if let bytes = bytes.bindMemory(to: UInt8.self).baseAddress {
                    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
                    sqlite3_bind_blob(statement, 3, bytes, Int32(logoData.count), SQLITE_TRANSIENT)
                }
            }
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully saved logo data for teamID: \(teamID)")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        
        sqlite3_finalize(statement)
    }
    
    func getAllLogos() -> [(teamID: Int, teamName: String, logoData: Data)] {
        var logos = [(Int, String, Data)]()
        let query = "SELECT TeamID, TeamName, LogoData FROM TeamLogos;"

        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let teamID = Int(sqlite3_column_int(statement, 0))
                
                let teamNameCString = sqlite3_column_text(statement, 1)
                let teamName = teamNameCString != nil ? String(cString: teamNameCString!) : "nil"
                
                let logoDataSize = sqlite3_column_bytes(statement, 2)
                let logoDataBlob = sqlite3_column_blob(statement, 2)
                if logoDataBlob != nil {
                    let logoData = Data(bytes: logoDataBlob!, count: Int(logoDataSize))
                    logos.append((teamID, teamName, logoData))
                }
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SELECT statement could not be prepared: \(errmsg)")
        }
        sqlite3_finalize(statement)
        return logos
    }

    
}
