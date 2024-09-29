//
//  ProgressPage.swift
//  FitConnect
//
//  Created by Joseph Hughes on 9/28/24.
//

import SwiftUI

struct WorkoutView : View {
    var workout: Workout
    var body: some View{
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                // People names on the left
                Text(workout.name)
                Text("|")
                Spacer()
                
                // Address on the right
                Text(workout.pr)
                if (workout.reps != 0){
                    Text("Reps: " + String((workout.reps)!))
                        .font(.body)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1)) // Background color for the post box
        .cornerRadius(8)
    }
}

struct ProgressPage: View {
    var body: some View {
        let workouts = [Workout(name: "Benchpress", pr: "205 kg", reps: 7), Workout(name: "Squat", pr: "295 kg", reps: 4), Workout(name: "1 Mile", pr: "8:04")]
        ZStack {
            // Use the custom gradient background
            GradientBackground()
            VStack {
                List {
                    ForEach(workouts) { workout in
                        WorkoutView(workout: workout)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 2)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 10)
                    }
                }
            }
        }
    }
}

#Preview {
    ProgressPage()
}
