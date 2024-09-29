//
//  LoginPage.swift
//  FitConnect
//
//  Created by Joseph Hughes on 9/28/24.
//

import SwiftUI

struct LoginPage: View {
    @EnvironmentObject var settingsModel: SettingsModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Use the custom gradient background
                GradientBackground()
                VStack {
                    // Add the FitConnect logo image at the top
                    Image("FitConnectLogo") // Make sure the image is added to your Assets.xcassets
                        .resizable() // Allows the image to be resized
                        .scaledToFit() // Maintain aspect ratio
                        .frame(height: 150) // Set the height of the logo
                        .padding(.bottom, 10) // Add some spacing below the logo
                        .padding(.top, 30)
                        .padding(.leading, 30)
                    
                    Text("FitConnect")
                        .font(.largeTitle)
                        .padding(.bottom, 40)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    if isLoading {
                        ProgressView()
                            .padding()
                    }
                    
                    Button(action: {
                        // Simulate login
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isLoading = false
                            isLoggedIn = true
                        }
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding(.top)
                    
                    Button(action: {
                        // Forgot password action
                    }) {
                        Text("Forgot Password?")
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding()
                
                NavigationLink(destination: HomePage().environmentObject(settingsModel), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
        }}
}


#Preview {
    LoginPage()
}
