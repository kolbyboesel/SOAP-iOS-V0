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
            
            // Custom Tab Bar
            HStack {
                Spacer()
                
                Button(action: { self.selectedTab = 0 }) {
                    Image(systemName: "house.circle")
                        .foregroundColor(selectedTab == 0 ? .SportScoresRed : .gray)
                }
                Spacer()
                
                Button(action: { self.selectedTab = 1 }) {
                    Image(systemName: "sportscourt.circle")
                        .foregroundColor(selectedTab == 1 ? .SportScoresRed : .gray)
                }
                Spacer()
                Button(action: { self.selectedTab = 2 }) {
                    Image(systemName: "dollarsign.circle")
                        .foregroundColor(selectedTab == 2 ? .SportScoresRed : .gray)
                }
                Spacer()
                Button(action: { self.selectedTab = 3 }) {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(selectedTab == 3 ? .SportScoresRed : .gray)
                }
                Spacer()
                
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
        }
    }
}



