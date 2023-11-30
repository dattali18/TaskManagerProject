//
//  TaksApp.swift
//  Taks
//
//  Created by Daniel Attali on 11/30/23.
//

import SwiftUI

@main
struct TaksApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabBarView()
                .onAppear {
                    MockDataManager.shared.CreateMockData()
                }
        }
    }
}
