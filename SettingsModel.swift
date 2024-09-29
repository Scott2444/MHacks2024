//
//  SettingsModel.swift
//  FitConnect
//
//  Created by Joseph Hughes on 9/28/24.
//

import SwiftUI
import FirebaseFirestore

// This class holds the toggle states for location, PRs, and goals.
// It conforms to ObservableObject so that views observing it will update automatically.
class SettingsModel: ObservableObject {
    @Published var isLocationEnabled: Bool = true
    @Published var isPRsEnabled: Bool = true
    @Published var isGoalsEnabled: Bool = true
    @Published var user: User?
    
    private var db = Firestore.firestore()

    // Method to load user data from Firestore
    func loadUserData(userID: String) {
        let userRef = db.collection("users").document(userID)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let preferences = data?["preferences"] as? [String: Any]
                self.isLocationEnabled = preferences?["shareLocation"] as? Bool ?? false
                self.isPRsEnabled = preferences?["sharePrs"] as? Bool ?? false
                self.isGoalsEnabled = preferences?["shareGoals"] as? Bool ?? false
                
                let username = data?["username"] as? String ?? "Unknown"
                let bio = data?["bio"] as? String ?? "No bio"
                let location = data?["location"] as? String ?? "No location"
                let recentPR = (data?["prs"] as? [String])?.first ?? "No PR"
                let goals = (data?["goals"] as? [String])?.first ?? "No goals"
                let friends = (data?["friends"] as? [String])?.first ?? ""
                
                // Update the user object
                self.user = User(name: username, bio: bio, location: location, recentPR: recentPR, goals: goals, profileImage: Image(systemName: "person.circle"), friends: [friends])
            } else {
                print("User data not found")
            }
        }
    }
}

