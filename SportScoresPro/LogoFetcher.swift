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
