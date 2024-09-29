//
//  Settings.swift
//  FitConnect
//
//  Created by Joseph Hughes on 9/28/24.
//

import SwiftUI



struct SettingsPage: View {
    @State private var username: String = "User123"  // Account settings state
    @EnvironmentObject var settingsModel: SettingsModel
    
    var body: some View {
        NavigationView {
            Form {
                // Account Settings Section
                Section(header: Text("Account Settings")) {
                    // Navigation to deeper account editing view
                    NavigationLink(destination: EditAccountPage()) {
                        Text("Edit Account Details")
                    }
                }

                // Toggles Section
                Section(header: Text("Preferences")) {
                    Toggle(isOn: $settingsModel.isLocationEnabled) {
                        Text("Share Location")
                    }
                    Toggle(isOn: $settingsModel.isPRsEnabled) {
                        Text("Share Recent PR")
                    }
                    Toggle(isOn: $settingsModel.isGoalsEnabled) {
                        Text("Share Goals")
                    }
                }

                // Log Out Section
                Section {
                    Button(action: {
                        logOut()
                    }) {
                        Text("Log Out")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    // Function for logging out (for now, just a placeholder)
    func logOut() {
        print("Logged out!")
        // Add actual logout functionality here
    }
}

// Edit Account Page (Placeholder for detailed account editing)
struct EditAccountPage: View {
    @State private var username: String = "user@example.com"
    @State private var bio: String = ""
    @State private var goals: String = ""

    var body: some View {
        ZStack {
            // Use the custom gradient background
            GradientBackground()
            Form {
                TextField("Username", text: $username)
                    .keyboardType(.emailAddress)
                TextField("Bio", text: $bio)
                TextField("Goals", text: $goals)
                Button(action: {
                    saveChanges()
                }) {
                    Text("Save Changes")
                }
            }
            .navigationTitle("Edit Account")
        }
    }

    func saveChanges() {
        print("Account details updated")
        // Add save logic here
    }
}

#Preview {
    SettingsPage()
}

 


