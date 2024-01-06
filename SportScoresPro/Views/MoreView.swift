//
//  AccountView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/23/23.
//

import SwiftUI

struct MoreView: View {
    @ObservedObject var logoFetcher: LogoFetcher
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                List {
                    Section {
                        NavigationLink(destination: AboutView().accentColor(.white)) {
                            Text("About")
                        }
                    }
                }
                .contentMargins(.top, 20)
                .navigationTitle("More")
            }
        }
        .accentColor(.white)
    }
}
