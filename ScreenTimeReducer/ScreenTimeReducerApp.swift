//
//  ScreenTimeReducerApp.swift
//  ScreenTimeReducer
//
//  Created by yuki on R 7/04/01.
//

import SwiftUI
import FamilyControls

@main
struct ScreenTimeReducerApp: App {
    let center = AuthorizationCenter.shared
    var body: some Scene {
        WindowGroup {
            if let defaults = UserDefaults(suiteName: "group.TanakaYuki.ScreenTimeReducer.progress") {
                ContentView()
                    .defaultAppStorage(defaults)
                    .onAppear() {
                        Task{
                            do {
                                try await center
                                    .requestAuthorization(for: .individual)
                            } catch {
                                print("Failed to enroll in Screen Time: \(error)")
                            }
                        }
                    }
            }else{
                Text("Failed to load UserDefaults")
            }
        }
    }
}
