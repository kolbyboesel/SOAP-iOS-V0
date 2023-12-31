//
//  TabBar.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/23/23.
//

import SwiftUI

extension Color {
    static let SportScoresRed = Color(red: 0.95686274509, green: 0.26274509803, blue: 0.21176470588)
}

struct TabBar: View {
    @State private var selectedTab = 0
    
    var body: some View {
        
        VStack {
            // Your content views here
            switch selectedTab {
            case 0:
                NavigationView {
                    HomeView()
                    
                }
            case 1:
                NavigationView {
                    ScoresView()
                    
                }
            case 2:
                NavigationView {
                    OddsView()
                    
                }
            case 3:
                NavigationView {
                    AccountView()
                    
                }
            default:
                NavigationView {
                    HomeView()
                    
                }
            }
            
            HStack {
                Spacer()
                
                Button(action: { self.selectedTab = 0 }) {
                    VStack {
                            Image(systemName: "house.circle")
                                .resizable()
                                .foregroundColor(selectedTab == 0 ? .SportScoresRed : .gray)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 30)

                            Text("Home")
                                .font(.system(size: 12))
                                .foregroundColor(selectedTab == 0 ? .SportScoresRed : .gray)
                        }
                }
                Spacer()
                
                Button(action: { self.selectedTab = 1 }) {
                    VStack {
                            Image(systemName: "sportscourt.circle")
                                .resizable()
                                .foregroundColor(selectedTab == 1 ? .SportScoresRed : .gray)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 30)

                            Text("Home")
                                .font(.system(size: 12))
                                .foregroundColor(selectedTab == 1 ? .SportScoresRed : .gray)
                        }
                }
                Spacer()
                Button(action: { self.selectedTab = 2 }) {
                    VStack {
                            Image(systemName: "dollarsign.circle")
                                .resizable()
                                .foregroundColor(selectedTab == 2 ? .SportScoresRed : .gray)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 30)

                            Text("Home")
                                .font(.system(size: 12))
                                .foregroundColor(selectedTab == 2 ? .SportScoresRed : .gray)
                        }
                }
                Spacer()
                Button(action: { self.selectedTab = 3 }) {
                    VStack {
                            Image(systemName: "ellipsis.circle")
                                .resizable()
                                .foregroundColor(selectedTab == 3 ? .SportScoresRed : .gray)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 30)

                            Text("Home")
                                .font(.system(size: 12))
                                .foregroundColor(selectedTab == 3 ? .SportScoresRed : .gray)
                        }
                }
                Spacer()
                
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
        }
    }
}



