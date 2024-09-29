//
//  FriendsPage.swift
//  FitConnect
//
//  Created by Joseph Hughes on 9/28/24.
//

import SwiftUI
import FirebaseFirestore

struct Friend : Identifiable {
    let id = UUID()
    let name: String
    let profilePicture: Image
}

struct FriendsPage: View {
    @EnvironmentObject var settingsModel: SettingsModel
    @State private var friends: [Friend] = [] // List of friends' User objects
    
    var body: some View {
        NavigationView {
            ZStack {
                // Use the custom gradient background
                GradientBackground()
                Group {
                    List(friends) { friend in
                        HStack {
                            // Profile picture
                            friend.profilePicture
                                .resizable()
                                .scaledToFill()
                                .frame(width: 25, height: 25)
                                .clipShape(Circle()) // Make it circular
                            
                            // Friend's name
                            Text(friend.name)
                                .font(.headline)
                        }
                    }
                }
            }
        }
            .onAppear(perform: fetchFriends)
            .navigationTitle("Friends")
        }
    
    func fetchFriends() {
        if let user = settingsModel.user {
            fetchUserDetails(for: user.friends) { fetchedFriends in
                self.friends = fetchedFriends
            }
        }
    }
    
    // Fetch user details and map them to the User struct using DispatchGroup
    func fetchUserDetails(for userIDs: [String], completion: @escaping ([Friend]) -> Void) {
        var users = [Friend]()
        let dispatchGroup = DispatchGroup()
        let db = Firestore.firestore() // Use your Firestore instance

        for userID in userIDs {
            dispatchGroup.enter()
            
            let userRef = db.collection("users").document(userID)
            userRef.getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    let name = data?["username"] as? String ?? "Unknown"
                    let profileImage = Image(systemName: "person.circle") // Placeholder image
                    
                    let user = Friend(name: name, profilePicture: profileImage)
                    users.append(user)
                } else {
                    print("User not found for ID: \(userID)")
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(users)
        }
    }
}

#Preview {
    FriendsPage()
}
