//
//  SportScoresProApp.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/31/23.
//

import SwiftUI

let keychain = KeychainSwift()

@main
struct SportScoresProApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

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
    private var keychainManager = KeychainManager.shared
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

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 0.95686274509, green: 0.26274509803, blue: 0.21176470588, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.white]
        appearance.backButtonAppearance = backItemAppearance
         
        let image = UIImage(systemName: "chevron.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        return true
    }
}

class KeychainManager {
    static let shared = KeychainManager()
    private let keychain = KeychainSwift()

    func saveApiKey(key: String, value: String) {
        keychain.set(value, forKey: key)
    }

    func retrieveApiKey(key: String) -> String? {
        return keychain.get(key)
    }

    func deleteApiKey(key: String) {
        keychain.delete(key)
    }
}
