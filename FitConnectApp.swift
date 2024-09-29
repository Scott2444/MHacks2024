//
//  FitConnectApp.swift
//  FitConnect
//
//  Created by Joseph Hughes on 9/28/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct FitConnectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var settingsModel = SettingsModel()
    var body: some Scene {
        WindowGroup {
            LoginPage()
                .environmentObject(settingsModel)
                .onAppear {
                    settingsModel.loadUserData(userID: "LEglCu8vU22p5nYojYJz")
            }
        }
    }
}
