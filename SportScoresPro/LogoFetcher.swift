//
//  LogoFetcher.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/4/24.
//
import Foundation
import UIKit

struct TeamKey: Hashable {
    let teamID: Int
    let teamName: String
}

class LogoFetcher: ObservableObject {
    @Published var teamLogos: [TeamKey : UIImage] = [:]
    
    init() {
        print("Initializing LogoFetcher and loading logos")
        let semaphore = DispatchSemaphore(value: 0)
        
        loadLogosFromMongoDB {
            semaphore.signal()
        }
        semaphore.wait()        
    }
    
    func fetchLogo(forTeam teamID: Int, teamName: String) {
        
        for (key, logo) in teamLogos {
            if key.teamID == teamID || key.teamName == teamName {
                return
            }
        }
        
        let key = TeamKey(teamID: teamID, teamName: teamName)
        
        getTeamLogos(forTeam: teamID) { [weak self] fetchedImage in
            DispatchQueue.main.async {
                if let image = fetchedImage {
                    self?.teamLogos[key] = image
                    if let data = image.pngData() {
                        self?.insertLogoIntoMongoDB(teamID: teamID, teamName: teamName, logoData: data) { success in
                            if success {
                                print("Successfully saved logo into MongoDB")
                            } else {
                                print("Failed to insert logo into MongoDB")
                            }
                        }
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
    
    func insertLogoIntoMongoDB(teamID: Int, teamName: String, logoData: Data, completion: @escaping (Bool) -> Void) {
        
        checkLogoExistsInMongoDB(teamID: teamID) { exists in
            if exists {
                print("Logo already exists for teamID: \(teamID)")
                completion(false)
            } else {
                guard let url = URL(string: "https://eastus2.azure.data.mongodb-api.com/app/data-sdfbt/endpoint/data/v1/action/insertOne") else {
                    print("Invalid URL")
                    completion(false)
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/ejson", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                let apiKey = KeychainManager.shared.retrieveApiKey(key: "MongoDB") ?? ""
                request.addValue(apiKey, forHTTPHeaderField: "apiKey")
                
                let document: [String: Any] = [
                    "TeamID": teamID,
                    "TeamName": teamName,
                    "ImageData": logoData.base64EncodedString()
                ]
                
                let userData: [String: Any] = [
                    "dataSource": "SportsScores",
                    "database": "Logos",
                    "collection": "TeamLogos",
                    "document": document
                ]
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: userData, options: []) else {
                    print("Error: cannot create JSON from user data")
                    completion(false)
                    return
                }
                
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error making MongoDB request: \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    completion(true)
                }
                
                task.resume()
            }
        }
    }
    
    func loadLogosFromMongoDB(completion: @escaping () -> Void) {
        guard let url = URL(string: "https://eastus2.azure.data.mongodb-api.com/app/data-sdfbt/endpoint/data/v1/action/find") else {
            print("Invalid URL")
            completion()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/ejson", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let apiKey = KeychainManager.shared.retrieveApiKey(key: "MongoDB") ?? ""
        request.addValue(apiKey, forHTTPHeaderField: "apiKey")
        
        let userData: [String: Any] = [
            "dataSource": "SportsScores",
            "database": "Logos",
            "collection": "TeamLogos"
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: userData, options: []) else {
            print("Error: cannot create JSON from user data")
            completion()
            return
        }
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                if let error = error {
                    print("Error fetching logos from MongoDB: \(error.localizedDescription)")
                    completion()
                    return
                }

                guard let data = data else {
                    print("No data received from MongoDB")
                    completion()
                    return
                }

                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let documents = jsonResponse["documents"] as? [[String: Any]] {
                        
                        for document in documents {
                            if let teamID = document["TeamID"] as? Int,
                               let teamName = document["TeamName"] as? String,
                               let imageDataString = document["ImageData"] as? String,
                               let logoData = Data(base64Encoded: imageDataString) {
                                                                
                                DispatchQueue.main.async {

                                    let teamKey = TeamKey(teamID: teamID, teamName: teamName)
                                    self?.teamLogos[teamKey] = UIImage(data: logoData)
                                }
                            }
                        }
                    }
                } catch {
                    print("Error parsing response from MongoDB: \(error.localizedDescription)")
                }

                completion()
            }

            task.resume()
    }
    
    func checkLogoExistsInMongoDB(teamID: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://eastus2.azure.data.mongodb-api.com/app/data-sdfbt/endpoint/data/v1/action/findOne") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/ejson", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let apiKey = KeychainManager.shared.retrieveApiKey(key: "MongoDB") ?? ""
        request.addValue(apiKey, forHTTPHeaderField: "apiKey")
        
        let query: [String: Any] = ["TeamID": teamID]
        let userData: [String: Any] = [
            "dataSource": "SportsScores",
            "database": "Logos",
            "collection": "TeamLogos",
            "filter": query
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: userData, options: []) else {
            print("Error: cannot create JSON from user data")
            completion(false)
            return
        }
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error checking logo existence in MongoDB: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    guard let data = data else {
                        completion(false)
                        return
                    }

                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let document = jsonResponse["document"], !(document is NSNull) {
                                completion(true)
                            } else {
                                completion(false)
                            }
                        } else {
                            completion(false)
                        }
                    } catch {
                        print("Error parsing response from MongoDB: \(error.localizedDescription)")
                        completion(false)
                    }
                } else {
                    print("Failed to check logo existence with status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                    completion(false)
                }
            }

            task.resume()
    }
}


func getTeamLogos(forTeam teamID: Int, completion: @escaping (UIImage?) -> Void) {
    
    let apiKey = KeychainManager.shared.retrieveApiKey(key: "RapidAPIKEY") ?? ""

    let urlString = "https://sofascores.p.rapidapi.com/v1/teams/logo?team_id=\(teamID)"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue(apiKey, forHTTPHeaderField: "X-RapidAPI-Key")
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
