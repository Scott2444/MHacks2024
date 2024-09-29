//
//  AddFriend.swift
//  FitConnect
//
//  Created by Joseph Hughes on 9/29/24.
//

import SwiftUI

struct AddFriendPage: View {
    @State private var searchText: String = ""
    var body: some View {
        NavigationView {
                VStack {
                    // Search Bar
                    TextField("Search...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding()
                    
                    Spacer() // Blank screen below the search bar
                }
            }
            .navigationBarTitle("Search", displayMode: .inline)
    }
}


#Preview {
    AddFriendPage()
}
