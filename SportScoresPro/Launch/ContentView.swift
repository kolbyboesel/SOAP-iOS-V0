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
    
    var body: some View {
        return AnyView(TabBar(logoFetcher: logoFetcher))
    }
}

struct ContentView: View {
    @ObservedObject var logoFetcher : LogoFetcher
    @EnvironmentObject var userSettings : UserSettings

    var body: some View {
        return AnyView(TabBar(logoFetcher: logoFetcher))
            .environmentObject(userSettings)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var logoFetcher = LogoFetcher()

        TabBar(logoFetcher: logoFetcher)
            .environmentObject(UserSettings())
    }
}


