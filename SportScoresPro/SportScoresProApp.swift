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
    
    var userSettings = UserSettings()
    @ObservedObject var logoFetcher = LogoFetcher()

    
    var body: some Scene {
        WindowGroup {
            ContentView(logoFetcher: logoFetcher)
                .environmentObject(userSettings)


        }
    }
}

class UserSettings: ObservableObject {
    @Published var loggedIn : Bool = true
    @Published var navigateNowToLogIn: Bool = false
    @Published var navigateNowToSignup: Bool = false
}
