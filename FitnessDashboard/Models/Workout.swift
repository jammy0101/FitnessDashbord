//
//  Workout.swift
//  FitnessDashboard
//
//  Created by RASHID on 24/04/2026.
//

import Foundation
import SwiftData

enum WorkoutType: String, Codable, CaseIterable {
    case running = "Running"; case cycling = "Cycling"
    case gym = "Gym";      case yoga = "Yoga"
    case walking = "Walking"

    var icon: String {
        switch self {
        case .running: return "figure.run"
        case .cycling: return "bicycle"
        case .gym:     return "dumbbell.fill"
        case .yoga:    return "figure.mind.and.body"
        case .walking: return "figure.walk"
        }
    }
}

@Model
class Workout {
    var typeRaw: String
    var duration: Int
    var calories: Int
    var date: Date

    init(type: WorkoutType, duration: Int, calories: Int) {
        self.typeRaw = type.rawValue
        self.duration = duration
        self.calories = calories
        self.date = Date()
    }

    var type: WorkoutType {
        WorkoutType(rawValue: typeRaw) ?? .running
    }
}
