//
//  LifeProgressCalculator.swift
//  LifeProgressWidgetExtension
//
//  Created by yuki on R 7/04/06.
//

import Foundation

struct LifeProgressCalculator {
    static func progress(from birthDate: Date, lifeSpan: Int, to currentDate: Date) -> Double {
        let totalSeconds = Double(lifeSpan * 365 * 24 * 60 * 60)
        let elaplsedSeconds = currentDate.timeIntervalSince(birthDate)
        return elaplsedSeconds / totalSeconds
    }
}
