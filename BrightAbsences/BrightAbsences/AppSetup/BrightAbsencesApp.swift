//
//  BrightAbsencesApp.swift
//  BrightAbsences
//
//  Created by Umair on 06/08/2026.
//

import SwiftUI

@main
struct BrightAbsencesApp: App {
    @StateObject private var coordinator = NavigationCoordinator(path: NavigationPath())
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
        }
    }
}
