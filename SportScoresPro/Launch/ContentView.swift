//
//  ContentView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/22/23.
//

import SwiftUI
import Combine

struct StartView: View {
    var logoFetcher : LogoFetcher
    var settings: UserSettings
    var sharedSportViewModel: SharedSportViewModel
    
    var body: some View {
        return AnyView(TabBar(logoFetcher: logoFetcher)                .environmentObject(sharedSportViewModel)
            .environmentObject(sharedSportViewModel)
            .environmentObject(AppEnvironment()))
    }
}

struct ContentView: View {
    @ObservedObject var logoFetcher : LogoFetcher
    @EnvironmentObject var sharedSportViewModel: SharedSportViewModel
    @EnvironmentObject var userSettings : UserSettings
    @EnvironmentObject var appEnvironment: AppEnvironment

    var body: some View {
        return AnyView(TabBar(logoFetcher: logoFetcher)
            .environmentObject(userSettings)
            .environmentObject(sharedSportViewModel)
            .environmentObject(appEnvironment))

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var logoFetcher = LogoFetcher()
        @StateObject var sharedSportViewModel = SharedSportViewModel()

        TabBar(logoFetcher: logoFetcher)
            .environmentObject(UserSettings())
            .environmentObject(sharedSportViewModel)
            .environmentObject(AppEnvironment())

    }
}


