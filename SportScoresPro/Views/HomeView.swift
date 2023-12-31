//
//  HomeView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/22/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var settings: UserSettings
    @State var notificationToggle: Bool = false
    @State var locationUsage: Bool = false
    
    var body: some View {
        let homeDataArray: [HomeModel] = [
            HomeModel(id: 1, image: "1", titleText: "About", descriptionText: "Thank you for visiting Sport Scores Pro! This app is your hub for sport scores, betting odds, and more!"),
            HomeModel(id: 2, image: "1", titleText: "Account Benefits", descriptionText: "Creating an account gives you access to high quality betting picks intended to give you +EV bets. Expected value (EV) in sports betting is a way to measure the probability gap between a bettor’s expectations and the sportsbook’s."),
            HomeModel(id: 3, image: "1", titleText: "Now Available!", descriptionText: "Now when creating a Sport Scores Pro account you get access to soccer betting predictions for Europe's top 5 leagues, as well as the MLS. These predictions are based on a variety of data, and are intended to give you +EV bets."),
            HomeModel(id: 4, image: "1", titleText: "New Feature", descriptionText: "In the latest update, we've added a search by date function! Also, you can click on any game to see either an event preview, or an event recap, an example can be seen in the image.")
        ]
        TabView {
            ForEach(homeDataArray, id: \.id) { item in
                HomeModelView(homeData: item)
                    .background(Color(.systemBackground))
                
            }
        }
        .tabViewStyle(PageTabViewStyle())
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
        }
    }
}
    

struct HomeModel {
    var id: Int
    var image: String
    var titleText: String
    var descriptionText: String
    var showButton: Bool?
}

struct HomeModelView: View {
    var homeData: HomeModel
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        VStack(spacing: 20) {
            
            Image(homeData.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
                .cornerRadius(10)
                .padding(.bottom, 20)
                        
            Text(homeData.titleText)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.primary)
            
            Text(homeData.descriptionText)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.secondary)
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding()
        
    }
}
