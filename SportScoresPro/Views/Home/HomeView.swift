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
                
                if(settings.userFavorites.count == 0){
                    WelcomeMessage()
                        .environmentObject(settings)
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
                    NavigationLink(destination: FavoritesSelection()
                        .environmentObject(settings)) {
                            HStack {
                                Image(systemName: "star.fill" )
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .padding(.top, 5)
                                    .padding(.trailing, 5)
                                    .padding(.bottom, 5)
                                    .foregroundColor(.white)
                                
                            }
                        }
                }
            }
            .background(Color(.systemGray6))
        }
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
                    ForEach(menuItems.indices, id: \.self) { index in
                        let item = menuItems[index]
                        if item != "Log Out" {
                            NavigationLink(destination: destinationView(for: item)
                                .accentColor(.white)) {
                                    menuItemView(item: item, geometry: geometry)
                                }
                                .background(Color(.systemBackground))
                        } else {
                            Button(action: {
                                settings.loggedIn = false
                                settings.lastName = ""
                                settings.firstName = ""
                                settings.email = ""
                                settings.userFavorites = []
                                isMenuVisible = false
                            }) {
                                menuItemView(item: item, geometry: geometry)
                            }
                            .background(Color(.systemBackground))
                        }
                        
                        if index != 2 {
                            SportDivider(color: .secondary, width: 2)
                        }
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
                menuItems = ["Favorites", "Profile", "Log Out"]
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
        case "Profile":
            return AnyView(AccountView(logoFetcher: logoFetcher).environmentObject(settings))
        case "Favorites":
            return AnyView(FavoritesSelection().environmentObject(settings))
        default:
            return AnyView(EmptyView())
        }
    }
}

struct WelcomeMessage: View {
    @EnvironmentObject var settings: UserSettings

    @State var notificationToggle: Bool = false
    @State var locationUsage: Bool = false
    
    var body: some View {
        Spacer(minLength: 30)
        VStack(spacing: 20) {
            Text("Welcome to Sport Scores")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.SportScoresRed)
                .multilineTextAlignment(.center)
            
            Text("Click the account button in the top right to choose your favorite sports, and they will appear here!")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.secondary)
            
            if(!settings.loggedIn) {
                Text("You can also sign up for account for $5 per month with a 7 day free trial. See the about section for more information about the benefits of creating an account")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.secondary)
            }
        }
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}


