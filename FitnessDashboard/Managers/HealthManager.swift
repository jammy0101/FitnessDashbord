//
//  HealthManager.swift
//  FitnessDashboard
//
//  Created by RASHID on 24/04/2026.
//

import Foundation
import HealthKit
import Combine

@MainActor
class HealthManager: ObservableObject {
    let store = HKHealthStore()
    @Published var todaySteps = 0
    @Published var weeklySteps: [DaySteps] = []

    func setup() async {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        let stepType = HKQuantityType(.stepCount)
        try? await store.requestAuthorization(toShare: [], read: [stepType])
        todaySteps = await fetchSteps(for: Date())
        weeklySteps = await fetchWeek()
    }

    func fetchSteps(for date: Date) async -> Int {
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        let pred = HKQuery.predicateForSamples(withStart: start, end: end)
        let stepType = HKQuantityType(.stepCount)

        return await withCheckedContinuation { cont in
            let q = HKStatisticsQuery(quantityType: stepType,
                quantitySamplePredicate: pred, options: .cumulativeSum) { _, s, _ in
                let steps = s?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                cont.resume(returning: Int(steps))
            }
            store.execute(q)
        }
    }

    func fetchWeek() async -> [DaySteps] {
        let days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
        var result: [DaySteps] = []
        for i in (0..<7).reversed() {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
            let steps = await fetchSteps(for: date)
            let dayIdx = Calendar.current.component(.weekday, from: date)
            result.append(DaySteps(day: days[(dayIdx-2+7)%7], steps: steps))
        }
        return result
    }
}

struct DaySteps: Identifiable {
    let id = UUID()
    let day: String; let steps: Int
}
