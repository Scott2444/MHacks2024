//
//  AccountPage.swift
//  FitConnect
//
//  Created by Joseph Hughes on 9/28/24.
//

import SwiftUI

struct User: Identifiable {
    var id = UUID()
    var name: String
    var bio: String
    var location: String
    var recentPR: String
    var goals: String
    var profileImage: Image // This can also be a URL for an online image
    var friends: [String]
}

struct AccountPage: View {
    @EnvironmentObject var settingsModel: SettingsModel
    
    var body: some View {
        if let user = settingsModel.user { VStack(alignment: .leading) {
                // Profile Picture
                VStack { // Nested VStack for centering
                    user.profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    
                    // User Name centered
                    Text(user.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                }
                .padding() // Padding for the centered section
                .frame(maxWidth: .infinity) // Allowing it to expand to center
                
                Text("Bio:")
                    .font(.headline)
                    .padding(.horizontal)
                    .fontWeight(.bold)
                // User Bio
                Text(user.bio)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.horizontal)
                
                if settingsModel.isLocationEnabled{
                    Text("Primary Gym:")
                        .multilineTextAlignment(.leading)
                        .padding(.top)
                        .padding(.horizontal)
                        .fontWeight(.bold)
                    
                    Text(user.location)
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.horizontal)
                }
                
                if settingsModel.isPRsEnabled {
                    Text("Most Recent PR:")
                        .padding(.top)
                        .padding(.horizontal)
                        .fontWeight(.bold)
                    Text(user.recentPR)
                        .padding(.horizontal)
                        .padding(.horizontal)
                }
                if settingsModel.isGoalsEnabled {
                    // User Goals
                    VStack(alignment: .leading) {
                        Text("Goals:")
                            .font(.headline)
                        
                        Text(user.goals)
                            .font(.body)
                            .padding(.horizontal)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                }
            }
            Spacer()
        }
        }
}



#Preview {
    AccountPage()
        .environmentObject(SettingsModel()) // This is only needed for the preview
}
