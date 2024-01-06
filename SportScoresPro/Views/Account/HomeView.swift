//
//  HomeView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/22/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var logoFetcher : LogoFetcher
    @EnvironmentObject var settings: UserSettings
    
    @State var notificationToggle: Bool = false
    @State var locationUsage: Bool = false
    
    @State var showProfileDropdown: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            NavigationStack{
                VStack(spacing: 0) {
                    if settings.loggedIn {
                        Text("Welcome, " + settings.firstName)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.primary)
                            .frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
                            .padding(.top)
                            .padding(.leading)
                            .padding(.trailing)
                            .background(Color(.systemGray6))
                    }
                    GeometryReader { geometry in
                        ScrollView {
                            ForEach(settings.userFavorites, id: \.id) { item in
                                Spacer(minLength: 40)
                                
                                FavoriteSportView(id: item.id, sportName: item.sportName, ScoreKey: item.ScoreKey, OddKey: item.OddKey, PredictionKey: item.PredictionKey, seasonName: item.seasonName, sportID: item.sportID, logoFetcher: logoFetcher)
                                    .environmentObject(settings)
                            }
                        }
                    }
                }
                .zIndex(0)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Image("home-logo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        AccountMenuButton(isMenuVisible: $showProfileDropdown)
                            .padding()
                    }
                }
                .background(Color(.systemGray6))
            }
            
            if showProfileDropdown {
                VStack {
                    HStack {
                        AccountDropdownMenu(logoFetcher: logoFetcher, isMenuVisible: $showProfileDropdown)
                            .environmentObject(settings)
                            .accentColor(.white)

                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top, 44)
                .padding(.leading)
                .transition(.move(edge: .top))
                .animation(.default, value: showProfileDropdown)
                .zIndex(1)
            }
        }
        .onAppear{
            showProfileDropdown = false
        }
    }
}

struct FavoriteSportView: View {
    var id: Int
    var sportName : String
    var ScoreKey: String
    var OddKey: String
    var PredictionKey: String
    var seasonName: String
    var sportID : Int
    @ObservedObject var logoFetcher : LogoFetcher
    
    @EnvironmentObject var settings: UserSettings
    
    @State private var showDropdownBtn = false
    @State private var showOddsDropdown = false
    @State var market = "Moneyline"

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                
                Spacer()
                
                Text(sportName)
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.white)
                                
                if(showDropdownBtn) {
                    OddsMenuButton(market: $market, isMenuVisible: $showOddsDropdown)
                        .frame(alignment: .trailing)
                }

            }
            .padding()
            .background(Color(Color.SportScoresRed))
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            
            FavoritesTabBar(sportName: sportName, ScoreKey: ScoreKey, OddKey: OddKey, PredictionKey: PredictionKey, seasonName: seasonName, sportID: sportID, logoFetcher: logoFetcher, showDropdownBtn: $showDropdownBtn)
                .environmentObject(settings)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct AccountMenuButton: View{
    @Binding var isMenuVisible : Bool
    
    var body: some View {
        ZStack {
            Button(action: {
                isMenuVisible.toggle()
            }) {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 25)
                        .foregroundColor(.white)
                }
                .padding(.top, 5)
                .padding(.bottom, 5)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct AccountDropdownMenu: View {
    @ObservedObject var logoFetcher : LogoFetcher
    @Binding var isMenuVisible : Bool
    @EnvironmentObject var settings: UserSettings
    
    @State private var menuItems: [String] = []
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                Spacer()
                VStack(spacing: 0) {
                    ForEach(menuItems, id: \.self) { item in
                        if item != "Log Out" {
                            NavigationLink(destination: destinationView(for: item)                            .accentColor(.white)) {
                                menuItemView(item: item, geometry: geometry)
                            }
                            .background(Color(.systemBackground))
                        } else {
                            Button(action: {
                                settings.loggedIn = false
                                settings.lastName = ""
                                settings.firstName = ""
                                settings.email = ""
                                settings.profileMenuSelection = ""
                                settings.userFavorites = []
                                isMenuVisible = false
                            }) {
                                menuItemView(item: item, geometry: geometry)
                            }
                            .background(Color(.systemBackground))
                        }
                        Divider()
                    }
                }
                .frame(maxWidth: geometry.size.width * 0.6)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .padding()
        }
        .onAppear{
            if settings.loggedIn {
                menuItems = ["Favorites", "Update Email", "Update Password", "Log Out"]
            } else {
                menuItems = ["Favorites", "Sign Up", "Log In"]
            }
        }
    }
    
    private func menuItemView(item: String, geometry: GeometryProxy) -> some View {
        HStack {
            Text(item)
                .foregroundColor(Color.primary)
                .padding(.vertical, 15)
                .frame(maxWidth: geometry.size.width * 0.6)
        }
        .padding(.horizontal)
    }
    
    private func destinationView(for item: String) -> some View {
        switch item {
        case "Log In":
            return AnyView(LogInView(logoFetcher: logoFetcher).environmentObject(settings))
        case "Sign Up":
            return AnyView(SignupView(logoFetcher: logoFetcher).environmentObject(settings))
        case "Update Email":
            return AnyView(LogInView(logoFetcher: logoFetcher).environmentObject(settings))
        case "Update Password":
            return AnyView(SignupView(logoFetcher: logoFetcher).environmentObject(settings))
        case "Favorites":
            return AnyView(FavoritesSelection().environmentObject(settings))
        default:
            return AnyView(EmptyView())
        }
    }
}

