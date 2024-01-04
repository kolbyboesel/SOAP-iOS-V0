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
        // Set other appearance attributes if necessary, like title text color
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
    @StateObject var sharedSportViewModel = SharedSportViewModel()

    let lifecyclePublisher = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    var body: some Scene {
        WindowGroup {
            ContentView(logoFetcher: logoFetcher)
                .environmentObject(sharedSportViewModel)
                .environmentObject(userSettings)
                .onReceive(lifecyclePublisher) { _ in
                    logoFetcher.saveData()
                }
            
            
        }
    }
}

class UserSettings: ObservableObject {
    @Published var tabBarVisible = true
    @Published var homeSelected = false

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

    init(loggedIn: Bool = false, email: String = "", firstName: String = "", lastName: String = "") {
        self.loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
        self.email = UserDefaults.standard.string(forKey: "email") ?? ""
        self.firstName = UserDefaults.standard.string(forKey: "firstName") ?? ""
        self.lastName = UserDefaults.standard.string(forKey: "lastName") ?? ""
    }
}

class SharedSportViewModel: ObservableObject {
    @Published var sportName: String = ""
    @Published var scoreKey: String = ""
    @Published var oddKey: String = ""
    @Published var predictionKey: String = ""
    @Published var seasonName: String = ""
    @Published var sportID: Int = 0
}
