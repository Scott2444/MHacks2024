//
//  NewSession.swift
//  FitConnect
//
//  Created by Joseph Hughes on 9/28/24.
//

import SwiftUI
import MapKit
import FirebaseFirestore

struct IdentifiableCoordinate: Identifiable {
    let id = UUID() // Unique ID for each coordinate
    var coordinate: CLLocationCoordinate2D
}

struct NewSessionPage : View {
    @Environment(\.presentationMode) var presentationMode // Used to dismiss the current view
    @Environment(\.dismiss) var dismiss
    
    @State var title: String = ""
    @State var notes: String = ""
    @State var workouts: [String] = []
    @State var people: [String] = []
    @State var dateStart: Date = Date.now
    @State var streetAddress: String = ""
    @State var city: String = ""
    @State var state: String = ""
    @State var zipCode: String = ""
    @State var dateEnd: Date = Date.now
    @State var dateEndToggle: Bool = false
    
    // Map related states
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.292072, longitude: -83.716248),
        span: MKCoordinateSpan(latitudeDelta: 0.0001, longitudeDelta: 0.0001)
    )
    @State private var selectedCoordinate: IdentifiableCoordinate?
    @State private var selectedAddress: String = "No Address Selected"
    
    @State private var showingFriendsPage = false
    
    var body: some View {
        ZStack {
            // Use the custom gradient background
            GradientBackground()
            Form {
                TextField("Title", text: $title)
                TextField("Notes", text: $notes)
                DatePicker("Start Time", selection: $dateStart, displayedComponents: [.date, .hourAndMinute])
                Toggle(isOn: $dateEndToggle) {
                    Text("Set End Time")
                }
                if (dateEndToggle){
                    DatePicker("End Time", selection: $dateEnd, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: HStack {
                    Text("Add People")
                    Spacer()
                    Button(action: {
                        showingFriendsPage = true // Show Friends Page
                    }) {
                        Label("", systemImage: "plus")
                    }
                    .sheet(isPresented: $showingFriendsPage) {
                        SelectedFriendsPage(onFriendSelected: { friendName in
                            // Add the selected friend to the people array
                            people.append(friendName)
                            showingFriendsPage = false // Dismiss the Friends Page
                        })
                    }
                }) {
                    List {
                        ForEach(people.indices, id: \.self) { index in
                            TextField("Person \(index + 1)", text: $people[index])
                                .padding(.trailing, 50) // Add padding for the delete action
                        }
                        .onDelete(perform: removePerson) // Allow swipe to delete
                    }
                }
                
                Section(header: Text("Pick Address Location")) {
                    Map(coordinateRegion: $region, interactionModes: .all, annotationItems: [selectedCoordinate].compactMap { $0 }) { coordinate in
                        MapPin(coordinate: coordinate.coordinate)
                    }
                    .frame(height: 300)
                    .onTapGesture {
                        let newCoordinate = region.center
                        selectLocation(coordinate: newCoordinate)
                    }
                    
                    Text("Selected Location: \(selectedAddress)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Section(header: HStack {
                    Text("Add Workouts")
                    Spacer()
                    Button(action: addWorkout) {
                        Label("", systemImage: "plus")
                    }
                }) {
                    List {
                        ForEach(workouts.indices, id: \.self) { index in
                            TextField("Workout \(index + 1)", text: $workouts[index])
                                .padding(.trailing, 50) // Add padding for the delete action
                        }
                        .onDelete(perform: removeWorkout) // Allow swipe to delete
                    }
                }
                
                Section {
                    Button(action: submitForm) {
                        Text("Submit")
                    }
                    .disabled(title.isEmpty || dateStart < Date.now || (dateEnd < dateStart && dateEndToggle) || selectedCoordinate == nil)
                }
            }
        }
        }
    
    // Function to handle location selection
    func selectLocation(coordinate: CLLocationCoordinate2D) {
        selectedCoordinate = IdentifiableCoordinate(coordinate: coordinate)
        reverseGeocodeLocation(coordinate)
    }
    
    func reverseGeocodeLocation(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first, error == nil {
                let streetNumber = placemark.subThoroughfare ?? ""
                streetAddress = placemark.thoroughfare ?? ""
                city = placemark.locality ?? ""
                state = placemark.administrativeArea ?? ""
                zipCode = placemark.postalCode ?? ""
                selectedAddress = """
                \(streetNumber) \(streetAddress), \(city), \(state) \(zipCode)
                """
            } else {
                selectedAddress = "Address Not Found"
            }
        }
    }
    
    func addWorkout() {
        workouts.append("") // Add a new empty workout entry
    }
    
    func removeWorkout(at offsets: IndexSet) {
        workouts.remove(atOffsets: offsets) // Remove the workout entry at the specified index
    }
    
    func addPerson() {
        people.append("")
    }
    
    func removePerson(at offsets: IndexSet) {
        people.remove(atOffsets: offsets)
    }
    
    func submitForm() {
        let db = Firestore.firestore()
        
        people.insert("LEglCu8vU22p5nYojYJz", at: 0)
        // Prepare the session data to be saved
        let sessionData: [String: Any] = [
            "title": title,
            "notes": notes,
            "workouts": workouts,
            "people": people,
            "starttime": dateStart,
            "location": "\(streetAddress), \(city), \(state) \(zipCode)",
            "coordinate": GeoPoint(latitude: selectedCoordinate?.coordinate.latitude ?? 0.0, longitude: selectedCoordinate?.coordinate.longitude ?? 0.0),
            "endtime": dateEndToggle ? dateEnd : nil ?? nil // Save endtime only if toggle is on
        ]
        // Add session to Firestore
        db.collection("posts").addDocument(data: sessionData) { error in
            if let error = error {
                print("Error adding session: \(error)")
            } else {
                print("Session added successfully!")
                dismiss() // Dismiss the view after submission
            }
        }
    }
}

#Preview {
    NewSessionPage()
}
