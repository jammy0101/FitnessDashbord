//
//  StepsChart.swift
//  FitnessDashboard
//
//  Created by RASHID on 24/04/2026.
//

import SwiftUI

import Charts

struct StepsChart: View {
    let data: [DaySteps]
    let goal = 10_000

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("This Week").font(.headline)
            Text("Goal: 10,000 steps/day").font(.caption).foregroundColor(.secondary)

            Chart(data) { item in
                BarMark(
                    x: .value("Day", item.day),
                    y: .value("Steps", item.steps)
                )
                .foregroundStyle(item.steps >= goal ? Color.green : Color.purple)
                .cornerRadius(6)

                RuleMark(y: .value("Goal", goal))
                    .lineStyle(StrokeStyle(dash: [5]))
                    .foregroundStyle(.orange)
            }
            .frame(height: 180)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    StepsChart(data: [
        DaySteps(day: "Mon", steps: 8000),
        DaySteps(day: "Tue", steps: 10000),
        DaySteps(day: "Wed", steps: 6000)
    ])
}
