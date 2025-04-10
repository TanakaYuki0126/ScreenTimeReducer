//
//  ContentView.swift
//  ScreenTimeReducer
//
//  Created by yuki on R 7/04/01.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @AppStorage("birthDate") var birthDate = ISO8601DateFormatter().string(
        from: Calendar.current.date(byAdding: .year, value: -30, to: Date()) ?? Date()
    )
    @AppStorage("expectedLifeSpan") var expectedLifeSpan: Int = 80
    
    @State private var currentDate = Date()
    @State private var settingIsExpanded: Bool = false
    var birthDateValue: Date {
        ISO8601DateFormatter().date(from: birthDate) ?? Date()
    }
    var lifeProgress: Double {
        ProgressCalculator
            .lifeProgress(
                from: birthDateValue,
                to: currentDate, expectedLifeSpan: expectedLifeSpan
            )
    }
    var yearProgress: Double {
        ProgressCalculator.yearProgress(now: currentDate)
    }
    var monthProgress: Double {
        ProgressCalculator.monthProgress(now: currentDate)
    }
    var weekProgress: Double {
        ProgressCalculator.weekProgress(now: currentDate)
    }
    var dayProgress: Double {
        ProgressCalculator.dayProgress(now: currentDate)
    }
    var body: some View {
        ScrollView{
            
            VStack(spacing: 10){
                Text("あなたの人生の進捗")
                DisclosureGroup("設定", isExpanded: $settingIsExpanded){
                    DatePicker("生年月日", selection: Binding(
                        get: {birthDateValue},
                        set: {birthDate = ISO8601DateFormatter().string(from: $0)}
                    ), displayedComponents: .date)
                    .environment(
                        \.locale,
                         Locale(identifier: "ja_JP")
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .onChange(of: birthDate) {
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    Stepper(value: $expectedLifeSpan, in: 40...120){
                        Text("想定寿命: \(expectedLifeSpan)歳")
                    }
                    .onChange(of: expectedLifeSpan) {
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                }
                GroupBox("全体進捗"){
                    ProgressView(value: lifeProgress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding()
                    HStack{
                        Text(String(format: "%.9f%", lifeProgress * 100))
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(String(format: "%%", lifeProgress * 100))
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(alignment: .leading)
                    }
                }
                GroupBox("今年"){
                    ProgressView(value: yearProgress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding()
                    HStack{
                        Text(String(format: "%.9f%", yearProgress * 100))
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(String(format: "%%", yearProgress * 100))
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(alignment: .leading)
                    }
                }
                GroupBox("今月"){
                    ProgressView(value: monthProgress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding()
                    HStack{
                        Text(String(format: "%.9f%", monthProgress * 100))
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(String(format: "%%", monthProgress * 100))
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(alignment: .leading)
                    }
                }
                GroupBox("今週"){
                    ProgressView(value: weekProgress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding()
                        .animation(.linear(duration: 0.1), value: weekProgress)
                    HStack{
                        Text(String(format: "%.9f%", weekProgress * 100))
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(String(format: "%%", weekProgress * 100))
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(alignment: .leading)
                    }
                }
                GroupBox("今日"){
                    ProgressView(value: dayProgress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding()
                        .animation(.linear(duration: 0.1), value: dayProgress)
                    HStack{
                        Text(String(format: "%.9f%", dayProgress * 100))
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(String(format: "%%", dayProgress * 100))
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(alignment: .leading)
                    }
                }
            }
            .padding()
            .onAppear{
                Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){ _ in
                    currentDate = Date()
                }
            }
        }
        
    }
}

struct ProgressCalculator{
    static func lifeProgress(from birthDate: Date, to now: Date, expectedLifeSpan: Int) -> Double {
        let currentAgeInSeconds = now.timeIntervalSince(birthDate)
        let totalExpectedSeconds = Double(expectedLifeSpan) * 365 * 24 * 60 * 60
        return min(
            Double(currentAgeInSeconds) / Double(totalExpectedSeconds),
            1.0
        )
    }
    static func yearProgress(now: Date) -> Double {
        let calendar = Calendar.current
        //現時点で今年の経過した秒数
        guard let startOfYear = calendar.date(
            from: calendar.dateComponents([.year], from: now)
        ),
              let startOfNextYear = calendar.date(
            byAdding: .year,
            value: 1,
            to: startOfYear
        )
        else{
            return 0
        }
        let elapsedTime = now.timeIntervalSince(startOfYear)
        let total = startOfNextYear.timeIntervalSince(startOfYear)
        return elapsedTime / total
    }
    static func monthProgress(now: Date) -> Double {
        let calendar = Calendar.current
        //現時点で今年の経過した秒数
        guard let startOfMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: now)
        ),
              let startOfNextMonth = calendar.date(
                byAdding: .month,
                value: 1,
                to: startOfMonth
              )
        else{
            return 0
        }
        let elapsedTime = now.timeIntervalSince(startOfMonth)
        let total = startOfNextMonth.timeIntervalSince(startOfMonth)
        return elapsedTime / total
    }
    static func weekProgress(now: Date) -> Double {
        let calendar = Calendar.current
        //現時点で今年の経過した秒数
        guard let startOfWeek = calendar.date(
            from: calendar
                .dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        ),
              let startOfNextWeek = calendar.date(
                byAdding: .weekOfYear,
                value: 1,
                to: startOfWeek
              )
        else{
            return 0
        }
        let elapsedTime = now.timeIntervalSince(startOfWeek)
        let total = startOfNextWeek.timeIntervalSince(startOfWeek)
        return elapsedTime / total
    }
    static func dayProgress(now: Date) -> Double {
        let calendar = Calendar.current
        //現時点で今年の経過した秒数
        guard let startOfDay = calendar.startOfDay(for: now) as Date?,
              let startOfNextDay = calendar.date(
                byAdding: .day,
                value: 1,
                to: startOfDay
              )
        else{
            return 0
        }
        let elapsedTime = now.timeIntervalSince(startOfDay)
        let total = startOfNextDay.timeIntervalSince(startOfDay)
        return elapsedTime / total
    }
}



#Preview {
    ContentView()
}
