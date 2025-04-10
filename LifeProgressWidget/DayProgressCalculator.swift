//
//  DayProgressCalculator.swift
//  LifeProgressWidgetExtension
//
//  Created by yuki on R 7/04/06.
//

import Foundation

struct DayProgressCalculator {
    static func progress(for date: Date) -> Double{
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return 0
        }
        let elapsed = date.timeIntervalSince(startOfDay)
        let total = startOfNextDay.timeIntervalSince(startOfDay)
        return elapsed / total
    }
}
