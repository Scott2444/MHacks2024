//
//  HomePage.swift
//  FitConnect
//
//  Created by Joseph Hughes on 9/28/24.
//

import SwiftUI
import FirebaseFirestore
import MapKit

struct Post: Identifiable {
    var id = UUID()
    var title: String
    var users: [User] // You can create a separate model for Account if needed
    var location: String
    var startTime: Date
    var endTime: Date?
    var workouts: [String]
    var notes: String?
}

struct Workout : Identifiable {
    var id = UUID()
    var name : String
    var pr : String
    var reps : Int?
    
    init(id: UUID = UUID(), name: String, pr: String, reps: Int? = 0) {
        self.id = id
        self.name = name
        self.pr = pr
        self.reps = reps
    }
}

struct HomePage: View {
    var body: some View {
        NavigationView{
            ZStack {
                // Use the custom gradient background
                GradientBackground()
                
                TabView {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    FriendsView()
                        .tabItem {
                            Image(systemName: "person.3.fill")
                            Text("Friends")
                            Button(action: {}) {
                                NavigationLink(destination: FriendsPage()){
                                }
                            }
                        }
                    SessionView()
                        .tabItem {
                            Image(systemName: "plus.circle.fill")
                            Text("New Session")
                        }
                    ProgressView()
                        .tabItem {
                            Image(systemName: "dumbbell.fill")
                            Text("Progress")
                            Button(action: {}) {
                                NavigationLink(destination: ProgressPage()){
                                }
                            }
                        }
                    AccountView()
                        .tabItem {
                            Image(systemName: "person.crop.circle.fill")
                            Text("Account")
                            Button(action: {}) {
                                NavigationLink(destination: AccountPage()){
                                }
                            }
                        }
                }
            }
        }
    }
}

struct HomeView : View {
    @StateObject private var postsViewModel = PostsViewModel()

    var body: some View {
        VStack {
            List {
                ForEach(postsViewModel.posts) { post in
                    PostView(post: post)
                }
            }
        }
        .onAppear {
            postsViewModel.loadPosts()
        }
    }
}

struct SessionView : View {
    var body: some View{
        NavigationView() {
            NewSessionPage()
        }
    }
}

struct FriendsView : View {
    @EnvironmentObject var settingsModel: SettingsModel
    var body: some View{
        NavigationView {
            FriendsPage()
                .navigationBarItems(trailing: NavigationLink(destination: AddFriendPage().environmentObject(settingsModel)) {
                    Image(systemName: "plus")
                        .font(.title) // Adjust size of the icon
                        .foregroundColor(.blue)
                })
        }
    }
}

struct ProgressView : View {
    var body: some View{
        NavigationView() {
            ProgressPage()
        }
    }
}

struct AccountView : View {
    @EnvironmentObject var settingsModel: SettingsModel
    var body: some View{
        NavigationView {
            AccountPage()
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: NavigationLink(destination: SettingsPage().environmentObject(settingsModel)) {
                    Image(systemName: "gearshape.fill")
                        .font(.title) // Adjust size of the icon
                        .foregroundColor(.blue)
                })
        }
    }
}

struct PostView: View {
    var post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Date and time at the top
            Text("\(post.startTime)")
                .font(.headline)
                .padding(.bottom, 5)
            
            HStack {
                // People names on the left
                VStack(alignment: .leading) {
                    if post.users.count != 0 {ForEach(post.users) { user in
                        HStack {
                            
                            // Display image (replace with Image or custom logic)
                            Image(.accountIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .clipShape(Circle())
                                .padding(.trailing, 4)
                            // Display account name
                            Text(user.name)
                                .font(.body)
                        }
                    }
                    } else {
                        HStack {
                            
                        // Display image (replace with Image or custom logic)
                        Image(.accountIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .clipShape(Circle())
                            .padding(.trailing, 4)
                        // Display account name
                        Text("Scott244")
                            .font(.body)
                    }
                    }
                }
                Text("|")
                Spacer()
                
                // Address on the right
                Text(post.location)
                    .font(.body)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1)) // Background color for the post box
        .cornerRadius(8)
    }
}

class PostsViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    private var db = Firestore.firestore()

    // Load posts and fetch user details
    func loadPosts() {
        db.collection("posts").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error)")
                return
            }

            if let snapshot = snapshot {
                self.posts = []
                let documents = snapshot.documents

                for doc in documents {
                    let data = doc.data()
                    let title = data["title"] as? String ?? "No title"
                    let location = data["location"] as? String ?? "No location"
                    let startTime = (data["startTime"] as? Timestamp)?.dateValue() ?? Date()
                    let endTime = (data["endTime"] as? Timestamp)?.dateValue()
                    let workouts = data["workouts"] as? [String] ?? []
                    let notes = data["notes"] as? String
                    let userIDs = data["people"] as? [String] ?? []

                    // Fetch user details for the given userIDs
                    self.fetchUserDetails(for: userIDs) { users in
                        let post = Post(title: title, users: users, location: location, startTime: startTime, endTime: endTime, workouts: workouts, notes: notes)
                        self.posts.append(post)
                    }
                }
            }
        }
    }

    // Fetch user details and map them to the User struct
    func fetchUserDetails(for userIDs: [String], completion: @escaping ([User]) -> Void) {
        var users = [User]()
        let dispatchGroup = DispatchGroup()

        for userID in userIDs {
            dispatchGroup.enter()
            
            // Fetch each user by ID
            let userRef = db.collection("users").document(userID)
            userRef.getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    let name = data?["username"] as? String ?? "Unknown"
                    let bio = data?["bio"] as? String ?? "No bio"
                    let location = data?["location"] as? String ?? "Unknown location"
                    let recentPR = data?["recentPR"] as? String ?? "No recent PR"
                    let goals = data?["goals"] as? String ?? "No goals"
                    let profileImage = Image(systemName: "person.circle") // Placeholder image

                    let user = User(id: UUID(), name: name, bio: bio, location: location, recentPR: recentPR, goals: goals, profileImage: profileImage, friends: [""])
                    users.append(user)
                } else {
                    print("User not found for ID: \(userID)")
                }
                dispatchGroup.leave()
            }
        }

        // Once all user data has been fetched, return the results
        dispatchGroup.notify(queue: .main) {
            completion(users)
        }
    }
}


#Preview {
    HomePage()
}
