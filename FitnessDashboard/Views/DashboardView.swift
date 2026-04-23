//
//  DashboardView.swift
//  FitnessDashboard
//
//  Created by RASHID on 24/04/2026.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Dashboard", systemImage: "chart.bar.fill") }
            WorkoutsView()
                .tabItem { Label("Workouts", systemImage: "dumbbell.fill") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(.purple)
    }
}

// Dashboard tab
struct DashboardView: View {

    @StateObject var health = HealthManager()

    @Query(sort: \Workout.date, order: .reverse)
    var workouts: [Workout]

    let goal = 10_000

    var progress: Double {
        min(Double(health.todaySteps) / Double(goal), 1.0)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // 🔥 Gradient Background
                LinearGradient(
                    colors: [.black, .purple.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 25) {

                        // 🔥 BIG RING SECTION
                        VStack(spacing: 12) {
                            ZStack {
                                Ring(progress: progress, color: .purple)
                                    .frame(width: 160, height: 160)

                                VStack {
                                    Text("\(Int(progress * 100))%")
                                        .font(.title.bold())
                                        .foregroundColor(.white)

                                    Text("Goal")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }

                            Text("\(health.todaySteps)")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)

                            Text("of \(goal) steps")
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.top)

                        // 📊 CHART CARD
                        StepsChart(data: health.weeklySteps)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(20)
                            .padding(.horizontal)

                        // 🏋️ WORKOUT CARD
                        if !workouts.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {

                                HStack {
                                    Text("Recent Workouts")
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Spacer()
                                }

                                ForEach(workouts.prefix(3)) { w in
                                    HStack(spacing: 15) {

                                        Image(systemName: w.type.icon)
                                            .font(.title2)
                                            .foregroundColor(.purple)
                                            .frame(width: 50, height: 50)
                                            .background(Color.white.opacity(0.1))
                                            .cornerRadius(12)

                                        VStack(alignment: .leading) {
                                            Text(w.type.rawValue)
                                                .foregroundColor(.white)
                                                .font(.headline)

                                            Text("\(w.duration) min • \(w.calories) kcal")
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.7))
                                        }

                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(14)
                                }
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(20)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle("Dashboard")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .task {
            await health.setup()
        }
    }
}
struct Ring: View {
    var progress: Double
    var color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 14)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [color, .pink]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: color.opacity(0.5), radius: 10)
                .animation(.easeInOut(duration: 1.0), value: progress)
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: Workout.self)
}
