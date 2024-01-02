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
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        return AnyView(TabBar(logoFetcher: logoFetcher))
    }
}

struct ContentView: View {
    var logoFetcher : LogoFetcher
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        return AnyView(TabBar(logoFetcher: logoFetcher))
            .environmentObject(settings)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let logoFetcher = LogoFetcher()
        let userSettings = UserSettings()

        ContentView(logoFetcher: logoFetcher)
            .environmentObject(userSettings)
    }
}


