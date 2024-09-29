//
//  SelectFriendPage.swift
//  FitConnect
//
//  Created by Joseph Hughes on 9/28/24.
//

import SwiftUI


let friendData = [
    Friend(name: "Joe82", profilePicture: Image("accountIcon"))
]

struct SelectedFriendsPage: View {
    var sortedFriends: [Friend] {
        friendData.sorted { $0.name < $1.name }
    }
    
    // Callback to return the selected friend's name
    var onFriendSelected: (String) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                // Use the custom gradient background
                GradientBackground()
                List(sortedFriends) { friend in
                    HStack {
                        // Profile picture
                        friend.profilePicture
                            .resizable()
                            .scaledToFill()
                            .frame(width: 25, height: 25)
                            .clipShape(Circle()) // Make it circular
                        
                        Text(friend.name)
                            .font(.headline)
                        
                        Spacer()
                    }
                    .contentShape(Rectangle()) // Makes the entire row tappable
                    .onTapGesture {
                        // Call the callback when a friend is selected
                        onFriendSelected(friend.name)
                    }
                }
            }
            }
    }
}

#Preview {
    SelectedFriendsPage(onFriendSelected: { _ in })
}

