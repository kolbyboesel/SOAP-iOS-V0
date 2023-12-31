//
//  RenderLogos.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/30/23.
//
import Foundation
import SQLite3
import UIKit

class LogoFetcher: ObservableObject {
    @Published var teamLogos: [Int: UIImage] = [:]
    private let databaseManager = DatabaseManager() // Add database manager
    // ... rest of your properties

    func fetchLogo(forTeam teamID: Int) {
        // First try to load from database
        if let logoData = databaseManager.getLogo(teamID: teamID),
           let image = UIImage(data: logoData) {
            DispatchQueue.main.async {
                self.teamLogos[teamID] = image
            }
            return
        }

        // If not in database, fetch from API
        getTeamLogos(forTeam: teamID) { [weak self] fetchedImage in
            DispatchQueue.main.async {
                if let image = fetchedImage {
                    self?.teamLogos[teamID] = image
                    // Convert UIImage to Data and save to database
                    if let data = image.pngData() {
                        self?.databaseManager.saveLogo(teamID: teamID, logoData: data)
                    }
                } else {
                    self?.teamLogos[teamID] = UIImage(named: "placeholderLogo")
                }
            }
        }
    }
}


class DatabaseManager {
    var db: OpaquePointer?

    init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let databasePath = documentsDirectory.appendingPathComponent("TeamLogos.sqlite").path

        if sqlite3_open(databasePath, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }

        let createTableString = """
        CREATE TABLE IF NOT EXISTS TeamLogos(
        TeamID INTEGER PRIMARY KEY,
        LogoData BLOB
        );
        """

        if sqlite3_exec(db, createTableString, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }

    func getLogo(teamID: Int) -> Data? {
        let query = "SELECT LogoData FROM TeamLogos WHERE TeamID = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(teamID))
            
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

    func saveLogo(teamID: Int, logoData: Data) {
        let query = """
        INSERT INTO TeamLogos(TeamID, LogoData) VALUES (?, ?)
        ON CONFLICT(TeamID) DO UPDATE SET LogoData=excluded.LogoData;
        """
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(teamID))
            
            logoData.withUnsafeBytes { bytes in
                if let bytes = bytes.bindMemory(to: UInt8.self).baseAddress {
                    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
                    sqlite3_bind_blob(statement, 2, bytes, Int32(logoData.count), SQLITE_TRANSIENT)
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
}

func getTeamLogos(forTeam teamID: Int, completion: @escaping (UIImage?) -> Void) {
    let urlString = "https://sofascores.p.rapidapi.com/v1/teams/logo?team_id=\(teamID)"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("7c01195a20mshbc9188a6ca4f5a5p1ce61cjsn5e640810eca6", forHTTPHeaderField: "X-RapidAPI-Key")
    request.addValue("sofascores.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error fetching logo: \(error.localizedDescription)")
            completion(nil)
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Invalid response from server")
            completion(nil)
            return
        }

        guard let data = data, let image = UIImage(data: data) else {
            print("No data or data is not an image")
            completion(nil)
            return
        }

        completion(image)
    }

    task.resume()
}

