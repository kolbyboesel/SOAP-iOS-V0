//
//  SportScoresProApp.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/31/23.
//

import SwiftUI

@main
struct SportScoresProApp: App {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 0.95686274509, green: 0.26274509803, blue: 0.21176470588, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = UIColor.white
        
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor.white
        
        UITabBar.appearance().backgroundColor = UIColor.white
        
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(red: 0.95686274509, green: 0.26274509803, blue: 0.21176470588, alpha: 1)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray.withAlphaComponent(0.6)
        
        
    }
    
    @StateObject var userSettings = UserSettings()
    @StateObject var logoFetcher = LogoFetcher()
    
    let lifecyclePublisher = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    var body: some Scene {
        WindowGroup {
            ContentView(logoFetcher: logoFetcher)
                .environmentObject(userSettings)
                .onReceive(lifecyclePublisher) { _ in
                    logoFetcher.saveData()
                }
        }
    }
}

import SwiftUI

class UserSettings: ObservableObject {
    var profileMenuSelection = ""
    
    @Published var loggedIn: Bool {
        didSet {
            UserDefaults.standard.set(loggedIn, forKey: "loggedIn")
        }
    }

    @Published var email: String {
        didSet {
            UserDefaults.standard.set(email, forKey: "email")
        }
    }

    @Published var firstName: String {
        didSet {
            UserDefaults.standard.set(firstName, forKey: "firstName")
        }
    }

    @Published var lastName: String {
        didSet {
            UserDefaults.standard.set(lastName, forKey: "lastName")
        }
    }

    @Published var userFavorites: [SportMenuItemModel] {
        didSet {
            if let encoded = try? JSONEncoder().encode(userFavorites) {
                UserDefaults.standard.set(encoded, forKey: "userFavorites")
            }
        }
    }

    init() {
        self.loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
        self.email = UserDefaults.standard.string(forKey: "email") ?? ""
        self.firstName = UserDefaults.standard.string(forKey: "firstName") ?? ""
        self.lastName = UserDefaults.standard.string(forKey: "lastName") ?? ""

        if let favoritesData = UserDefaults.standard.data(forKey: "userFavorites"),
           let favorites = try? JSONDecoder().decode([SportMenuItemModel].self, from: favoritesData) {
            self.userFavorites = favorites
        } else {
            self.userFavorites = []
        }
    }
}

