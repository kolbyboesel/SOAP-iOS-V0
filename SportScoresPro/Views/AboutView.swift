//
//  AboutView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/29/23.
//

import Foundation
import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView{
            VStack {
                Text("Summary")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.primary)
                    .padding()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                
                Text("Highly motivated and detail-oriented computer science student with a strong foundation in Java. Skilled in data structures, web design, and software development methodologies. Seeking an internship to gain hands-on experience in a real-world setting to further develop technical skills.")
                    .font(.body)
                    .foregroundColor(Color.primary)
                    .padding()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    .overlay(
                        Rectangle()
                            .frame(height: 5)
                            .padding(.leading)
                            .padding(.trailing)
                            .foregroundColor(.SportScoresRed),
                        alignment: .bottom
                    )
                
                Text("Education")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.primary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("University of Wisconsin | Madison, WI")
                    .font(.body)
                    .bold()
                    .foregroundColor(Color.primary)
                    .padding()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                
                Text("Expected Graduation: May 2025")
                    .font(.body)
                    .foregroundColor(Color.primary)
                    .padding(.leading)
                    .padding(.bottom)
                    .padding(.trailing)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                
                Text("Wauwatosa West High School | Wauwatosa, WI")
                    .font(.body)
                    .bold()
                    .foregroundColor(Color.primary)
                    .padding()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                
                Text("June 2021 Graduation")
                    .font(.body)
                    .foregroundColor(Color.primary)
                    .padding(.leading)
                    .padding(.bottom)
                    .padding(.trailing)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    .overlay(
                        Rectangle()
                            .frame(height: 5)
                            .padding(.leading)
                            .padding(.trailing)
                            .foregroundColor(.SportScoresRed),
                        alignment: .bottom
                    )
                
                Text("Contact")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.primary)
                    .padding()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                
                contactInfo(iconName: "phone", value: "(414)-828-8543")
                contactInfo(iconName: "paperplane", value: "kolbyzboesel@gmail.com")
                contactInfo(iconName: "globe", value: "sportscorespro.com")
                
                Spacer()
            }
            .navigationTitle("About Me")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .accentColor(.white)
            
        }
    }
    func contactInfo(iconName: String, value: String) -> some View {
        HStack {
            Spacer()

            Image(systemName: iconName)
                .foregroundColor(Color.primary)

            Spacer()

            Text("\(value)")
                .foregroundColor(Color.primary)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding()

            Spacer()
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .border(Color.SportScoresRed, width: 5)
        .cornerRadius(10)
        .padding()
    }
}
