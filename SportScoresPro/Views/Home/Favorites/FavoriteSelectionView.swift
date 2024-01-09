//
//  FavoriteSelectionView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/6/24.
//

import Foundation
import SwiftUI

struct FavoritesSelection: View {
    @ObservedObject var logoFetcher : LogoFetcher
    @EnvironmentObject var settings: UserSettings
    @State private var selectedSports = Set<Int>()
    
    @State private var showSearchBar = false
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                Section {
                    ForEach(settings.userFavorites, id: \.id) { item in
                        HStack {
                            Image(item.sportName + "Logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .padding(.top, 5)
                                .padding(.trailing, 15)
                                .padding(.bottom, 5)
                            
                            Text(item.sportName)
                            Spacer()
                        }
                    }
                }
                
                Section {
                    ForEach(settings.teamFavorites, id: \.id) { item in
                        let teamKey = TeamKey(teamID: item.id, teamName: item.name)
                        
                        HStack {
                            
                            if let logo = logoFetcher.getLogo(forTeam: item.id, teamName: item.name) {
                                Image(uiImage: logo)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .padding(.top, 5)
                                    .padding(.trailing, 15)
                                    .padding(.bottom, 5)
                            } else {
                                ProgressView()
                                    .onAppear {
                                        logoFetcher.fetchLogo(forTeam: item.id, teamName: item.name)
                                    }
                                    .frame(width: 25, height: 25)
                            }
                            
                            VStack {
                                Text(item.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(item.tournament?.uniqueTournament?.name ?? "")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.caption)
                                
                            }
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: FavoritesLeagueSelection().environmentObject(settings)) {
                        Text("Leagues")
                            .foregroundColor(Color.primary)
                    }
                    
                    
                    NavigationLink(destination: FavoritesTeamSelection(logoFetcher: logoFetcher).environmentObject(settings)) {
                        Text("Teams")
                            .foregroundColor(Color.primary)
                    }
                }
            }
            .background(backgroundColor)
            .contentMargins(.top, 20)
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
            .accentColor(.white)
        }
        
        var backgroundColor: Color {
            colorScheme == .dark ? Color.black : Color(.systemGray6)
        }
    }
}
