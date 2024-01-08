//
//  FavoriteTeamSelection.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/7/24.
//

import Foundation
import SwiftUI

struct FavoritesTeamSelection: View {
    @ObservedObject var logoFetcher : LogoFetcher
    @EnvironmentObject var settings: UserSettings
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedSports = Set<Int>()
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText = ""
    
    @State private var searchData: [SearchData] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            List {
                ForEach(searchData, id: \.id) { item in
                    let teamKey = TeamKey(teamID: item.id, teamName: item.name)
                    
                    HStack {
                        if let logo = logoFetcher.teamLogos[teamKey] {
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
                                .frame(width: 30, height: 30)
                        }
                        
                        VStack {
                            Text(item.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(item.tournament?.uniqueTournament?.name ?? "")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.caption)
                            
                        }
                        Toggle("", isOn: selectedSports.contains(item.id) ? .constant(true) : .constant(false))
                            .onTapGesture {
                                toggleSelection(for: item.id)
                                updateFavorite(for: item.id)
                            }
                    }
                }
                
                if(searchText == ""){
                    Section {
                        ForEach(settings.teamFavorites, id: \.id) { item in
                            let teamKey = TeamKey(teamID: item.id, teamName: item.name)
                            
                            HStack {
                                if let logo = logoFetcher.teamLogos[teamKey] {
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
                                        .frame(width: 30, height: 30)
                                }
                                
                                VStack {
                                    Text(item.name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(item.tournament?.uniqueTournament?.name ?? "")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.caption)
                                    
                                }
                                Toggle("", isOn: selectedSports.contains(item.id) ? .constant(true) : .constant(false))
                                    .onTapGesture {
                                        toggleSelection(for: item.id)
                                        updateFavorite(for: item.id)
                                    }
                            }
                        }
                    }
                }
            }
            .contentMargins(.top, 20)
            .searchable(text: $searchText)
            .foregroundColor(.white)
            .accentColor(.white)
            .onChange(of: searchText) {
                performSearch(with: searchText)
            }
        }
        .navigationTitle("Select Teams")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedSports = Set(settings.teamFavorites.map { $0.id })
        }
    }
    private func performSearch(with query: String) {
        searchTeams(forSport: query){
            fetchedData in
            self.searchData = fetchedData
        }
    }
    
    private func toggleSelection(for id: Int) {
        if selectedSports.contains(id) {
            selectedSports.remove(id)
        } else {
            selectedSports.insert(id)
        }
    }
    
    private func updateFavorite(for id: Int) {
        if let favorite = searchData.first(where: { $0.id == id }) {
            if selectedSports.contains(id) {
                if !settings.teamFavorites.contains(where: { $0.id == id }) {
                    settings.teamFavorites.append(favorite)
                }
            } else {
                settings.teamFavorites.removeAll { $0.id == id }
            }
        }
    }
    
    private func binding(for id: Int) -> Binding<Bool> {
        return .init(
            get: { self.selectedSports.contains(id) },
            set: {
                if $0 {
                    self.selectedSports.insert(id)
                } else {
                    self.selectedSports.remove(id)
                }
            }
        )
    }
    
    var backgroundColor: Color {
        colorScheme == .dark ? Color.black : Color(.systemGray6)
    }
}


struct SearchResponse: Decodable {
    var data: [SearchData]
}

struct SearchData: Codable {
    var id: Int
    var name: String
    var shortName: String
    var sport : Sport
    var tournament: Tournament?
    
    struct Tournament: Codable {
        var id: Int
        var name: String
        var uniqueTournament: UniqueTournament?
    }

    struct UniqueTournament: Codable  {
        var name: String
    }
    
    struct Sport: Codable  {
        var name: String
        var id: Int
    }
}

struct TeamScoreResponse: Decodable {
    let data: EventsData
}

struct EventsData: Decodable {
    let events: [LiveScoreData]
    let hasNextPage: Bool
}
